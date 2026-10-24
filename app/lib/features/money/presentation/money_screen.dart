import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../design_system/components/section_header.dart';
import '../../../design_system/components/segmented_control.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../design_system/tokens/text_scale.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/date_labels.dart';
import '../../../routing/routes.dart';
import '../../../services/app_settings.dart';
import '../../../services/clock_provider.dart';
import '../application/money_providers.dart';
import '../widgets/operation_list.dart';
import 'money_view_models.dart';

enum _Segment { overview, operations }

/// SCR-30 «Деньги: обзор» и SCR-31 «Операции» (переключатель вверху экрана).
/// В M1 без бюджетов, долгов и аналитики — они появятся в M4 (ROADMAP).
class MoneyScreen extends ConsumerStatefulWidget {
  const MoneyScreen({super.key});

  @override
  ConsumerState<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends ConsumerState<MoneyScreen> {
  var _segment = _Segment.overview;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accounts = ref.watch(activeAccountsProvider);
    final segment = SegmentedControl<_Segment>(
      segments: [
        (_Segment.overview, l.moneyOverview),
        (_Segment.operations, l.moneyOperations),
      ],
      selected: _segment,
      onChanged: (s) => setState(() => _segment = s),
    );
    final hasAccounts = accounts.value?.isNotEmpty ?? true;

    if (_segment == _Segment.operations) {
      return LargeTitleScaffold(
        title: l.tabMoney,
        sliver: const _AllOperations(),
        children: [const SizedBox(height: 12), segment],
      );
    }
    return LargeTitleScaffold(
      title: l.tabMoney,
      actions: [
        IconButton(
          tooltip: l.accountsTitle,
          onPressed: () => context.push(AppRoutes.accounts),
          icon: Icon(
            Icons.account_balance_wallet_outlined,
            color: context.colors.accent,
          ),
        ),
      ],
      children: [
        const SizedBox(height: 12),
        segment,
        if (!hasAccounts)
          EmptyState(
            title: l.moneyEmptyTitle,
            message: l.moneyEmptyMessage,
            actionLabel: l.addAccount,
            onAction: () => context.push(AppRoutes.newAccount),
          )
        else ...[
          const _TotalBalance(),
          const _MonthSummary(),
          SectionHeader(
            l.accounts,
            actionLabel: l.addAccount,
            onAction: () => context.push(AppRoutes.newAccount),
          ),
          for (final a in accounts.value ?? const <AccountWithBalance>[])
            if (!a.account.hidden)
              AccountRow(
                item: a,
                onTap: () => context.push(AppRoutes.account(a.account.id)),
              ),
          SectionHeader(
            l.recentOperations,
            actionLabel: l.allOperations,
            onAction: () => setState(() => _segment = _Segment.operations),
          ),
          const _RecentOperations(),
        ],
      ],
    );
  }
}

/// Общий баланс — выразительная деталь экрана (§6.3, AC-16).
class _TotalBalance extends ConsumerWidget {
  const _TotalBalance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final total = ref.watch(totalBalanceProvider);
    final today = ref.watch(todayProvider);
    if (total == null) return const SizedBox(height: 80);
    String? caption;
    if (!total.isComplete) {
      caption = l.totalIncomplete(
        total.missingRates.map((x) => x.code).join(', '),
      );
    } else if (total.oldestRateDate != null) {
      final base = ref.watch(baseCurrencyProvider).value!;
      final rates = ref.watch(exchangeRatesProvider(base)).value ?? const [];
      // Подпись — по курсу с самой ранней датой: «по курсу USD 470,50 от 20 октября».
      final rate = rates
          .where((r) => r.validFrom == total.oldestRateDate)
          .firstOrNull;
      if (rate != null) {
        caption = l.totalByRate(
          rate.currency.code,
          formatRate(rate.rate),
          shortDate(rate.validFrom, today),
        );
      }
    }
    final amount = total.total.format();
    return Semantics(
      label: [l.totalBalance, amount, ?caption].join(', '),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.totalBalance,
              style: AppTypography.footnote.copyWith(color: c.textSecondary),
            ),
            Text(
              amount,
              style: AppTypography.amountL.copyWith(color: c.textPrimary),
            ),
            if (caption != null)
              Text(
                caption,
                style: AppTypography.footnote.copyWith(
                  color: total.isComplete ? c.textSecondary : c.warning,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Две колонки между разделителями (DESIGN_SYSTEM §8.7): расходы и доходы месяца.
/// «Можно потратить» появится вместе с бюджетами и регулярными платежами (M4).
class _MonthSummary extends ConsumerWidget {
  const _MonthSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final s = ref.watch(monthSummaryProvider);
    final month = monthPrepositional(ref.watch(todayProvider).month);
    Widget column(String title, Money? value, Color color) => Semantics(
      label: '$title, ${value?.format() ?? ''}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.subhead.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value?.format() ?? '',
                style: AppTypography.amountM.copyWith(color: c.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
    final expenses = column(l.expensesIn(month), s?.expense, c.textPrimary);
    final income = column(l.incomeIn(month), s?.income, c.positive);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: c.separator,
              width: AppSpacing.hairline,
            ),
          ),
        ),
        // При крупном шрифте две колонки перестраиваются в одну (UI_SPECIFICATION §0.2).
        child: isLargeText(context)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  expenses,
                  Divider(color: c.separator),
                  income,
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: expenses),
                    VerticalDivider(color: c.separator, width: 24),
                    Expanded(child: income),
                  ],
                ),
              ),
      ),
    );
  }
}

class _RecentOperations extends ConsumerWidget {
  const _RecentOperations();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final list = ref
        .watch(transactionsProvider(const TransactionFilter(limit: 10)))
        .value;
    if (list == null) return const SizedBox.shrink();
    final base = ref.watch(baseCurrencyProvider).value ?? Currency.kzt;
    final rows = groupByDay(list, base).whereType<OperationItem>().take(5);
    if (rows.isEmpty) {
      return EmptyState(
        title: l.operationsEmptyTitle,
        message: l.operationsEmptyMessage,
      );
    }
    return Column(
      children: [
        for (final r in rows)
          OperationRow(transaction: r.transaction, partner: r.partner),
      ],
    );
  }
}

/// SCR-31: все операции по дням и итог выборки. Фильтры и поиск — шаг 4 вехи M1.
class _AllOperations extends ConsumerWidget {
  const _AllOperations();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final list = ref
        .watch(transactionsProvider(const TransactionFilter()))
        .value;
    final base = ref.watch(baseCurrencyProvider).value ?? Currency.kzt;
    if (list == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyState(
          title: l.operationsEmptyTitle,
          message: l.operationsEmptyMessage,
        ),
      );
    }
    final items = groupByDay(list, base);
    final count = items.whereType<OperationItem>().length;
    final s = periodSummary(
      list,
      DatePeriod(list.last.date, list.first.date),
      base,
    );
    final totals = [
      l.operationsCount(count),
      if (!s.expense.isZero) '−${s.expense.format()}',
      if (!s.income.isZero) '+${s.income.format()}',
    ].join(', ');
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              totals,
              style: AppTypography.subhead.copyWith(color: c.textSecondary),
            ),
          ),
        ),
        OperationSliverList(items: items),
      ],
    );
  }
}
