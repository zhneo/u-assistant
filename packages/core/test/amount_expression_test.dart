import 'package:core/core.dart';
import 'package:test/test.dart';

/// Клавиатура суммы и калькулятор (FR-FIN-06): разрядность по валюте, без double.
void main() {
  AmountExpression type(String keys, [Currency c = Currency.kzt]) {
    var e = const AmountExpression();
    for (final k in keys.split(' ')) {
      e = e.input(k, c);
    }
    return e;
  }

  test('цифры и «000» складываются в сумму', () {
    final e = type('3 5 000');
    expect(e.evaluate(Currency.kzt), Money(3500000, Currency.kzt));
    expect(e.display(), '35\u00A0000');
  });

  test('дробная часть не длиннее разрядов валюты', () {
    expect(type('1 , 2 5 9').text, '1,25');
    expect(type('1 , 2 5').evaluate(Currency.kzt), Money(125, Currency.kzt));
    expect(type('7 , 5', Currency.jpy).text, '75'); // у иены нет копеек
    expect(
      type('1 , 2 3 4', Currency.kwd).evaluate(Currency.kwd),
      Money(1234, Currency.kwd),
    );
  });

  test('ведущие нули и запятая на пустом месте', () {
    expect(type('0 0 5').text, '5');
    expect(type('000').text, '');
    expect(type(',').text, '0,');
    expect(type(', , 5').text, '0,5');
  });

  test('стирание по одному символу', () {
    expect(type('1 2 3 ⌫').text, '12');
    expect(const AmountExpression().input('⌫', Currency.kzt).text, '');
  });

  test('калькулятор: порядок действий, как в обычном калькуляторе', () {
    final e = type('1 000 + 5 0 0 * 2');
    expect(e.hasOperator, isTrue);
    expect(
      e.evaluate(Currency.kzt),
      Money(200000, Currency.kzt),
    ); // 1000 + 1000
    expect(e.display(), '1\u00A0000 + 500 × 2');
  });

  test('деление округляется «половина к чётному» до тиына', () {
    // 10 / 3 = 3,333… → 3,33
    expect(type('1 0 / 3').evaluate(Currency.kzt), Money(333, Currency.kzt));
    // 0,05 / 2 = 0,025 → 0,02 (к чётному)
    expect(type(', 0 5 / 2').evaluate(Currency.kzt), Money(2, Currency.kzt));
    // 0,15 / 2 = 0,075 → 0,08
    expect(type(', 1 5 / 2').evaluate(Currency.kzt), Money(8, Currency.kzt));
  });

  test('деление на ноль — нет результата; знак в конце не мешает', () {
    expect(type('5 / 0').evaluate(Currency.kzt), isNull);
    expect(type('5 +').evaluate(Currency.kzt), Money(500, Currency.kzt));
    expect(type('5 + *').text, '5*'); // второй знак заменяет первый
  });

  test('результат может быть отрицательным — проверку делает сценарий', () {
    expect(type('5 - 8').evaluate(Currency.kzt), Money(-300, Currency.kzt));
  });

  test('пустое выражение', () {
    expect(const AmountExpression().evaluate(Currency.kzt), isNull);
    expect(const AmountExpression().display(), '0');
    expect(type('+').text, '');
  });

  test('из готовой суммы для правки', () {
    expect(
      AmountExpression.fromMoney(Money(350000, Currency.kzt)).text,
      '3500',
    );
    expect(
      AmountExpression.fromMoney(Money(350050, Currency.kzt)).text,
      '3500,5',
    );
    expect(AmountExpression.fromMoney(Money(1234, Currency.kwd)).text, '1,234');
  });

  test('не больше 12 цифр в целой части', () {
    final e = type('9 9 9 9 9 9 9 9 9 9 9 9 9');
    expect(e.text.length, 12);
  });
}
