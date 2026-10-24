import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:u_assistant/data/database/app_database.dart'
    hide Account, Category, ExchangeRate, FinTransaction;
import 'package:u_assistant/data/finance/finance_repositories.dart';
import 'package:u_assistant/data/providers.dart';
import 'package:u_assistant/data/settings/drift_settings_repository.dart';
import 'package:u_assistant/features/money/application/accounts.dart';
import 'package:u_assistant/features/money/application/exchange_rates.dart';
import 'package:u_assistant/features/money/application/finance_setup.dart';
import 'package:u_assistant/features/money/application/transactions.dart';

/// Слой данных и сценарии «Денег» на настоящей SQLite в памяти (TESTING_STRATEGY §3).
class _Env {
  final db = AppDatabase(NativeDatabase.memory());
  final clock = FixedClock();
  late final settings = DriftSettingsRepository(db, clock);
  late final accounts = DriftAccountRepository(db, clock);
  late final categories = DriftCategoryRepository(db, clock);
  late final rates = DriftExchangeRateRepository(db, clock);
  late final transactions = DriftTransactionRepository(
    db,
    () => settings.cachedBase,
  );
  late final uow = DriftUnitOfWork(db);
  late final ensureCategories = EnsureDefaultCategories(categories);
  late final setUp = SetUpFinance(uow, settings, accounts, ensureCategories);
  late final saveAccount = SaveAccount(uow, accounts);
  late final adjust = AdjustBalance(uow, accounts, transactions, clock);
  late final record = RecordIncomeExpense(
    uow,
    transactions,
    accounts,
    categories,
    settings,
    rates,
    clock,
  );
  late final transfer = RecordTransfer(
    uow,
    transactions,
    accounts,
    categories,
    settings,
    rates,
    clock,
  );
  late final delete = DeleteTransaction(uow, transactions, clock);
  late final saveRate = SaveExchangeRate(
    uow,
    rates,
    transactions,
    settings,
    clock,
  );

  LocalDate get today => LocalDate.fromDateTime(clock.now());

  /// Онбординг с базовой KZT и счётом «Карта».
  Future<Account> start({int opening = 0}) async => (await setUp(
    baseCurrency: Currency.kzt,
    accountName: 'Карта',
    openingBalance: Money(opening, Currency.kzt),
  )).value;

  Future<Account> addAccount(
    String name,
    Currency c, {
    int opening = 0,
    BudgetMode mode = BudgetMode.onBudget,
  }) async => (await saveAccount(
    AccountInput(
      name: name,
      type: AccountType.cash,
      currency: c,
      openingBalance: Money(opening, c),
      budgetMode: mode,
    ),
  )).value;

  Future<Money> balance(Account a) async => (await accounts.watchActive().first)
      .firstWhere((x) => x.account.id == a.id)
      .balance;

  Future<List<FinTransaction>> all() =>
      transactions.watch(const TransactionFilter()).first;

  Future<PeriodSummary> month() async =>
      periodSummary(await all(), DatePeriod.monthOf(today), Currency.kzt);
}

