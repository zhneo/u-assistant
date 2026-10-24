import '../common/entity_id.dart';
import '../common/local_date.dart';
import '../money/currency.dart';
import '../money/exchange_rate.dart';
import 'account.dart';
import 'category.dart';
import 'transaction.dart';

/// Интерфейсы репозиториев модуля «Деньги» (ARCHITECTURE §6, D-059).
/// Реализации — в `app/lib/data`; экраны видят только эти интерфейсы через сценарии.
/// Все запросы исключают мягко удалённые записи (I13), если не сказано иное.

abstract interface class AccountRepository {
  /// Счета не в архиве, по `sort_order`, с текущим балансом (§6.2).
  Stream<List<AccountWithBalance>> watchActive();
  Future<List<Account>> all();
  Future<Account?> get(EntityId id);

  /// Вставка или обновление.
  Future<void> save(Account account);
  Future<bool> hasTransactions(EntityId id);
}

abstract interface class CategoryRepository {
  Stream<List<Category>> watchAll();
  Future<List<Category>> all();
  Future<Category?> get(EntityId id);
  Future<Category?> byDefaultKey(String key);
  Future<void> save(Category category);
}

abstract interface class ExchangeRateRepository {
  /// Все курсы к [base] — для выбора «последнего» и «на дату» в ядре (`rateOn`).
  Stream<List<ExchangeRate>> watchAll(Currency base);
  Future<ExchangeRate?> at(Currency currency, Currency base, LocalDate date);

  /// Вставка или замена курса на ту же дату действия.
  Future<void> save(ExchangeRate rate);
}

/// Фильтр списка операций (FR-FIN-11). Пустой фильтр — все фактические операции.
final class TransactionFilter {
  final DatePeriod? period;
  final EntityId? accountId;
  final EntityId? categoryId;
  final Set<TransactionKind>? kinds;
  final int? limit;

  const TransactionFilter({
    this.period,
    this.accountId,
    this.categoryId,
    this.kinds,
    this.limit,
  });

  // Равенство по значению: фильтр служит ключом подписки на список.
  @override
  bool operator ==(Object other) =>
      other is TransactionFilter &&
      other.period == period &&
      other.accountId == accountId &&
      other.categoryId == categoryId &&
      _sameKinds(other.kinds, kinds) &&
      other.limit == limit;

  static bool _sameKinds(Set<TransactionKind>? a, Set<TransactionKind>? b) =>
      a == null
      ? b == null
      : b != null && a.length == b.length && a.containsAll(b);

  @override
  int get hashCode => Object.hash(
    period,
    accountId,
    categoryId,
    kinds == null ? null : Object.hashAllUnordered(kinds!),
    limit,
  );
}

abstract interface class TransactionRepository {
  Future<void> insert(FinTransaction transaction);
  Future<void> update(FinTransaction transaction);
  Future<FinTransaction?> get(EntityId id);

  /// Обе части перевода (FR-FIN-08).
  Future<List<FinTransaction>> transferPair(EntityId transferGroupId);
  Future<void> softDelete(Iterable<EntityId> ids, DateTime at);

  /// Операции в [currency] без суммы в базовой валюте — их дополняет новый курс
  /// (DATABASE §8 «Если курс добавили позже»).
  Future<List<FinTransaction>> missingBase(Currency currency);

  /// Фактические операции по фильтру, новые сверху (дата, время, создание).
  Stream<List<FinTransaction>> watch(TransactionFilter filter);
}
