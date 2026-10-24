import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/amount_display.dart';
import '../../../design_system/components/amount_keypad.dart';
import '../../../design_system/components/category_icon.dart';
import '../../../design_system/components/form_group.dart';
import '../../../design_system/components/form_header.dart';
import '../../../design_system/components/segmented_control.dart';
import '../../../design_system/components/undo_toast.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../design_system/tokens/text_scale.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/date_labels.dart';
import '../../../l10n/failure_messages.dart';
import '../../../services/app_settings.dart';
import '../../../services/clock_provider.dart';
import '../application/accounts.dart';
import '../application/money_providers.dart';
import '../application/transactions.dart';
import '../widgets/pickers.dart';
import 'money_view_models.dart';

final _log = Logger('money.form');

enum _Mode { expense, income, transfer }

/// SH-02 «Новый расход / доход» и SH-03 «Новый перевод»; с [editId] — правка операции
/// (SCR-32). Обязательна только сумма (FR-FIN-05); сумма — из своей клавиатуры
/// с калькулятором, разрядность — по валюте счёта (FR-FIN-06).
class TransactionFormScreen extends ConsumerStatefulWidget {
  final TransactionKind initialKind;
  final EntityId? fromAccountId;
  final EntityId? editId;

  const TransactionFormScreen({
    super.key,
    required this.initialKind,
    this.fromAccountId,
  }) : editId = null;

  const TransactionFormScreen.edit(EntityId id, {super.key})
    : editId = id,
      initialKind = TransactionKind.expense,
      fromAccountId = null;

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  late _Mode _mode = switch (widget.initialKind) {
    TransactionKind.income => _Mode.income,
    TransactionKind.transferOut || TransactionKind.transferIn => _Mode.transfer,
    _ => _Mode.expense,
  };
  var _amount = const AmountExpression();
  var _credit = const AmountExpression();
  var _editingCredit = false;
  EntityId? _accountId;
  EntityId? _fromId;
  EntityId? _toId;
  EntityId? _categoryId;
  late LocalDate _date = ref.read(todayProvider);
  var _refund = false;
  final _note = TextEditingController();
  final _noteFocus = FocusNode();
  EntityId? _editGroupId;
  var _ready = false;
  var _busy = false;
  String? _error;

  bool get _isEdit => widget.editId != null;

  @override
  void initState() {
    super.initState();
    _noteFocus.addListener(() => setState(() {}));
    _init();
  }

  @override
  void dispose() {
    _note.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final accounts = await ref.read(activeAccountsProvider.future);
    final ids = accounts.map((a) => a.account.id).toList();
    if (_isEdit) {
      final parts = await ref.read(operationProvider(widget.editId!).future);
      if (parts.isNotEmpty) _prefill(parts);
    } else {
      final last = await ref.read(lastAccountIdProvider.future);
      _accountId = ids.contains(last) ? last : ids.firstOrNull;
      _fromId = widget.fromAccountId ?? _accountId;
      _toId = ids.where((id) => id != _fromId).firstOrNull;
    }
    if (mounted) setState(() => _ready = true);
  }

  void _prefill(List<FinTransaction> parts) {
    final t = parts.first;
    _date = t.date;
    _note.text = t.note ?? '';
    if (t.transferGroupId != null) {
      final out = parts.firstWhere(
        (p) => p.kind == TransactionKind.transferOut,
      );
      final into = parts.firstWhere(
        (p) => p.kind == TransactionKind.transferIn,
      );
      _mode = _Mode.transfer;
      _editGroupId = t.transferGroupId;
      _fromId = out.accountId;
      _toId = into.accountId;
      _amount = AmountExpression.fromMoney(out.amount);
      _credit = AmountExpression.fromMoney(into.amount);
      _categoryId = out.categoryId ?? into.categoryId;
    } else {
      _mode = t.kind == TransactionKind.income ? _Mode.income : _Mode.expense;
      _accountId = t.accountId;
      _categoryId = t.categoryId;
      _refund = t.isRefund;
      _amount = AmountExpression.fromMoney(t.amount);
    }
  }

