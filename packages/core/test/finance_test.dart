import 'package:core/core.dart';
import 'package:test/test.dart';

/// Тесты финансовых правил REQUIREMENTS §6 и критериев AC-01, 02, 03, 16, 17 на уровне ядра.
void main() {
  final today = LocalDate(2026, 10, 23);
  final october = DatePeriod.monthOf(today);
  final at = DateTime.utc(2026, 10, 23, 9);
  var seq = 0;
  EntityId id() => EntityId.generate();

  Account account(
    Currency c, {
    int opening = 0,
    BudgetMode mode = BudgetMode.onBudget,
    bool hidden = false,
  }) => Account(
    id: id(),
    name: 'Счёт ${seq++}',
    type: AccountType.card,
    currency: c,
    openingBalance: Money(opening, c),
    budgetMode: mode,
    hidden: hidden,
  );

  final food = id();
  final loans = id();

  FinTransaction tx(
    TransactionKind kind,
    Account a,
    int minor, {
    EntityId? category,
    ReportEffect? effect,
    Money? base,
    bool baseIsNull = false,
    LocalDate? date,
    EntityId? group,
    TransactionStatus status = TransactionStatus.posted,
    DateTime? deletedAt,
    bool refund = false,
  }) {
    final amount = Money(minor, a.currency);
    return FinTransaction(
      id: id(),
      kind: kind,
      status: status,
      accountId: a.id,
      categoryId:
          category ??
          (kind == TransactionKind.expense || kind == TransactionKind.income
              ? food
              : null),
      amount: amount,
      amountBase: baseIsNull ? null : base ?? amount,
      reportEffect: effect ?? reportEffectOf(kind),
      isRefund: refund,
      date: date ?? today,
      transferGroupId: group,
      createdAt: at,
      updatedAt: at,
      deletedAt: deletedAt,
    );
  }

  /// Перевод — две записи с общим transferGroupId и report_effect по §5.2.
  List<FinTransaction> transfer(
    Account from,
    Account to,
    int debit,
    int credit, {
    EntityId? category,
  }) {
    final g = id();
    final e = transferEffects(from.budgetMode, to.budgetMode);
    return [
      tx(
        TransactionKind.transferOut,
        from,
        debit,
        effect: e.out,
        group: g,
        category: category,
      ),
      tx(
        TransactionKind.transferIn,
        to,
        credit,
        effect: e.into,
        group: g,
        category: category,
      ),
    ];
  }

  group('LocalDate и период', () {
    test('ISO туда и обратно, несуществующая дата отклоняется', () {
      expect(LocalDate.parse('2026-10-23'), today);
      expect(today.toIso(), '2026-10-23');
      expect(LocalDate.tryParse('2026-02-30'), isNull);
      expect(LocalDate.tryParse('23.10.2026'), isNull);
    });

    test('сдвиг дней и границы месяца', () {
      expect(LocalDate(2026, 12, 31).addDays(1), LocalDate(2027, 1, 1));
      expect(LocalDate(2028, 2, 10).lastDayOfMonth, LocalDate(2028, 2, 29));
      expect(october.start, LocalDate(2026, 10, 1));
      expect(october.end, LocalDate(2026, 10, 31));
      expect(
        october.previousMonth(),
        DatePeriod.monthOf(LocalDate(2026, 9, 1)),
      );
      expect(october.contains(LocalDate(2026, 11, 1)), isFalse);
    });
  });

  group('Курсы', () {
    test('ввод курса: запятая, точка, пробелы; ноль и мусор отклоняются', () {
      expect(parseRate('470,50').value, Decimal.parse('470.5'));
      expect(parseRate(' 1 250.5 ').value, Decimal.parse('1250.5'));
      expect(parseRate('0').isOk, isFalse);
      expect(parseRate('-5').isOk, isFalse);
      expect(parseRate('abc').isOk, isFalse);
    });

    test('формат курса для интерфейса', () {
      expect(formatRate(Decimal.parse('470.5')), '470,50');
      expect(formatRate(Decimal.parse('1250')), '1 250,00');
      expect(formatRate(Decimal.parse('0.0021')), '0,0021');
    });

    test(
      'курс на дату — последний с validFrom ≤ даты; раньше первого — нет',
      () {
        ExchangeRate r(String v, LocalDate from) => ExchangeRate(
          id: id(),
          currency: Currency.usd,
          baseCurrency: Currency.kzt,
          rate: Decimal.parse(v),
          validFrom: from,
        );
        final rates = [
          r('470', LocalDate(2026, 9, 1)),
          r('480', LocalDate(2026, 10, 20)),
        ];
        expect(
          rateOn(rates, Currency.usd, Currency.kzt, today)!.rate,
          Decimal.parse('480'),
        );
        expect(
          rateOn(
            rates,
            Currency.usd,
            Currency.kzt,
            LocalDate(2026, 10, 1),
          )!.rate,
          Decimal.parse('470'),
        );
        expect(
          rateOn(rates, Currency.usd, Currency.kzt, LocalDate(2026, 8, 31)),
          isNull,
        );
        expect(rateOn(rates, Currency.eur, Currency.kzt, today), isNull);
      },
    );

    test('сумма в базовой: та же валюта, есть курс, нет курса (§6.9)', () {
      final rate = ExchangeRate(
        id: id(),
        currency: Currency.usd,
        baseCurrency: Currency.kzt,
        rate: Decimal.parse('470.5'),
        validFrom: today,
      );
      final same = toBase(Money(350000, Currency.kzt), Currency.kzt, null);
      expect(same.amountBase, Money(350000, Currency.kzt));
      expect(same.rate, isNull);

      final usd = toBase(Money(2000, Currency.usd), Currency.kzt, rate);
      expect(usd.amountBase, Money(941000, Currency.kzt)); // DATABASE §8
      expect(usd.rate, Decimal.parse('470.5'));

      final none = toBase(Money(2000, Currency.usd), Currency.kzt, null);
      expect(none.amountBase, isNull);
    });
  });

  group('report_effect (DATABASE §5.2)', () {
    test('обычные операции', () {
      expect(reportEffectOf(TransactionKind.expense), ReportEffect.expense);
      expect(reportEffectOf(TransactionKind.income), ReportEffect.income);
      expect(reportEffectOf(TransactionKind.adjustment), ReportEffect.none);
      expect(reportEffectOf(TransactionKind.debtOut), ReportEffect.none);
      expect(
        () => reportEffectOf(TransactionKind.transferOut),
        throwsArgumentError,
      );
    });

    test('переводы по режимам счетов', () {
      const on = BudgetMode.onBudget, tr = BudgetMode.tracking;
      expect(transferEffects(on, on), (
        out: ReportEffect.none,
        into: ReportEffect.none,
      ));
      expect(transferEffects(tr, tr), (
        out: ReportEffect.none,
        into: ReportEffect.none,
      ));
      expect(transferEffects(on, tr), (
        out: ReportEffect.expense,
        into: ReportEffect.none,
      ));
      expect(transferEffects(tr, on), (
        out: ReportEffect.none,
        into: ReportEffect.income,
      ));
    });
  });

  group('Баланс счёта (§6.2)', () {
    test('начальный баланс и все типы операций со знаком', () {
      final card = account(Currency.kzt, opening: 100000);
      final other = account(Currency.kzt);
      final ops = [
        tx(TransactionKind.income, card, 50000),
        tx(TransactionKind.expense, card, 20000),
        ...transfer(card, other, 10000, 10000),
        tx(TransactionKind.adjustment, card, -500),
      ];
      expect(accountBalance(card, ops), Money(119500, Currency.kzt));
      expect(accountBalance(other, ops), Money(10000, Currency.kzt));
    });

    test('плановые и удалённые операции не влияют на баланс (I13)', () {
      final card = account(Currency.kzt);
      final ops = [
        tx(
          TransactionKind.expense,
          card,
          1000,
          status: TransactionStatus.planned,
        ),
        tx(TransactionKind.expense, card, 2000, deletedAt: at),
        tx(TransactionKind.expense, card, 300),
      ];
      expect(accountBalance(card, ops), Money(-300, Currency.kzt));
    });
  });

  group('Критерии приёмки', () {
    test('AC-01: перевод не меняет доходы, расходы и общий баланс', () {
      final card = account(Currency.kzt, opening: 50000);
      final cash = account(Currency.kzt);
      final before = [tx(TransactionKind.expense, card, 3000)];
      final after = [...before, ...transfer(card, cash, 10000, 10000)];

      expect(
        accountBalance(card, after) - accountBalance(card, before),
        Money(-10000, Currency.kzt),
      );
      expect(
        accountBalance(cash, after) - accountBalance(cash, before),
        Money(10000, Currency.kzt),
      );
      expect(
        periodSummary(after, october, Currency.kzt),
        periodSummary(before, october, Currency.kzt),
      );

      TotalBalance total(List<FinTransaction> ops) => totalBalance(
        [
          AccountWithBalance(card, accountBalance(card, ops)),
          AccountWithBalance(cash, accountBalance(cash, ops)),
        ],
        Currency.kzt,
        const [],
        today,
      );
      expect(total(after).total, total(before).total);
    });

    test('AC-02: межвалютный перевод 100 USD → 47 050 KZT', () {
      final usd = account(Currency.usd, opening: 20000);
      final kzt = account(Currency.kzt);
      final amounts = validateTransfer(
        from: usd,
        to: kzt,
        debit: Money(10000, Currency.usd),
        credit: Money(4705000, Currency.kzt),
      ).value;
      expect(amounts.isCrossCurrency, isTrue);
      expect(amounts.displayRate, Decimal.parse('470.5'));

      final ops = transfer(usd, kzt, 10000, 4705000);
      expect(accountBalance(usd, ops), Money(10000, Currency.usd));
      expect(accountBalance(kzt, ops), Money(4705000, Currency.kzt));
      final s = periodSummary(ops, october, Currency.kzt);
      expect(s.income.isZero && s.expense.isZero, isTrue);
    });

    test(
      'AC-03: перевод на счёт «только отслеживать» — расход в категории',
      () {
        final card = account(Currency.kzt, opening: 100000);
        final credit = account(
          Currency.kzt,
          opening: -500000,
          mode: BudgetMode.tracking,
        );
        final ops = transfer(card, credit, 5000000, 5000000, category: loans);
        final s = periodSummary(ops, october, Currency.kzt);
        expect(s.expense, Money(5000000, Currency.kzt));
        expect(s.income.isZero, isTrue);
        expect(ops.first.categoryId, loans);
        expect(accountBalance(card, ops), Money(-4900000, Currency.kzt));
        expect(accountBalance(credit, ops), Money(4500000, Currency.kzt));
      },
    );

    test('AC-16: нет курса EUR — итог неполный, счёт не считается нулём', () {
      final kzt = account(Currency.kzt, opening: 100000);
      final eur = account(Currency.eur, opening: 5000);
      final total = totalBalance(
        [
          AccountWithBalance(kzt, kzt.openingBalance),
          AccountWithBalance(eur, eur.openingBalance),
        ],
        Currency.kzt,
        const [],
        today,
      );
      expect(total.isComplete, isFalse);
      expect(total.missingRates, {Currency.eur});
      expect(total.total, Money(100000, Currency.kzt));
    });

    test('AC-17: новый курс не меняет историю, но меняет общий баланс', () {
      final usd = account(Currency.usd);
      final r470 = ExchangeRate(
        id: id(),
        currency: Currency.usd,
        baseCurrency: Currency.kzt,
        rate: Decimal.parse('470'),
        validFrom: LocalDate(2026, 9, 1),
      );
      final r480 = ExchangeRate(
        id: id(),
        currency: Currency.usd,
        baseCurrency: Currency.kzt,
        rate: Decimal.parse('480'),
        validFrom: LocalDate(2026, 10, 15),
      );
      final septDate = LocalDate(2026, 9, 10);
      final base = toBase(Money(1000, Currency.usd), Currency.kzt, r470);
      final expense = tx(
        TransactionKind.expense,
        usd,
        1000,
        base: base.amountBase,
        date: septDate,
      );

      final september = DatePeriod.monthOf(septDate);
      final s = periodSummary([expense], september, Currency.kzt);
      expect(
        s.expense,
        Money(470000, Currency.kzt),
      ); // 4 700 ₸ по старому курсу

      final total = totalBalance(
        [
          AccountWithBalance(usd, accountBalance(usd, [expense])),
        ],
        Currency.kzt,
        [r470, r480],
        today,
      );
      expect(total.total, Money(-480000, Currency.kzt)); // −10 USD × 480
      expect(total.oldestRateDate, LocalDate(2026, 10, 15));
    });
  });

  group('Итоги периода (§6.4)', () {
    test('операция без суммы в базовой делает итог неполным', () {
      final usd = account(Currency.usd);
      final s = periodSummary(
        [tx(TransactionKind.expense, usd, 1000, baseIsNull: true)],
        october,
        Currency.kzt,
      );
      expect(s.isComplete, isFalse);
      expect(s.expense.isZero, isTrue);
    });

    test('операции вне периода, плановые и удалённые не учитываются', () {
      final card = account(Currency.kzt);
      final s = periodSummary(
        [
          tx(TransactionKind.expense, card, 100),
          tx(TransactionKind.expense, card, 200, date: LocalDate(2026, 9, 30)),
          tx(
            TransactionKind.expense,
            card,
            400,
            status: TransactionStatus.planned,
          ),
          tx(TransactionKind.income, card, 800, deletedAt: at),
        ],
        october,
        Currency.kzt,
      );
      expect(s.expense, Money(100, Currency.kzt));
      expect(s.income.isZero, isTrue);
      expect(s.net, Money(-100, Currency.kzt));
    });

    test(
      'возврат уменьшает расход категории не ниже нуля, остаток — доход',
      () {
        final card = account(Currency.kzt);
        FinTransaction refund(int v) =>
            tx(TransactionKind.income, card, v, category: food, refund: true);
        final spent = tx(TransactionKind.expense, card, 1000, category: food);

        final partial = periodSummary(
          [spent, refund(300)],
          october,
          Currency.kzt,
        );
        expect(partial.expense, Money(700, Currency.kzt));
        expect(partial.income.isZero, isTrue);

        final over = periodSummary(
          [spent, refund(1500)],
          october,
          Currency.kzt,
        );
        expect(over.expense.isZero, isTrue);
        expect(over.income, Money(500, Currency.kzt));
      },
    );
  });

  group('Проверка перевода', () {
    final a = account(Currency.kzt);
    final b = account(Currency.kzt);
    final u = account(Currency.usd);

    test('на тот же счёт нельзя', () {
      expect(
        validateTransfer(from: a, to: a, debit: Money(100, Currency.kzt)),
        const Err<TransferAmounts>(
          ValidationFailure('toAccount', ValidationReason.sameValue),
        ),
      );
    });

    test('сумма обязательна и больше нуля', () {
      expect(validateTransfer(from: a, to: b, debit: null).isOk, isFalse);
      expect(
        validateTransfer(from: a, to: b, debit: Money(0, Currency.kzt)).isOk,
        isFalse,
      );
    });

    test('в одной валюте зачисление = списание', () {
      final r = validateTransfer(
        from: a,
        to: b,
        debit: Money(500, Currency.kzt),
      );
      expect(r.value.credit, Money(500, Currency.kzt));
      expect(r.value.displayRate, isNull);
    });

    test('в разных валютах нужна сумма зачисления', () {
      expect(
        validateTransfer(from: a, to: u, debit: Money(500, Currency.kzt)),
        const Err<TransferAmounts>(
          ValidationFailure('creditAmount', ValidationReason.required),
        ),
      );
    });
  });

  group('Модели', () {
    test('название счёта: обрезка, пустое и слишком длинное', () {
      expect(Account.validateName('  Карта  ').value, 'Карта');
      expect(Account.validateName('   ').isOk, isFalse);
      expect(Account.validateName('x' * 61).isOk, isFalse);
    });

    test('у расхода категория обязательна, сумма не отрицательна', () {
      final card = account(Currency.kzt);
      expect(
        () => FinTransaction(
          id: id(),
          kind: TransactionKind.expense,
          accountId: card.id,
          amount: Money(100, Currency.kzt),
          reportEffect: ReportEffect.expense,
          date: today,
          createdAt: at,
          updatedAt: at,
        ),
        throwsArgumentError,
      );
      expect(() => tx(TransactionKind.expense, card, -1), throwsArgumentError);
    });

    test('toString не содержит названий и сумм (DATA_SECURITY §7)', () {
      final card = account(Currency.kzt);
      final t = tx(TransactionKind.expense, card, 123456);
      expect(card.toString(), isNot(contains(card.name)));
      expect(t.toString(), isNot(contains('123456')));
    });

    test(
      'стандартные категории: ключи уникальны, 2 уровня, тот же тип у детей',
      () {
        final keys = <String>{};
        for (final c in defaultCategoriesRu) {
          expect(keys.add(c.key), isTrue, reason: c.key);
          for (final child in c.children) {
            expect(keys.add(child.key), isTrue, reason: child.key);
            expect(child.kind, c.kind);
            expect(child.children, isEmpty);
          }
        }
        expect(
          keys,
          containsAll([uncategorizedExpenseKey, uncategorizedIncomeKey]),
        );
        expect(keys, contains('loans')); // AC-03
        for (final c in defaultCategoriesRu) {
          expect(c.colorIndex, inInclusiveRange(0, 6));
          expect(c.name.length, lessThanOrEqualTo(Category.maxNameLength));
        }
      },
    );
  });
}