void main() {
  late _Env env;
  setUp(() => env = _Env());
  tearDown(() => env.db.close());

  int defaultCategoryCount() =>
      defaultCategoriesRu.fold(0, (n, c) => n + 1 + c.children.length);

  group('Онбординг и категории', () {
    test('базовая валюта, стандартные категории и первый счёт', () async {
      final card = await env.start(opening: 1500000);
      expect(await env.settings.baseCurrency(), Currency.kzt);
      expect(env.settings.cachedBase, Currency.kzt);
      expect(await env.settings.lastAccountId(), card.id);
      expect((await env.categories.all()).length, defaultCategoryCount());
      expect(await env.balance(card), Money(1500000, Currency.kzt));
    });

    test('повторный набор категорий ничего не дублирует', () async {
      await env.start();
      expect(await env.ensureCategories(), 0);
      expect((await env.categories.all()).length, defaultCategoryCount());
    });

    test('подкатегории ссылаются на родителя того же типа', () async {
      await env.start();
      final transport = await env.categories.byDefaultKey('transport');
      final taxi = await env.categories.byDefaultKey('taxi');
      expect(taxi!.parentId, transport!.id);
      expect(taxi.kind, CategoryKind.expense);
    });

    test(
      'настройки переживают перезапуск: load() читает базовую валюту',
      () async {
        await env.start();
        final again = DriftSettingsRepository(env.db, env.clock);
        await again.load();
        expect(again.cachedBase, Currency.kzt);
      },
    );
  });

  group('Расходы и доходы', () {
    test('без категории — «Без категории»; баланс уменьшается', () async {
      final card = await env.start(opening: 1000000);
      final r = await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.expense,
          amount: Money(350000, Currency.kzt),
          accountId: card.id,
          date: env.today,
        ),
      );
      final uncategorized = await env.categories.byDefaultKey(
        uncategorizedExpenseKey,
      );
      expect(r.value.categoryId, uncategorized!.id);
      expect(r.value.amountBase, Money(350000, Currency.kzt));
      expect(await env.balance(card), Money(650000, Currency.kzt));
      expect((await env.month()).expense, Money(350000, Currency.kzt));
    });

    test('сумма обязательна и больше нуля', () async {
      final card = await env.start();
      for (final amount in [null, Money(0, Currency.kzt)]) {
        final r = await env.record(
          IncomeExpenseInput(
            kind: TransactionKind.expense,
            amount: amount,
            accountId: card.id,
            date: env.today,
          ),
        );
        expect(r.isOk, isFalse);
      }
      expect(await env.all(), isEmpty);
    });

    test('категория дохода для расхода отклоняется', () async {
      final card = await env.start();
      final salary = await env.categories.byDefaultKey('salary');
      final r = await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.expense,
          amount: Money(100, Currency.kzt),
          accountId: card.id,
          categoryId: salary!.id,
          date: env.today,
        ),
      );
      expect(
        r,
        const Err<FinTransaction>(
          ValidationFailure('category', ValidationReason.invalidFormat),
        ),
      );
    });

    test('изменение операции сохраняет id и дату создания', () async {
      final card = await env.start();
      final created = (await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.income,
          amount: Money(500000, Currency.kzt),
          accountId: card.id,
          date: env.today,
        ),
      )).value;
      env.clock.advance(const Duration(hours: 1));
      final edited = (await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.income,
          amount: Money(600000, Currency.kzt),
          accountId: card.id,
          date: env.today,
          note: 'премия',
        ),
        existingId: created.id,
      )).value;
      expect(edited.id, created.id);
      expect(edited.createdAt, created.createdAt);
      expect((await env.all()).single.amount, Money(600000, Currency.kzt));
      expect(await env.balance(card), Money(600000, Currency.kzt));
    });
  });

  group('Переводы', () {
    test('AC-01: перевод не меняет доходы, расходы и общий баланс', () async {
      final card = await env.start(opening: 5000000);
      final cash = await env.addAccount('Наличные', Currency.kzt);
      final before = await env.month();
      final r = await env.transfer(
        TransferInput(
          fromAccountId: card.id,
          toAccountId: cash.id,
          debit: Money(1000000, Currency.kzt),
          date: env.today,
        ),
      );
      expect(r.value, hasLength(2));
      expect(r.value.map((t) => t.reportEffect).toSet(), {ReportEffect.none});
      expect(await env.balance(card), Money(4000000, Currency.kzt));
      expect(await env.balance(cash), Money(1000000, Currency.kzt));
      expect(await env.month(), before);
    });

    test('AC-02: межвалютный перевод хранит обе суммы', () async {
      final kzt = await env.start();
      final usd = await env.addAccount('Доллары', Currency.usd, opening: 20000);
      final r = await env.transfer(
        TransferInput(
          fromAccountId: usd.id,
          toAccountId: kzt.id,
          debit: Money(10000, Currency.usd),
          credit: Money(4705000, Currency.kzt),
          date: env.today,
        ),
      );
      final out = r.value.firstWhere(
        (t) => t.kind == TransactionKind.transferOut,
      );
      final into = r.value.firstWhere(
        (t) => t.kind == TransactionKind.transferIn,
      );
      expect(out.amount, Money(10000, Currency.usd));
      expect(into.amount, Money(4705000, Currency.kzt));
      expect(await env.balance(usd), Money(10000, Currency.usd));
      expect(await env.balance(kzt), Money(4705000, Currency.kzt));
      final s = await env.month();
      expect(s.income.isZero && s.expense.isZero, isTrue);
    });

    test(
      'AC-03: на счёт «только отслеживать» — нужна категория, это расход',
      () async {
        final card = await env.start(opening: 10000000);
        final credit = await env.addAccount(
          'Кредит',
          Currency.kzt,
          opening: -50000000,
          mode: BudgetMode.tracking,
        );
        final input = TransferInput(
          fromAccountId: card.id,
          toAccountId: credit.id,
          debit: Money(5000000, Currency.kzt),
          date: env.today,
        );
        expect(
          await env.transfer(input),
          const Err<List<FinTransaction>>(
            ValidationFailure('category', ValidationReason.required),
          ),
        );
        final loans = await env.categories.byDefaultKey('loans');
        final r = await env.transfer(
          TransferInput(
            fromAccountId: card.id,
            toAccountId: credit.id,
            debit: Money(5000000, Currency.kzt),
            categoryId: loans!.id,
            date: env.today,
          ),
        );
        expect(r.isOk, isTrue);
        expect((await env.month()).expense, Money(5000000, Currency.kzt));
        expect(await env.balance(credit), Money(-45000000, Currency.kzt));
      },
    );

    test('удаление части перевода удаляет обе (FR-FIN-08)', () async {
      final card = await env.start(opening: 100000);
      final cash = await env.addAccount('Наличные', Currency.kzt);
      final pair = (await env.transfer(
        TransferInput(
          fromAccountId: card.id,
          toAccountId: cash.id,
          debit: Money(30000, Currency.kzt),
          date: env.today,
        ),
      )).value;
      await env.delete(pair.last.id);
      expect(await env.all(), isEmpty);
      expect(await env.balance(card), Money(100000, Currency.kzt));
      expect(await env.balance(cash), Money(0, Currency.kzt));
    });

    test('изменение перевода меняет обе части', () async {
      final card = await env.start(opening: 100000);
      final cash = await env.addAccount('Наличные', Currency.kzt);
      final pair = (await env.transfer(
        TransferInput(
          fromAccountId: card.id,
          toAccountId: cash.id,
          debit: Money(30000, Currency.kzt),
          date: env.today,
        ),
      )).value;
      await env.transfer(
        TransferInput(
          fromAccountId: card.id,
          toAccountId: cash.id,
          debit: Money(45000, Currency.kzt),
          date: env.today,
        ),
        existingGroupId: pair.first.transferGroupId,
      );
      final all = await env.all();
      expect(all, hasLength(2));
      expect(all.map((t) => t.amount).toSet(), {Money(45000, Currency.kzt)});
      expect(await env.balance(cash), Money(45000, Currency.kzt));
    });
  });

  group('Курсы', () {
    test('AC-16/AC-17: операция без курса дополняется, новый курс историю не меняет', () async {
      await env.start();
      final usd = await env.addAccount('Доллары', Currency.usd);
      final expense = (await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.expense,
          amount: Money(1000, Currency.usd),
          accountId: usd.id,
          date: env.today,
        ),
      )).value;
      expect(expense.amountBase, isNull);
      expect((await env.month()).isComplete, isFalse);

      final filled = await env.saveRate(
        currency: Currency.usd,
        rateText: '470',
        validFrom: env.today,
      );
      expect(filled.value, 1);
      final priced = (await env.all()).single;
      expect(priced.amountBase, Money(470000, Currency.kzt));
      expect(priced.rateToBase, Decimal.parse('470'));
      expect((await env.month()).isComplete, isTrue);

      final later = env.today.addDays(1);
      expect(
        (await env.saveRate(
          currency: Currency.usd,
          rateText: '480',
          validFrom: later,
        )).value,
        0,
      );
      expect((await env.all()).single.amountBase, Money(470000, Currency.kzt));

      final allRates = await env.rates.watchAll(Currency.kzt).first;
      expect(
        rateOn(allRates, Currency.usd, Currency.kzt, later)!.rate,
        Decimal.parse('480'),
      );
    });

    test('курс на ту же дату заменяется, а не дублируется', () async {
      await env.start();
      await env.saveRate(
        currency: Currency.usd,
        rateText: '470',
        validFrom: env.today,
      );
      await env.saveRate(
        currency: Currency.usd,
        rateText: '471,5',
        validFrom: env.today,
      );
      final rates = await env.rates.watchAll(Currency.kzt).first;
      expect(rates.single.rate, Decimal.parse('471.5'));
    });

    test('неверный курс и курс базовой валюты отклоняются', () async {
      await env.start();
      expect(
        (await env.saveRate(
          currency: Currency.usd,
          rateText: '0',
          validFrom: env.today,
        )).isOk,
        isFalse,
      );
      expect(
        (await env.saveRate(
          currency: Currency.kzt,
          rateText: '1',
          validFrom: env.today,
        )).isOk,
        isFalse,
      );
    });
  });

  group('Счета', () {
    test('корректировка баланса — не доход и не расход (FR-FIN-02)', () async {
      final card = await env.start(opening: 100000);
      final t = await env.adjust(
        card.id,
        Money(95000, Currency.kzt),
        env.today,
      );
      expect(t.value!.amount, Money(-5000, Currency.kzt));
      expect(await env.balance(card), Money(95000, Currency.kzt));
      final s = await env.month();
      expect(s.income.isZero && s.expense.isZero, isTrue);
      expect(
        (await env.adjust(
          card.id,
          Money(95000, Currency.kzt),
          env.today,
        )).value,
        isNull,
      );
    });

    test('валюту счёта с операциями сменить нельзя (FR-FIN-03)', () async {
      final card = await env.start();
      await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.income,
          amount: Money(100, Currency.kzt),
          accountId: card.id,
          date: env.today,
        ),
      );
      final r = await env.saveAccount(
        const AccountInput(
          name: 'Карта',
          type: AccountType.card,
          currency: Currency.usd,
        ),
        existingId: card.id,
      );
      expect(
        r,
        const Err<Account>(ConflictFailure(ConflictReason.currencyLocked)),
      );
    });
  });

  group('Ограничения базы (DATABASE §4–5)', () {
    late Account card;
    setUp(() async => card = await env.start());

    Future<void> raw(String sql, [List<Object?> args = const []]) =>
        env.db.customStatement(sql, args);

    test('расход без категории запрещён CHECK', () async {
      await expectLater(
        raw(
          "INSERT INTO fin_transaction (id, kind, account_id, amount_minor, currency, report_effect, date, created_at, updated_at) "
          "VALUES (?, 'expense', ?, 100, 'KZT', 'expense', '2026-10-23', 1, 1)",
          [EntityId.generate().value, card.id.value],
        ),
        _fails('CHECK constraint failed'),
      );
    });

    test('валюта операции должна совпадать с валютой счёта (I3)', () async {
      final food = await env.categories.byDefaultKey('food');
      await expectLater(
        raw(
          "INSERT INTO fin_transaction (id, kind, account_id, category_id, amount_minor, currency, report_effect, date, created_at, updated_at) "
          "VALUES (?, 'expense', ?, ?, 100, 'USD', 'expense', '2026-10-23', 1, 1)",
          [EntityId.generate().value, card.id.value, food!.id.value],
        ),
        _fails('transaction_currency_mismatch'),
      );
    });

    test('категория не глубже двух уровней (I10)', () async {
      final taxi = await env.categories.byDefaultKey('taxi');
      await expectLater(
        env.categories.save(
          Category(
            id: EntityId.generate(),
            kind: CategoryKind.expense,
            parentId: taxi!.id,
            name: 'Ночное такси',
          ),
        ),
        _fails('category_parent_invalid'),
      );
    });

    test('в паре перевода ровно один out (I1)', () async {
      final cash = await env.addAccount('Наличные', Currency.kzt);
      final pair = (await env.transfer(
        TransferInput(
          fromAccountId: card.id,
          toAccountId: cash.id,
          debit: Money(100, Currency.kzt),
          date: env.today,
        ),
      )).value;
      await expectLater(
        raw(
          "INSERT INTO fin_transaction (id, kind, account_id, amount_minor, currency, report_effect, date, transfer_group_id, created_at, updated_at) "
          "VALUES (?, 'transfer_out', ?, 100, 'KZT', 'none', '2026-10-23', ?, 1, 1)",
          [
            EntityId.generate().value,
            card.id.value,
            pair.first.transferGroupId!.value,
          ],
        ),
        _fails('UNIQUE constraint failed'),
      );
    });

    test('триггер запрещает смену валюты счёта с операциями (I4)', () async {
      await env.record(
        IncomeExpenseInput(
          kind: TransactionKind.income,
          amount: Money(100, Currency.kzt),
          accountId: card.id,
          date: env.today,
        ),
      );
      await expectLater(
        raw("UPDATE account SET currency = 'USD' WHERE id = ?", [
          card.id.value,
        ]),
        _fails('account_currency_locked'),
      );
    });
  });

  test('SQL-баланс совпадает с эталоном core (D-060)', () async {
    final card = await env.start(opening: 123456);
    final cash = await env.addAccount('Наличные', Currency.kzt, opening: 500);
    final food = await env.categories.byDefaultKey('food');
    for (var i = 1; i <= 40; i++) {
      final date = env.today.addDays(-i);
      if (i % 3 == 0) {
        await env.transfer(
          TransferInput(
            fromAccountId: i.isEven ? card.id : cash.id,
            toAccountId: i.isEven ? cash.id : card.id,
            debit: Money(i * 100, Currency.kzt),
            date: date,
          ),
        );
      } else {
        await env.record(
          IncomeExpenseInput(
            kind: i % 2 == 0 ? TransactionKind.expense : TransactionKind.income,
            amount: Money(i * 1000 + 7, Currency.kzt),
            accountId: i % 4 == 0 ? cash.id : card.id,
            categoryId: i % 2 == 0 ? food!.id : null,
            date: date,
          ),
        );
      }
    }
    await env.adjust(cash.id, Money(1, Currency.kzt), env.today);
    final some = (await env.all()).firstWhere(
      (t) => t.kind == TransactionKind.expense,
    );
    await env.delete(some.id); // удалённые не считаются (I13)

    // Эталон получает и удалённую операцию: он сам обязан её пропустить.
    final reference = [
      ...await env.all(),
      some.copyWith(deletedAt: env.clock.now().toUtc()),
    ];
    for (final a in [card, cash]) {
      expect(await env.balance(a), accountBalance(a, reference));
    }
  });
}

/// Ошибка SQLite с конкретной причиной — а не любая ошибка (например, опечатка в SQL).
Matcher _fails(String reason) => throwsA(
  predicate((e) => e.toString().contains(reason), 'ошибка «$reason»'),
);
