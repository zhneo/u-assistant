import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/category_icon.dart';
import '../../../design_system/components/form_group.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../design_system/components/undo_toast.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/date_labels.dart';
import '../../../routing/routes.dart';
import '../../../services/clock_provider.dart';
import '../application/money_providers.dart';
import '../widgets/money_labels.dart';
import 'money_view_models.dart';

/// SCR-32 «Операция»: сумма, категория, счёт, дата, комментарий; у перевода — обе стороны.
/// «Изменить» открывает форму SH-02/SH-03; «Удалить» убирает в корзину (перевод — целиком).
class OperationScreen extends ConsumerWidget {
  final EntityId operationId;
  const OperationScreen({super.key, required this.operationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final parts = ref.watch(operationProvider(operationId)).value;
    final accounts = ref.watch(accountsByIdProvider);
    final categories = ref.watch(categoriesByIdProvider);
    final today = ref.watch(todayProvider);
    if (parts == null || parts.isEmpty) {
      return LargeTitleScaffold(title: l.operationTitle, backLabel: l.tabMoney);
    }
    final t = parts.first;
    final isTransfer = t.transferGroupId != null;
    final out = isTransfer
        ? parts.firstWhere((p) => p.kind == TransactionKind.transferOut)
        : t;
    final into = isTransfer
        ? parts.firstWhere((p) => p.kind == TransactionKind.transferIn)
        : null;
    final category = categories[out.categoryId ?? into?.categoryId];
    String accountName(EntityId id) => accounts[id]?.name ?? l.archivedAccount;

    final kindLabel = switch (t.kind) {
      TransactionKind.expense => l.expense,
      TransactionKind.income => l.income,
      TransactionKind.adjustment => l.adjustment,
      _ => l.transfer,
    };
    final amountText = isTransfer ? out.amount.format() : signedAmount(t);

    return LargeTitleScaffold(
      title: kindLabel,
      backLabel: l.tabMoney,
      background: c.bgGrouped,
      actions: [
        if (t.kind != TransactionKind.adjustment)
          TextButton(
            onPressed: () => context.push(AppRoutes.editOperation(t.id)),
            style: TextButton.styleFrom(
              foregroundColor: c.accent,
              minimumSize: const Size(48, 48),
            ),
            child: Text(l.edit, style: AppTypography.body),
          ),
      ],
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            if (isTransfer)
              const CategoryIcon.neutral(iconKey: 'transfer', size: 44)
            else if (t.kind == TransactionKind.adjustment)
              const CategoryIcon.neutral(iconKey: 'adjustment', size: 44)
            else
              CategoryIcon(
                iconKey: category?.icon ?? 'dots',
                colorIndex: category?.colorIndex ?? 6,
                size: 44,
              ),
            const SizedBox(width: AppSpacing.rowGap),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amountText,
                  style: AppTypography.amountL.copyWith(
                    color: t.kind == TransactionKind.income
                        ? c.positive
                        : c.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FormGroup(
          children: [
            if (category != null)
              FormRow(label: l.fieldCategory, value: category.name),
            if (isTransfer) ...[
              FormRow(label: l.fieldFrom, value: accountName(out.accountId)),
              FormRow(label: l.fieldTo, value: accountName(into!.accountId)),
              FormRow(label: l.debited, value: out.amount.format()),
              FormRow(label: l.credited, value: into.amount.format()),
              if (out.amount.currency != into.amount.currency)
                FormRow(
                  label: l.rate,
                  value: formatRate(
                    TransferAmounts(out.amount, into.amount).displayRate!,
                  ),
                ),
            ] else
              FormRow(label: l.fieldAccount, value: accountName(t.accountId)),
            FormRow(label: l.fieldDate, value: dayLabel(l, t.date, today)),
            if (t.note != null) FormRow(label: l.fieldNote, value: t.note),
            if (t.isRefund) FormRow(label: l.fieldRefund),
          ],
        ),
        const SizedBox(height: AppSpacing.groupGap),
        FormGroup(
          children: [
            FormRow(
              label: l.delete,
              labelColor: c.danger,
              onTap: () => _delete(context, ref, t, isTransfer),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    FinTransaction t,
    bool isTransfer,
  ) async {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isTransfer ? l.operationDeleteTransferTitle : l.operationDeleteTitle,
        ),
        content: Text(l.operationDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: c.danger),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(deleteTransactionProvider).call(t.id);
    if (context.mounted) context.pop();
    // Восстановление из корзины — веха M3 (SCR-73); пока без «Отменить».
    showUndoToast(messenger, c, message: l.deletedOperation);
  }
}