  Account? _account(List<AccountWithBalance> all, EntityId? id) =>
      all.where((a) => a.account.id == id).firstOrNull?.account;

  CategoryKind get _categoryKind => _mode == _Mode.expense || _refund
      ? CategoryKind.expense
      : CategoryKind.income;

  bool get _dirty => !_isEdit && !_amount.isEmpty;

  void _key(String key, Currency debitCurrency, Currency creditCurrency) {
    setState(() {
      if (_editingCredit) {
        _credit = _credit.input(key, creditCurrency);
      } else {
        _amount = _amount.input(key, debitCurrency);
      }
      _error = null;
    });
  }

  Future<bool> _confirmDiscard() async {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.discardTitle),
        content: Text(l.discardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.keepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: c.danger),
            child: Text(l.discardConfirm),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _cancel() async {
    if (!_dirty || await _confirmDiscard()) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _save({required Money debit, Money? credit}) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    final navigator = Navigator.of(context);
    final delete = ref.read(deleteTransactionProvider);
    setState(() => _busy = true);
    try {
      final note = _note.text;
      final Result<FinTransaction> saved;
      if (_mode == _Mode.transfer) {
        final r = await ref
            .read(recordTransferProvider)
            .call(
              TransferInput(
                fromAccountId: _fromId!,
                toAccountId: _toId!,
                debit: debit,
                credit: credit,
                categoryId: _categoryId,
                date: _date,
                note: note,
              ),
              existingGroupId: _editGroupId,
            );
        saved = r.fold((pair) => Ok(pair.first), Err.new);
      } else {
        saved = await ref
            .read(recordIncomeExpenseProvider)
            .call(
              IncomeExpenseInput(
                kind: _mode == _Mode.income
                    ? TransactionKind.income
                    : TransactionKind.expense,
                amount: debit,
                accountId: _accountId!,
                categoryId: _categoryId,
                date: _date,
                note: note,
                isRefund: _mode == _Mode.income && _refund,
              ),
              existingId: widget.editId,
            );
      }
      switch (saved) {
        case Ok(:final value):
          navigator.pop();
          final amount = debit.format();
          showUndoToast(
            messenger,
            colors,
            message: switch (_mode) {
              _Mode.expense => l.savedExpense(amount),
              _Mode.income => l.savedIncome(amount),
              _Mode.transfer => l.savedTransfer(amount),
            },
            undoLabel: l.undo,
            onUndo: _isEdit ? null : () => delete(value.id),
          );
        case Err(:final failure):
          setState(() {
            _busy = false;
            _error = failureMessage(l, failure);
          });
      }
    } catch (e, s) {
      // Неожиданная ошибка: в журнал — только тип (DATA_SECURITY §7), данные остаются в форме.
      _log.severe('save failed', e.runtimeType, s);
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l.saveFailed;
        });
      }
    }
  }

  Future<void> _createCash(Currency base) async {
    final l = AppLocalizations.of(context);
    final r = await ref
        .read(saveAccountProvider)
        .call(
          AccountInput(
            name: l.cashAccountName,
            type: AccountType.cash,
            currency: base,
          ),
        );
    if (r case Ok(:final value)) {
      setState(() {
        _accountId = value.id;
        _fromId ??= value.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final base = ref.watch(baseCurrencyProvider).value ?? Currency.kzt;
    final accounts = ref.watch(activeAccountsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final today = ref.watch(todayProvider);

    final transfer = _mode == _Mode.transfer;
    final account = _account(accounts, transfer ? _fromId : _accountId);
    final toAccount = _account(accounts, _toId);
    final debitCurrency = account?.currency ?? base;
    final creditCurrency = toAccount?.currency ?? debitCurrency;
    final crossCurrency = transfer && debitCurrency != creditCurrency;
    final debit = _amount.evaluate(debitCurrency);
    final credit = crossCurrency ? _credit.evaluate(creditCurrency) : null;

    // Перевод между «в бюджете» и «только отслеживать» — расход или доход (§6.4).
    final effects = transfer && account != null && toAccount != null
        ? transferEffects(account.budgetMode, toAccount.budgetMode)
        : null;
    final transferCategoryKind = effects == null
        ? null
        : effects.out == ReportEffect.expense
        ? CategoryKind.expense
        : effects.into == ReportEffect.income
        ? CategoryKind.income
        : null;

    final sameAccounts = transfer && _fromId != null && _fromId == _toId;
    final canSave =
        _ready &&
        !_busy &&
        debit != null &&
        debit.isPositive &&
        account != null &&
        (!transfer ||
            (toAccount != null &&
                !sameAccounts &&
                (!crossCurrency || (credit != null && credit.isPositive)) &&
                (transferCategoryKind == null || _categoryId != null)));

    final rateMissing =
        !transfer &&
        account != null &&
        account.currency != base &&
        ref.watch(rateAtProvider((account.currency, base, _date))).value ==
            null;

    final title = _isEdit
        ? l.editOperation
        : switch (_mode) {
            _Mode.expense => l.newExpense,
            _Mode.income => l.newIncome,
            _Mode.transfer => l.newTransfer,
          };

    final category = categories.where((x) => x.id == _categoryId).firstOrNull;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && await _confirmDiscard() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: c.bgGrouped,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FormHeader(
                title: title,
                cancelLabel: l.cancel,
                doneLabel: l.done,
                onCancel: _cancel,
                onDone: canSave
                    ? () => _save(debit: debit, credit: credit)
                    : null,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    if (!_isEdit)
                      SegmentedControl<_Mode>(
                        segments: [
                          (_Mode.expense, l.expense),
                          (_Mode.income, l.income),
                          (_Mode.transfer, l.transfer),
                        ],
                        selected: _mode,
                        onChanged: (m) => setState(() {
                          // Сумма сохраняется при переключении (SH-02); категория — нет.
                          if (m != _mode) _categoryId = null;
                          _mode = m;
                          _refund = false;
                          _editingCredit = false;
                          _fromId ??= _accountId;
                          _error = null;
                        }),
                      ),
                    AmountDisplay(
                      expression: _amount.display(),
                      symbol: debitCurrency.symbol,
                      isZero: debit == null || debit.isZero,
                      active: !_editingCredit,
                      onTap: crossCurrency
                          ? () => setState(() => _editingCredit = false)
                          : null,
                      semanticsLabel: (debit ?? Money.zero(debitCurrency))
                          .format(),
                      totalLine: _amount.hasOperator && debit != null
                          ? l.amountTotal(debit.format())
                          : null,
                    ),
                    if (rateMissing)
                      _Note(text: l.noRateWarning(account.currency.code)),
                    if (_error != null) _Note(text: _error!, error: true),
                    if (!transfer)
                      _QuickCategories(
                        kind: _categoryKind,
                        selected: _categoryId,
                        allLabel: l.allCategories,
                        onSelected: (id) => setState(() => _categoryId = id),
                        onAll: () async {
                          final picked = await showCategoryPicker(
                            context,
                            categories: categories,
                            kind: _categoryKind,
                            selected: _categoryId,
                          );
                          if (picked != null) {
                            setState(() => _categoryId = picked.id);
                          }
                        },
                      ),
                    const SizedBox(height: 12),
                    if (transfer)
                      ..._transferGroups(
                        context,
                        accounts: accounts,
                        categories: categories,
                        account: account,
                        toAccount: toAccount,
                        crossCurrency: crossCurrency,
                        debit: debit,
                        credit: credit,
                        creditCurrency: creditCurrency,
                        categoryKind: transferCategoryKind,
                        category: category,
                        sameAccounts: sameAccounts,
                      )
                    else
                      FormGroup(
                        children: [
                          FormRow(
                            label: l.fieldCategory,
                            value: category?.name,
                            onTap: () async {
                              final picked = await showCategoryPicker(
                                context,
                                categories: categories,
                                kind: _categoryKind,
                                selected: _categoryId,
                              );
                              if (picked != null) {
                                setState(() => _categoryId = picked.id);
                              }
                            },
                          ),
                          if (accounts.isEmpty)
                            FormRow(
                              label: l.createCashAccount,
                              labelColor: c.accent,
                              onTap: () => _createCash(base),
                            )
                          else
                            FormRow(
                              label: l.fieldAccount,
                              value: account == null
                                  ? null
                                  : '${account.name}, ${accounts.firstWhere((a) => a.account.id == account.id).balance.format()}',
                              onTap: () async {
                                final picked = await showAccountPicker(
                                  context,
                                  accounts: accounts,
                                  selected: _accountId,
                                );
                                if (picked != null) {
                                  setState(() {
                                    if (picked.currency != account?.currency) {
                                      // Разрядность новой валюты может быть другой.
                                      _amount = const AmountExpression();
                                    }
                                    _accountId = picked.id;
                                  });
                                }
                              },
                            ),
                          _dateRow(context, today),
                          _NoteField(
                            label: l.fieldNote,
                            hint: l.fieldNoteHint,
                            controller: _note,
                            focusNode: _noteFocus,
                          ),
                          if (_mode == _Mode.income)
                            FormRow(
                              label: l.fieldRefund,
                              trailing: Switch(
                                value: _refund,
                                onChanged: (v) => setState(() {
                                  _refund = v;
                                  _categoryId = null;
                                }),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              if (!_noteFocus.hasFocus)
                AmountKeypad(
                  labels: AmountKeypadLabels.of(l),
                  allowComma:
                      (_editingCredit ? creditCurrency : debitCurrency)
                          .minorUnits >
                      0,
                  onKey: (k) => _key(k, debitCurrency, creditCurrency),
                  onClear: () => setState(() {
                    if (_editingCredit) {
                      _credit = const AmountExpression();
                    } else {
                      _amount = const AmountExpression();
                    }
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateRow(BuildContext context, LocalDate today) {
    final l = AppLocalizations.of(context);
    return FormRow(
      label: l.fieldDate,
      value: dayLabel(l, _date, today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date.toDateTime(),
          firstDate: DateTime(2000),
          lastDate: today.addDays(365 * 5).toDateTime(),
          locale: const Locale('ru'),
        );
        if (picked != null) {
          setState(() => _date = LocalDate.fromDateTime(picked));
        }
      },
    );
  }

  List<Widget> _transferGroups(
    BuildContext context, {
    required List<AccountWithBalance> accounts,
    required List<Category> categories,
    required Account? account,
    required Account? toAccount,
    required bool crossCurrency,
    required Money? debit,
    required Money? credit,
    required Currency creditCurrency,
    required CategoryKind? categoryKind,
    required Category? category,
    required bool sameAccounts,
  }) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    String accountValue(Account? a) {
      if (a == null) return '';
      final b = accounts.where((x) => x.account.id == a.id).firstOrNull;
      return b == null ? a.name : '${a.name}, ${b.balance.format()}';
    }

    Future<void> pick(bool from) async {
      final picked = await showAccountPicker(
        context,
        accounts: accounts,
        selected: from ? _fromId : _toId,
      );
      if (picked == null) return;
      setState(() {
        if (from) {
          if (picked.currency != account?.currency) {
            _amount = const AmountExpression();
          }
          _fromId = picked.id;
        } else {
          if (picked.currency != toAccount?.currency) {
            _credit = const AmountExpression();
          }
          _toId = picked.id;
        }
        _categoryId = null;
        _editingCredit = false;
      });
    }

    final rate = debit != null && credit != null && credit.isPositive
        ? TransferAmounts(debit, credit).displayRate
        : null;

    return [
      FormGroup(
        footer: sameAccounts ? l.chooseDifferentAccounts : null,
        footerIsError: sameAccounts,
        children: [
          FormRow(
            label: l.fieldFrom,
            value: accountValue(account),
            onTap: () => pick(true),
          ),
          FormRow(
            label: l.swapAccounts,
            labelColor: c.accent,
            trailing: Icon(Icons.swap_vert, color: c.accent),
            onTap: () => setState(() {
              final from = _fromId;
              _fromId = _toId;
              _toId = from;
              final a = _amount;
              _amount = crossCurrency ? _credit : _amount;
              _credit = crossCurrency ? a : _credit;
              _categoryId = null;
            }),
          ),
          FormRow(
            label: l.fieldTo,
            value: accountValue(toAccount),
            onTap: () => pick(false),
          ),
          if (crossCurrency)
            FormRow(
              label: l.fieldCredited,
              value: '${_credit.display()} ${creditCurrency.symbol}',
              labelColor: _editingCredit ? c.accent : null,
              onTap: () => setState(() => _editingCredit = true),
            ),
        ],
      ),
      if (rate != null && account != null)
        _Note(
          text: l.rateLine(
            account.currency.code,
            formatRate(rate),
            creditCurrency.symbol,
          ),
        ),
      const SizedBox(height: AppSpacing.groupGap),
      FormGroup(
        footer: categoryKind == null
            ? null
            : categoryKind == CategoryKind.expense
            ? l.transferAsExpense
            : l.transferAsIncome,
        children: [
          if (categoryKind != null)
            FormRow(
              label: l.fieldCategory,
              value: category?.name,
              onTap: () async {
                final picked = await showCategoryPicker(
                  context,
                  categories: categories,
                  kind: categoryKind,
                  selected: _categoryId,
                );
                if (picked != null) setState(() => _categoryId = picked.id);
              },
            ),
          _dateRow(context, ref.read(todayProvider)),
          _NoteField(
            label: l.fieldNote,
            hint: l.fieldNoteHint,
            controller: _note,
            focusNode: _noteFocus,
          ),
        ],
      ),
    ];
  }
}

/// Подпись под суммой: предупреждение или ошибка (не только цветом — текстом).
class _Note extends StatelessWidget {
  final String text;
  final bool error;
  const _Note({required this.text, this.error = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.footnote.copyWith(
          color: error ? c.danger : c.textSecondary,
        ),
      ),
    );
  }
}

/// Ряд из 5 категорий + «Все» (DESIGN_SYSTEM §8.11). Выбранная — заливка цветом
/// и полужирная подпись, диктор говорит «Продукты, выбрано».
class _QuickCategories extends ConsumerWidget {
  final CategoryKind kind;
  final EntityId? selected;
  final String allLabel;
  final ValueChanged<EntityId> onSelected;
  final VoidCallback onAll;

  const _QuickCategories({
    required this.kind,
    required this.selected,
    required this.allLabel,
    required this.onSelected,
    required this.onAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final quick = ref.watch(quickCategoriesProvider(kind));
    Widget cell({
      required Widget icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap,
    }) => Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                icon,
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: c.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final cat in quick)
          cell(
            icon: CategoryIcon(
              iconKey: cat.icon,
              colorIndex: cat.colorIndex,
              size: 44,
              outlined: cat.id != selected,
            ),
            label: cat.name,
            isSelected: cat.id == selected,
            onTap: () => onSelected(cat.id),
          ),
        cell(
          icon: const CategoryIcon(
            iconKey: 'dots',
            colorIndex: 6,
            size: 44,
            outlined: true,
          ),
          label: allLabel,
          isSelected: false,
          onTap: onAll,
        ),
      ],
    );
  }
}

/// Поле комментария внутри группы формы. Пока оно в фокусе, своя клавиатура скрыта.
class _NoteField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;

  const _NoteField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // При крупном шрифте подпись и поле — в две строки, иначе подпись не помещается.
    final large = isLargeText(context);
    final input = TextField(
      controller: controller,
      focusNode: focusNode,
      maxLength: FinTransaction.maxNoteLength,
      textAlign: TextAlign.end,
      textInputAction: TextInputAction.done,
      style: AppTypography.body.copyWith(color: c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: c.textTertiary),
        border: InputBorder.none,
        counterText: '',
        semanticCounterText: '',
      ),
    );
    final labelText = Text(
      label,
      style: AppTypography.body.copyWith(color: c.textPrimary),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: large
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 8), labelText, input],
              )
            : Row(
                children: [
                  labelText,
                  const SizedBox(width: 12),
                  Expanded(child: input),
                ],
              ),
      ),
    );
  }
}
