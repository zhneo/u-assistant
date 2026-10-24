import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/currency_list.dart';
import '../../../design_system/components/form_group.dart';
import '../../../design_system/components/form_header.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/currency_names.dart';
import '../../../l10n/failure_messages.dart';
import '../../../services/app_settings.dart';
import '../application/accounts.dart';
import '../application/money_providers.dart';
import '../widgets/money_labels.dart';

/// Лист «Новый счёт» (SCR-34) и правка счёта (SCR-35): название, тип, валюта,
/// начальный баланс, «учитывать в бюджете», «скрыть из общего баланса».
/// Валюта и режим бюджета заблокированы, если у счёта есть операции (FR-FIN-03, D-064).
class AccountFormScreen extends ConsumerStatefulWidget {
  final EntityId? editId;
  const AccountFormScreen({super.key, this.editId});

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _name = TextEditingController();
  final _opening = TextEditingController();
  var _type = AccountType.card;
  Currency? _currency;
  var _onBudget = true;
  var _hidden = false;
  var _loaded = false;
  var _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    if (widget.editId == null) {
      _loaded = true;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    final all = await ref.read(allAccountsProvider.future);
    final a = all.where((x) => x.id == widget.editId).firstOrNull;
    if (a != null) {
      _name.text = a.name;
      _type = a.type;
      _currency = a.currency;
      _opening.text = a.openingBalance.isZero
          ? ''
          : a.openingBalance.format(showZeroMinor: true, withSymbol: false);
      _onBudget = a.budgetMode == BudgetMode.onBudget;
      _hidden = a.hidden;
    }
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    super.dispose();
  }

  Future<void> _save(Currency currency) async {
    final l = AppLocalizations.of(context);
    Money? opening;
    if (_opening.text.trim().isNotEmpty) {
      final parsed = Money.parse(_opening.text.replaceAll('−', '-'), currency);
      if (parsed case Err(:final failure)) {
        setState(() => _error = failureMessage(l, failure));
        return;
      }
      opening = parsed.value;
    }
    setState(() => _busy = true);
    final r = await ref
        .read(saveAccountProvider)
        .call(
          AccountInput(
            name: _name.text,
            type: _type,
            currency: currency,
            openingBalance: opening,
            budgetMode: _onBudget ? BudgetMode.onBudget : BudgetMode.tracking,
            hidden: _hidden,
          ),
          existingId: widget.editId,
        );
    if (!mounted) return;
    switch (r) {
      case Ok():
        Navigator.of(context).pop();
      case Err(:final failure):
        setState(() {
          _busy = false;
          _error = failureMessage(l, failure);
        });
    }
  }

  Future<void> _pickType() async {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final picked = await showModalBottomSheet<AccountType>(
      context: context,
      showDragHandle: true,
      backgroundColor: c.surfaceGrouped,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final t in AccountType.values)
              ListTile(
                minTileHeight: 52,
                title: Text(accountTypeLabel(l, t)),
                trailing: t == _type
                    ? Icon(Icons.check, color: c.accent)
                    : null,
                selected: t == _type,
                onTap: () => Navigator.pop(context, t),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        _type = picked;
        // Кредиты и вклады по умолчанию «только отслеживать» (R1).
        if (widget.editId == null) {
          _onBudget =
              picked != AccountType.credit && picked != AccountType.deposit;
        }
      });
    }
  }

  Future<void> _pickCurrency(Currency current) async {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final picked = await showModalBottomSheet<Currency>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: c.surfaceGrouped,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: CurrencyList(
            selected: current,
            searchHint: l.searchHint,
            onSelected: (x) => Navigator.pop(context, x),
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _currency = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final base = ref.watch(baseCurrencyProvider).value ?? Currency.kzt;
    final currency = _currency ?? base;
    final locked =
        widget.editId != null &&
        (ref.watch(accountHasTransactionsProvider(widget.editId!)).value ??
            true);
    final canSave = _loaded && !_busy && _name.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: c.bgGrouped,
      body: SafeArea(
        child: Column(
          children: [
            FormHeader(
              title: widget.editId == null ? l.accountNew : l.accountEdit,
              cancelLabel: l.cancel,
              doneLabel: l.save,
              onCancel: () => Navigator.of(context).pop(),
              onDone: canSave ? () => _save(currency) : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FormGroup(
                    footer: _error,
                    footerIsError: _error != null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _name,
                          autofocus: widget.editId == null,
                          maxLength: Account.maxNameLength,
                          textCapitalization: TextCapitalization.sentences,
                          style: AppTypography.body.copyWith(
                            color: c.textPrimary,
                          ),
                          decoration: InputDecoration(
                            labelText: l.accountName,
                            hintText: l.accountNameHint,
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                      FormRow(
                        label: l.accountType,
                        value: accountTypeLabel(l, _type),
                        onTap: _pickType,
                      ),
                      FormRow(
                        label: l.accountCurrency,
                        value:
                            '${currency.code}, ${currencyName(currency.code)}',
                        onTap: locked ? null : () => _pickCurrency(currency),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _opening,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          style: AppTypography.body.copyWith(
                            color: c.textPrimary,
                          ),
                          decoration: InputDecoration(
                            labelText: l.accountOpening,
                            hintText: '0',
                            suffixText: currency.symbol,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (locked)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                      child: Text(
                        l.accountCurrencyLocked,
                        style: AppTypography.footnote.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.groupGap),
                  FormGroup(
                    footer: locked ? l.budgetModeLocked : l.accountOnBudgetHint,
                    children: [
                      FormRow(
                        label: l.accountOnBudget,
                        trailing: Switch(
                          value: _onBudget,
                          onChanged: locked
                              ? null
                              : (v) => setState(() => _onBudget = v),
                        ),
                      ),
                      FormRow(
                        label: l.accountHidden,
                        trailing: Switch(
                          value: _hidden,
                          onChanged: (v) => setState(() => _hidden = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
