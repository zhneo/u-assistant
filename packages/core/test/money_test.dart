import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:test/test.dart';

Decimal d(String s) => Decimal.parse(s);

void main() {
  group('Currency', () {
    test('разрядность по ISO 4217', () {
      expect(Currency.kzt.minorUnits, 2);
      expect(Currency.jpy.minorUnits, 0);
      expect(Currency.kwd.minorUnits, 3);
      expect(Currency.kwd.minorFactor, 1000);
    });

    test('неизвестный код не угадывается', () {
      expect(Currency.tryParse('XYZ'), isNull);
      expect(() => Currency.of('XYZ'), throwsArgumentError);
      expect(Currency.tryParse('kzt'), Currency.kzt);
    });
  });

  group('Money: арифметика', () {
    test('сложение и вычитание одной валюты', () {
      final a = const Money(350000, Currency.kzt);
      final b = const Money(150050, Currency.kzt);
      expect(a + b, const Money(500050, Currency.kzt));
      expect(b - a, const Money(-199950, Currency.kzt));
      expect((b - a).abs(), const Money(199950, Currency.kzt));
    });

    test('смешивать валюты нельзя', () {
      expect(
        () => const Money(100, Currency.kzt) + const Money(100, Currency.usd),
        throwsArgumentError,
      );
      expect(
        () => const Money(
          100,
          Currency.kzt,
        ).compareTo(const Money(100, Currency.usd)),
        throwsArgumentError,
      );
    });
  });

  group('Money: конвертация (§6.9)', () {
    test('пример DATABASE §8: 20,00 USD по 470,5 = 9 410,00 ₸', () {
      expect(
        const Money(2000, Currency.usd).convert(d('470.5'), Currency.kzt),
        const Money(941000, Currency.kzt),
      );
    });

    test('разная разрядность: 1 000 JPY по 3,2 ₸ = 3 200,00 ₸', () {
      expect(
        const Money(1000, Currency.jpy).convert(d('3.2'), Currency.kzt),
        const Money(320000, Currency.kzt),
      );
    });

    test('в валюту с 0 разрядов: 10,00 USD по 151,555 JPY = 1 516 JPY', () {
      expect(
        const Money(1000, Currency.usd).convert(d('151.555'), Currency.jpy),
        const Money(1516, Currency.jpy),
      );
    });

    test('та же валюта — без изменений; курс ≤ 0 — ошибка', () {
      expect(
        const Money(5, Currency.kzt).convert(d('2'), Currency.kzt),
        const Money(5, Currency.kzt),
      );
      expect(
        () => const Money(5, Currency.usd).convert(d('0'), Currency.kzt),
        throwsArgumentError,
      );
    });
  });

  group('roundHalfEven', () {
    final cases = {
      '0.5': 0,
      '1.5': 2,
      '2.5': 2,
      '3.5': 4,
      '2.4999': 2,
      '2.5001': 3,
      '-0.5': 0,
      '-1.5': -2,
      '-2.5': -2,
      '-2.6': -3,
      '7': 7,
    };
    cases.forEach((input, expected) {
      test(
        '$input → $expected',
        () => expect(roundHalfEven(d(input)).toInt(), expected),
      );
    });
  });

  group('Money.parse', () {
    test('разные записи одной суммы', () {
      for (final s in ['3500', '3 500', '3 500', '3500,00', '3500.0']) {
        expect(
          Money.parse(s, Currency.kzt).value,
          const Money(350000, Currency.kzt),
          reason: s,
        );
      }
      expect(
        Money.parse('12 345,5', Currency.kzt).value,
        const Money(1234550, Currency.kzt),
      );
      expect(
        Money.parse('-20', Currency.usd).value,
        const Money(-2000, Currency.usd),
      );
    });

    test('лишние дробные разряды и мусор отклоняются', () {
      expect(Money.parse('10,123', Currency.kzt).isOk, isFalse);
      expect(Money.parse('10,5', Currency.jpy).isOk, isFalse);
      expect(Money.parse('3,5к', Currency.kzt).isOk, isFalse);
      expect(Money.parse('', Currency.kzt).isOk, isFalse);
    });
  });

  group('Money.format (ru)', () {
    test('разделители, символ, скрытие нулевых копеек', () {
      expect(const Money(123456789, Currency.kzt).format(), '1 234 567,89 ₸');
      expect(const Money(350000, Currency.kzt).format(), '3 500 ₸');
      expect(
        const Money(350000, Currency.kzt).format(showZeroMinor: true),
        '3 500,00 ₸',
      );
      expect(const Money(-350000, Currency.kzt).format(), '−3 500 ₸');
      expect(const Money(1516, Currency.jpy).format(), '1 516 ¥');
      expect(const Money(5, Currency.kwd).format(), '0,005 KWD');
      expect(const Money(99, Currency.usd).format(withSymbol: false), '0,99');
    });
  });
}
