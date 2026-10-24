import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/form_group.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../design_system/components/section_header.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/failure_messages.dart';
import '../../../routing/routes.dart';
import '../../../services/app_settings.dart';
import '../../../services/clock_provider.dart';
import '../application/money_providers.dart';
import '../widgets/money_labels.dart';
import '../widgets/operation_list.dart';

/// SCR-35 «Счёт»: баланс, «Перевести», «Изменить баланс», операции счёта по дням
/// и настройки (изменить, архив).
class AccountScreen extends ConsumerWidget {
  final EntityId accountId;
  const AccountScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final account = (ref.watch(allAccountsProvider).value ?? const <Account>[])
        .where((a) => a.id == accountId)
        .firstOrNull;
    if (account == null) {
      return LargeTitleScaffold(title: '', backLabel: l.accountsTitle);
    }
    final balance = (ref.watch(activeAccountsProvider).value ?? const [])
        .where((a) => a.account.id == accountId)
        .firstOrNull
        ?.balance;
    final base = ref.watch(baseCurrencyProvider).value ?? Currency.kzt;
    // Все операции, чтобы перевод показывал второй счёт; фильтр по счёту — здесь.
    final all = ref
        .watch(transactionsProvider(const TransactionFilter()))
        .value;
    final mine = all == null ? null : _withPartners(all, accountId);

    return LargeTitleScaffold(
      title: account.name,
      backLabel: l.accountsTitle,
      background: c.bgGrouped,
      sliver: mine == null || mine.isEmpty
          ? null
          : OperationSliverList(
              items: groupByDay(mine, base, relativeTo: accountId),
              relativeTo: accountId,
            ),
      children: [
        Text(
          accountTypeLabel(l, account.type),
          style: AppTypography.subhead.copyWith(color: c.textSecondary),
        ),
        if (account.isArchived)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l.accountArchived,
              style: AppTypography.subhead.copyWith(color: c.warning),
            ),
          ),
        if (balance != null) ...[
          const SizedBox(height: 12),
          Text(
            balance.format(),
            style: AppTypography.amountL.copyWith(color: c.textPrimary),
          ),
          if (account.type == AccountType.credit && balance.isNegative)
            Text(
              l.accountCreditHint,
              style: AppTypography.footnote.copyWith(color: c.textSecondary),
            ),
        ],
        const SizedBox(height: 16),
        if (!account.isArchived)
          FormGroup(
            children: [
              FormRow(
                label: l.accountTransfer,
                labelColor: c.accent,
                onTap: () => context.push(
                  AppRoutes.newOperation(
                    TransactionKind.transferOut,
                    from: accountId,
                  ),
                ),
              ),
              FormRow(
                label: l.accountAdjust,
                labelColor: c.accent,
                onTap: balance == null
                    ? null
                    : () => _adjust(context, ref, account, balance),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.groupGap),
        FormGroup(
          children: [
            FormRow(
              label: l.edit,
              onTap: () => context.push(AppRoutes.editAccount(accountId)),
            ),
            FormRow(
              label: account.isArchived ? l.accountUnarchive : l.accountArchive,
              onTap: () => ref
                  .read(setAccountArchivedProvider)
                  .call(accountId, archived: !account.isArchived),
            ),
          ],
        ),
        if (mine != null && mine.isNotEmpty) SectionHeader(l.moneyOperations),
      ],
    );
  }

  /// Операции счёта плюс вторые части их переводов — для подписи «Карта → Наличные».
  static List<FinTransaction> _withPartners(
    List<FinTransaction> all,
    EntityId accountId,
  ) {
    final groups = {
      for (final t in all)
        if (t.accountId == accountId && t.transferGroupId != null)
          t.transferGroupId,
    };
    return [
      for (final t in all)
        if (t.accountId == accountId ||
            (t.transferGroupId != null && groups.contains(t.transferGroupId)))
          t,
    ];
  }

  /// «Изменить баланс» (FR-FIN-02): фактический остаток → корректировка на разницу.
  Future<void> _adjust(
    BuildContext context,
    WidgetRef ref,
    Account account,
    Money balance,
  ) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: balance.format(showZeroMinor: true, withSymbol: false),
    );
    String? error;
    final result = await showDialog<Money>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l.accountAdjustTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  suffixText: account.currency.symbol,
                  errorText: error,
                ),
              ),
              const SizedBox(height: 8),
              Text(l.accountAdjustHint),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                final parsed = Money.parse(
                  controller.text.replaceAll('−', '-'),
                  account.currency,
                );
                parsed.fold(
                  (m) => Navigator.pop(context, m),
                  (f) => setState(() => error = failureMessage(l, f)),
                );
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result == null) return;
    await ref
        .read(adjustBalanceProvider)
        .call(account.id, result, ref.read(todayProvider));
  }
}
