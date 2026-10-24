import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../services/clock_provider.dart';
import 'accounts.dart';
import 'exchange_rates.dart';
import 'finance_setup.dart';
import 'transactions.dart';

/// Провайдеры сценариев и данных «Денег» для экранов. Экраны импортируют только этот
/// файл: репозитории и база остаются за ним (ARCHITECTURE §1.3).

final ensureDefaultCategoriesProvider = Provider(
  (ref) => EnsureDefaultCategories(ref.watch(categoryRepositoryProvider)),
);

final setUpFinanceProvider = Provider(
  (ref) => SetUpFinance(
    ref.watch(unitOfWorkProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(accountRepositoryProvider),
    ref.watch(ensureDefaultCategoriesProvider),
  ),
);

final saveAccountProvider = Provider(
  (ref) => SaveAccount(
    ref.watch(unitOfWorkProvider),
    ref.watch(accountRepositoryProvider),
  ),
);

final adjustBalanceProvider = Provider(
  (ref) => AdjustBalance(
    ref.watch(unitOfWorkProvider),
    ref.watch(accountRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final setAccountArchivedProvider = Provider(
  (ref) => SetAccountArchived(
    ref.watch(accountRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final recordIncomeExpenseProvider = Provider(
  (ref) => RecordIncomeExpense(
    ref.watch(unitOfWorkProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(accountRepositoryProvider),
    ref.watch(categoryRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(exchangeRateRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final recordTransferProvider = Provider(
  (ref) => RecordTransfer(
    ref.watch(unitOfWorkProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(accountRepositoryProvider),
    ref.watch(categoryRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(exchangeRateRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final deleteTransactionProvider = Provider(
  (ref) => DeleteTransaction(
    ref.watch(unitOfWorkProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final saveExchangeRateProvider = Provider(
  (ref) => SaveExchangeRate(
    ref.watch(unitOfWorkProvider),
    ref.watch(exchangeRateRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

/// Базовая валюта; null — онбординг не пройден.
final baseCurrencyProvider = StreamProvider<Currency?>(
  (ref) => ref.watch(settingsRepositoryProvider).watchBaseCurrency(),
);

final activeAccountsProvider = StreamProvider<List<AccountWithBalance>>(
  (ref) => ref.watch(accountRepositoryProvider).watchActive(),
);

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

final transactionsProvider =
    StreamProvider.family<List<FinTransaction>, TransactionFilter>(
      (ref, filter) => ref.watch(transactionRepositoryProvider).watch(filter),
    );
