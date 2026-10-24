import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/app_settings.dart';
import '../../../services/clock_provider.dart';
import '../application/money_providers.dart';

/// Производные данные для экранов «Денег». Формулы — только из `core` (D-060):
/// здесь данные лишь собираются вместе.

/// Общий баланс (§6.3) по последним курсам; null — данные ещё грузятся.
final totalBalanceProvider = Provider<TotalBalance?>((ref) {
  final base = ref.watch(baseCurrencyProvider).value;
  final accounts = ref.watch(activeAccountsProvider).value;
  if (base == null || accounts == null) return null;
  final rates = ref.watch(exchangeRatesProvider(base)).value ?? const [];
  return totalBalance(accounts, base, rates, ref.watch(todayProvider));
});

/// Доходы и расходы текущего месяца (§6.4).
final monthSummaryProvider = Provider<PeriodSummary?>((ref) {
  final base = ref.watch(baseCurrencyProvider).value;
  final period = DatePeriod.monthOf(ref.watch(todayProvider));
  final list = ref.watch(
    transactionsProvider(TransactionFilter(period: period)),
  );
  if (base == null || !list.hasValue) return null;
  return periodSummary(list.value!, period, base);
});

/// Счета по id (включая архивные) — названия в строках операций.
final accountsByIdProvider = Provider<Map<EntityId, Account>>(
  (ref) => {
    for (final a in ref.watch(allAccountsProvider).value ?? const <Account>[])
      a.id: a,
  },
);

/// Категории по id.
final categoriesByIdProvider = Provider<Map<EntityId, Category>>(
  (ref) => {
    for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
      c.id: c,
  },
);

/// 5 категорий для ряда в форме (SH-02): сначала недавно использованные этого типа,
/// затем стандартные по порядку. «Без категории» в ряд не попадает.
final quickCategoriesProvider = Provider.family<List<Category>, CategoryKind>((
  ref,
  kind,
) {
  final all = ref.watch(categoriesProvider).value ?? const <Category>[];
  bool usable(Category c) =>
      c.kind == kind &&
      !c.hidden &&
      c.defaultKey != uncategorizedExpenseKey &&
      c.defaultKey != uncategorizedIncomeKey;
  final byId = {for (final c in all) c.id: c};
  final recent =
      ref
          .watch(transactionsProvider(const TransactionFilter(limit: 100)))
          .value ??
      const <FinTransaction>[];
  final result = <Category>[];
  for (final t in recent) {
    final c = byId[t.categoryId];
    if (c != null && usable(c) && !result.contains(c)) result.add(c);
    if (result.length == 5) return result;
  }
  for (final c in all.where((c) => usable(c) && c.isTopLevel)) {
    if (!result.contains(c)) result.add(c);
    if (result.length == 5) break;
  }
  return result;
});
