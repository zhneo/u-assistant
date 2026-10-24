import 'package:core/core.dart';
import 'package:drift/drift.dart';

// Классы таблиц drift называются так же, как модели ядра; здесь нужны только строки.
import '../database/app_database.dart'
    hide Account, Category, ExchangeRate, FinTransaction;
import '../database/app_database.dart' as tables show Category;

/// Реализации репозиториев «Денег» поверх drift (ARCHITECTURE §5–6, D-059).
/// Строки базы переводятся в модели `core`; экраны таблиц не видят.

int _ms(DateTime d) => d.toUtc().millisecondsSinceEpoch;
DateTime _utc(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

Account _account(AccountRow r) {
  final currency = Currency.of(r.currency);
  return Account(
    id: EntityId(r.id),
    name: r.name,
    type: AccountType.fromDb(r.type),
    currency: currency,
    openingBalance: Money(r.openingBalanceMinor, currency),
    budgetMode: BudgetMode.fromDb(r.budgetMode),
    hidden: r.hidden == 1,
    archivedAt: r.archivedAt == null ? null : _utc(r.archivedAt!),
    colorIndex: r.colorIndex,
    icon: r.icon,
    sortOrder: r.sortOrder,
  );
}

final class DriftAccountRepository implements AccountRepository {
  final AppDatabase _db;
  final Clock _clock;
  DriftAccountRepository(this._db, this._clock);

  @override
  Stream<List<AccountWithBalance>> watchActive() =>
      _db.activeAccountsWithBalance().watch().map(
        (rows) => [
          for (final r in rows)
            AccountWithBalance(
              _account(r.a),
              Money(r.balanceMinor, Currency.of(r.a.currency)),
            ),
        ],
      );

  @override
  Future<List<Account>> all() async {
    final q = _db.select(_db.account)
      ..where((a) => a.deletedAt.isNull())
      ..orderBy([(a) => OrderingTerm(expression: a.sortOrder)]);
    return (await q.get()).map(_account).toList();
  }

  @override
  Future<Account?> get(EntityId id) async {
    final q = _db.select(_db.account)
      ..where((a) => a.id.equals(id.value) & a.deletedAt.isNull());
    final row = await q.getSingleOrNull();
    return row == null ? null : _account(row);
  }

  @override
  Future<void> save(Account a) async {
    final now = _ms(_clock.now());
    await _db
        .into(_db.account)
        .insert(
          AccountCompanion.insert(
            id: a.id.value,
            name: a.name,
            type: a.type.dbValue,
            currency: a.currency.code,
            openingBalanceMinor: Value(a.openingBalance.amountMinor),
            budgetMode: Value(a.budgetMode.dbValue),
            hidden: Value(a.hidden ? 1 : 0),
            archivedAt: Value(a.archivedAt == null ? null : _ms(a.archivedAt!)),
            colorIndex: a.colorIndex,
            icon: a.icon,
            sortOrder: a.sortOrder,
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => AccountCompanion(
              name: Value(a.name),
              type: Value(a.type.dbValue),
              currency: Value(a.currency.code),
              openingBalanceMinor: Value(a.openingBalance.amountMinor),
              budgetMode: Value(a.budgetMode.dbValue),
              hidden: Value(a.hidden ? 1 : 0),
              archivedAt: Value(
                a.archivedAt == null ? null : _ms(a.archivedAt!),
              ),
              colorIndex: Value(a.colorIndex),
              icon: Value(a.icon),
              sortOrder: Value(a.sortOrder),
              updatedAt: Value(now),
            ),
          ),
        );
  }

  @override
  Future<bool> hasTransactions(EntityId id) async {
    final q = _db.selectOnly(_db.finTransaction)
      ..addColumns([_db.finTransaction.id])
      ..where(_db.finTransaction.accountId.equals(id.value))
      ..limit(1);
    return (await q.get()).isNotEmpty;
  }
}

Category _category(CategoryRow r) => Category(
  id: EntityId(r.id),
  kind: CategoryKind.fromDb(r.kind),
  parentId: r.parentId == null ? null : EntityId(r.parentId!),
  name: r.name,
  icon: r.icon,
  colorIndex: r.colorIndex,
  sortOrder: r.sortOrder,
  defaultKey: r.defaultKey,
  hidden: r.hidden == 1,
);

final class DriftCategoryRepository implements CategoryRepository {
  final AppDatabase _db;
  final Clock _clock;
  DriftCategoryRepository(this._db, this._clock);

  SimpleSelectStatement<tables.Category, CategoryRow> _active() =>
      _db.select(_db.category)
        ..where((c) => c.deletedAt.isNull())
        ..orderBy([
          (c) => OrderingTerm(expression: c.sortOrder),
          (c) => OrderingTerm(expression: c.createdAt),
        ]);

  @override
  Stream<List<Category>> watchAll() =>
      _active().watch().map((rows) => rows.map(_category).toList());

  @override
  Future<List<Category>> all() async =>
      (await _active().get()).map(_category).toList();

  @override
  Future<Category?> get(EntityId id) async {
    final q = _db.select(_db.category)
      ..where((c) => c.id.equals(id.value) & c.deletedAt.isNull());
    final row = await q.getSingleOrNull();
    return row == null ? null : _category(row);
  }

  @override
  Future<Category?> byDefaultKey(String key) async {
    final q = _db.select(_db.category)
      ..where((c) => c.defaultKey.equals(key) & c.deletedAt.isNull());
    final row = await q.getSingleOrNull();
    return row == null ? null : _category(row);
  }

  @override
  Future<void> save(Category c) async {
    final now = _ms(_clock.now());
    await _db
        .into(_db.category)
        .insert(
          CategoryCompanion.insert(
            id: c.id.value,
            kind: c.kind.dbValue,
            parentId: Value(c.parentId?.value),
            name: c.name,
            icon: c.icon,
            colorIndex: c.colorIndex,
            sortOrder: c.sortOrder,
            defaultKey: Value(c.defaultKey),
            hidden: Value(c.hidden ? 1 : 0),
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => CategoryCompanion(
              name: Value(c.name),
              icon: Value(c.icon),
              colorIndex: Value(c.colorIndex),
              sortOrder: Value(c.sortOrder),
              hidden: Value(c.hidden ? 1 : 0),
              updatedAt: Value(now),
            ),
          ),
        );
  }
}

ExchangeRate _rate(ExchangeRateRow r) => ExchangeRate(
  id: EntityId(r.id),
  currency: Currency.of(r.currency),
  baseCurrency: Currency.of(r.baseCurrency),
  rate: Decimal.parse(r.rate),
  validFrom: LocalDate.parse(r.validFrom),
);

final class DriftExchangeRateRepository implements ExchangeRateRepository {
  final AppDatabase _db;
  final Clock _clock;
  DriftExchangeRateRepository(this._db, this._clock);

  @override
  Stream<List<ExchangeRate>> watchAll(Currency base) {
    final q = _db.select(_db.exchangeRate)
      ..where((r) => r.baseCurrency.equals(base.code) & r.deletedAt.isNull())
      ..orderBy([
        (r) => OrderingTerm(expression: r.currency),
        (r) => OrderingTerm(expression: r.validFrom, mode: OrderingMode.desc),
      ]);
    return q.watch().map((rows) => rows.map(_rate).toList());
  }

  @override
  Future<ExchangeRate?> at(
    Currency currency,
    Currency base,
    LocalDate date,
  ) async {
    final q = _db.select(_db.exchangeRate)
      ..where(
        (r) =>
            r.currency.equals(currency.code) &
            r.baseCurrency.equals(base.code) &
            r.deletedAt.isNull() &
            r.validFrom.isSmallerOrEqualValue(date.toIso()),
      )
      ..orderBy([
        (r) => OrderingTerm(expression: r.validFrom, mode: OrderingMode.desc),
      ])
      ..limit(1);
    final row = await q.getSingleOrNull();
    return row == null ? null : _rate(row);
  }

  @override
  Future<void> save(ExchangeRate rate) async {
    final now = _ms(_clock.now());
    // Курс на ту же дату заменяется (уникальный индекс currency+base+valid_from).
    await (_db.update(_db.exchangeRate)..where(
          (r) =>
              r.currency.equals(rate.currency.code) &
              r.baseCurrency.equals(rate.baseCurrency.code) &
              r.validFrom.equals(rate.validFrom.toIso()) &
              r.deletedAt.isNull() &
              r.id.equals(rate.id.value).not(),
        ))
        .write(ExchangeRateCompanion(deletedAt: Value(now)));
    await _db
        .into(_db.exchangeRate)
        .insert(
          ExchangeRateCompanion.insert(
            id: rate.id.value,
            currency: rate.currency.code,
            baseCurrency: rate.baseCurrency.code,
            rate: rate.rate.toString(),
            validFrom: rate.validFrom.toIso(),
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => ExchangeRateCompanion(
              rate: Value(rate.rate.toString()),
              validFrom: Value(rate.validFrom.toIso()),
              updatedAt: Value(now),
            ),
          ),
        );
  }
}

FinTransaction _transaction(FinTransactionRow r, Currency Function() base) {
  final currency = Currency.of(r.currency);
  final rate = r.rateToBase == null ? null : Decimal.parse(r.rateToBase!);
  return FinTransaction(
    id: EntityId(r.id),
    kind: TransactionKind.fromDb(r.kind),
    status: TransactionStatus.fromDb(r.status),
    accountId: EntityId(r.accountId),
    categoryId: r.categoryId == null ? null : EntityId(r.categoryId!),
    amount: Money(r.amountMinor, currency),
    rateToBase: rate,
    amountBase: r.amountBaseMinor == null
        ? null
        // Курс есть → сумма в базовой валюте; курса нет → валюта счёта и есть базовая.
        : Money(r.amountBaseMinor!, rate == null ? currency : base()),
    reportEffect: ReportEffect.fromDb(r.reportEffect),
    isRefund: r.isRefund == 1,
    date: LocalDate.parse(r.date),
    time: r.time,
    note: r.note,
    transferGroupId: r.transferGroupId == null
        ? null
        : EntityId(r.transferGroupId!),
    createdAt: _utc(r.createdAt),
    updatedAt: _utc(r.updatedAt),
    deletedAt: r.deletedAt == null ? null : _utc(r.deletedAt!),
  );
}

FinTransactionCompanion _companion(FinTransaction t) =>
    FinTransactionCompanion.insert(
      id: t.id.value,
      kind: t.kind.dbValue,
      status: Value(t.status.dbValue),
      accountId: t.accountId.value,
      categoryId: Value(t.categoryId?.value),
      amountMinor: t.amount.amountMinor,
      currency: t.amount.currency.code,
      rateToBase: Value(t.rateToBase?.toString()),
      amountBaseMinor: Value(t.amountBase?.amountMinor),
      reportEffect: t.reportEffect.dbValue,
      isRefund: Value(t.isRefund ? 1 : 0),
      date: t.date.toIso(),
      time: Value(t.time),
      note: Value(t.note),
      transferGroupId: Value(t.transferGroupId?.value),
      createdAt: _ms(t.createdAt),
      updatedAt: _ms(t.updatedAt),
      deletedAt: Value(t.deletedAt == null ? null : _ms(t.deletedAt!)),
    );

final class DriftTransactionRepository implements TransactionRepository {
  final AppDatabase _db;

  /// Базовая валюта для сумм с курсом. Колонки базовой валюты в `fin_transaction` нет
  /// (DATABASE §4.5): она одна на всё приложение и берётся из настроек.
  final Currency Function() _base;

  DriftTransactionRepository(this._db, this._base);

  @override
  Future<void> insert(FinTransaction t) =>
      _db.into(_db.finTransaction).insert(_companion(t));

  @override
  Future<void> update(FinTransaction t) async {
    final c = _companion(t);
    await (_db.update(
      _db.finTransaction,
    )..where((r) => r.id.equals(t.id.value))).write(
      c.copyWith(id: const Value.absent(), createdAt: const Value.absent()),
    );
  }

  @override
  Future<FinTransaction?> get(EntityId id) async {
    final q = _db.select(_db.finTransaction)
      ..where((r) => r.id.equals(id.value) & r.deletedAt.isNull());
    final row = await q.getSingleOrNull();
    return row == null ? null : _transaction(row, _base);
  }

  @override
  Future<List<FinTransaction>> transferPair(EntityId groupId) async {
    final q = _db.select(_db.finTransaction)
      ..where(
        (r) => r.transferGroupId.equals(groupId.value) & r.deletedAt.isNull(),
      );
    return (await q.get()).map((r) => _transaction(r, _base)).toList();
  }

  @override
  Future<void> softDelete(Iterable<EntityId> ids, DateTime at) async {
    final ms = _ms(at);
    await (_db.update(
      _db.finTransaction,
    )..where((r) => r.id.isIn(ids.map((e) => e.value)))).write(
      FinTransactionCompanion(deletedAt: Value(ms), updatedAt: Value(ms)),
    );
  }

  @override
  Future<List<FinTransaction>> missingBase(Currency currency) async {
    final q = _db.select(_db.finTransaction)
      ..where(
        (r) =>
            r.currency.equals(currency.code) &
            r.amountBaseMinor.isNull() &
            r.deletedAt.isNull(),
      );
    return (await q.get()).map((r) => _transaction(r, _base)).toList();
  }

  @override
  Stream<List<FinTransaction>> watch(TransactionFilter f) {
    final q = _db.select(_db.finTransaction)
      ..where((r) {
        Expression<bool> e =
            r.deletedAt.isNull() &
            r.status.equals(TransactionStatus.posted.dbValue);
        final period = f.period;
        if (period != null) {
          e =
              e &
              r.date.isBetweenValues(period.start.toIso(), period.end.toIso());
        }
        if (f.accountId != null) e = e & r.accountId.equals(f.accountId!.value);
        if (f.categoryId != null) {
          e = e & r.categoryId.equals(f.categoryId!.value);
        }
        if (f.kinds != null) {
          e = e & r.kind.isIn(f.kinds!.map((k) => k.dbValue));
        }
        return e;
      })
      ..orderBy([
        (r) => OrderingTerm(expression: r.date, mode: OrderingMode.desc),
        (r) => OrderingTerm(
          expression: r.time,
          mode: OrderingMode.desc,
          nulls: NullsOrder.last,
        ),
        (r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc),
      ]);
    if (f.limit != null) q.limit(f.limit!);
    return q.watch().map(
      (rows) => rows.map((r) => _transaction(r, _base)).toList(),
    );
  }
}
