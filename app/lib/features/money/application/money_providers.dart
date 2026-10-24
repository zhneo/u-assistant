import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../services/clock_provider.dart';
import 'accounts.dart';
import 'exchange_rates.dart';
import 'transactions.dart';

/// Провайдеры сценариев и данных «Денег» для экранов. Экраны импортируют только этот
/// файл: репозитории и база остаются за ним (ARCHITECTURE §1.3).

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

/// Все счета, включая архивные, — для названий в старых операциях.
final allAccountsProvider = StreamProvider<List<Account>>(
  (ref) => ref.watch(accountRepositoryProvider).watchAll(),
);

/// Курсы к базовой валюте (FR-FIN-15).
final exchangeRatesProvider =
    StreamProvider.family<List<ExchangeRate>, Currency>(
      (ref, base) => ref.watch(exchangeRateRepositoryProvider).watchAll(base),
    );

/// Курс на дату — для подписи «Нет курса USD» в форме операции.
final rateAtProvider =
    FutureProvider.family<ExchangeRate?, (Currency, Currency, LocalDate)>(
      (ref, key) =>
          ref.watch(exchangeRateRepositoryProvider).at(key.$1, key.$2, key.$3),
    );

/// Последний использованный счёт — по умолчанию в новой операции (FR-FIN-05).
final lastAccountIdProvider = FutureProvider<EntityId?>(
  (ref) => ref.watch(settingsRepositoryProvider).lastAccountId(),
);

/// Операция для экрана SCR-32 и формы правки; у перевода — обе части.
final operationProvider = FutureProvider.family<List<FinTransaction>, EntityId>(
  (ref, id) async {
    // Пересчитывается при любом изменении операций: экран показывает свежие данные.
    ref.watch(transactionsProvider(const TransactionFilter()));
    final repo = ref.watch(transactionRepositoryProvider);
    final t = await repo.get(id);
    if (t == null) return const [];
    if (t.transferGroupId == null) return [t];
    return repo.transferPair(t.transferGroupId!);
  },
);

/// Есть ли у счёта операции — валюта и режим бюджета тогда заблокированы.
final accountHasTransactionsProvider = FutureProvider.family<bool, EntityId>(
  (ref, id) => ref.watch(accountRepositoryProvider).hasTransactions(id),
);
