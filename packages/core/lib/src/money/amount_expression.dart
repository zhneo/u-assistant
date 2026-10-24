import 'package:decimal/decimal.dart';

import 'currency.dart';
import 'money.dart';

/// Ввод суммы с цифровой клавиатуры и простым калькулятором (FR-FIN-06, DESIGN_SYSTEM §8.11).
///
/// Хранит набранное как текст: цифры, «,» и знаки `+ - * /`. Число знаков после запятой
/// ограничено разрядностью валюты. Вычисление — в `Decimal`, результат округляется
/// до минимальной единицы «половина к чётному» (§6.9). `double` не используется.
final class AmountExpression {
  /// Клавиши, которые понимает [input].
  static const backspace = '⌫';
  static const thousand = '000';
  static const comma = ',';
  static const plus = '+', minus = '-', times = '*', divide = '/';
  static const _operators = {plus, minus, times, divide};

  /// Максимум цифр в целой части одного числа: 12 — больше триллиона.
  static const _maxWholeDigits = 12;

  final String text;
  const AmountExpression([this.text = '']);

  bool get isEmpty => text.isEmpty;

  /// Есть ли действие калькулятора — тогда под суммой показывается «= итог».
  bool get hasOperator => text.split('').skip(1).any(_operators.contains);

  String get _lastNumber {
    final i = text.lastIndexOf(RegExp(r'[+\-*/]'));
    return text.substring(i + 1);
  }

  /// Новое выражение после нажатия клавиши [key] для валюты [currency].
  AmountExpression input(String key, Currency currency) {
    if (key == backspace) {
      return text.isEmpty
          ? this
          : AmountExpression(text.substring(0, text.length - 1));
    }
    if (_operators.contains(key)) {
      if (text.isEmpty) return this;
      var t = text;
      if (t.endsWith(comma)) t = t.substring(0, t.length - 1);
      if (_operators.contains(t[t.length - 1])) {
        t = t.substring(0, t.length - 1);
      }
      return AmountExpression('$t$key');
    }
    final number = _lastNumber;
    if (key == comma) {
      if (currency.minorUnits == 0 || number.contains(comma)) return this;
      return AmountExpression(number.isEmpty ? '${text}0,' : '$text,');
    }
    if (RegExp(r'^\d+$').hasMatch(key)) {
      final parts = number.split(comma);
      if (parts.length == 2) {
        final room = currency.minorUnits - parts[1].length;
        if (room <= 0) return this;
        return AmountExpression(
          '$text${key.substring(0, key.length.clamp(0, room))}',
        );
      }
      if (number.isEmpty && key.startsWith('0')) {
        // Ведущие нули не набираются: «000» на пустом месте ничего не делает.
        return key == thousand ? this : AmountExpression('${text}0');
      }
      if (number == '0') {
        if (key == thousand) return this;
        return AmountExpression('${text.substring(0, text.length - 1)}$key');
      }
      if (number.length + key.length > _maxWholeDigits) return this;
      return AmountExpression('$text$key');
    }
    throw ArgumentError.value(key, 'key', 'Неизвестная клавиша');
  }

  /// Итог в [currency] или null, если выражение пустое или делится на ноль.
  /// Может быть ≤ 0 — проверка «сумма больше нуля» остаётся за сценарием.
  Money? evaluate(Currency currency) {
    var t = text;
    while (t.isNotEmpty &&
        (_operators.contains(t[t.length - 1]) || t.endsWith(comma))) {
      t = t.substring(0, t.length - 1);
    }
    if (t.isEmpty) return null;

    final tokens = <Object>[];
    final buf = StringBuffer();
    for (final ch in t.split('')) {
      if (_operators.contains(ch) && buf.isNotEmpty) {
        tokens
          ..add(Decimal.parse(buf.toString().replaceAll(comma, '.')))
          ..add(ch);
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    tokens.add(Decimal.parse(buf.toString().replaceAll(comma, '.')));

    // Сначала × и ÷, затем + и − — как в обычном калькуляторе.
    final sums = <Object>[tokens.first];
    for (var i = 1; i < tokens.length; i += 2) {
      final op = tokens[i] as String;
      final value = tokens[i + 1] as Decimal;
      if (op == times || op == divide) {
        final left = sums.removeLast() as Decimal;
        if (op == divide && value == Decimal.zero) return null;
        sums.add(
          op == times
              ? left * value
              : (left / value).toDecimal(scaleOnInfinitePrecision: 10),
        );
      } else {
        sums
          ..add(op)
          ..add(value);
      }
    }
    var result = sums.first as Decimal;
    for (var i = 1; i < sums.length; i += 2) {
      final value = sums[i + 1] as Decimal;
      result = sums[i] == plus ? result + value : result - value;
    }
    final minor = roundHalfEven(result * Decimal.fromInt(currency.minorFactor));
    return Money(minor.toInt(), currency);
  }

  /// Выражение для показа: «1 500 + 300», «12,5 × 3»; пустое — «0».
  /// Разряды — неразрывным пробелом, как в [Money.format].
  String display() {
    if (text.isEmpty) return '0';
    final b = StringBuffer();
    final number = StringBuffer();
    void flush() {
      if (number.isEmpty) return;
      final parts = number.toString().split(comma);
      b.write(_group(parts[0]));
      if (parts.length == 2) b.write(',${parts[1]}');
      number.clear();
    }

    for (final ch in text.split('')) {
      if (_operators.contains(ch)) {
        flush();
        b.write(switch (ch) {
          plus => ' + ',
          minus => ' − ',
          times => ' × ',
          _ => ' ÷ ',
        });
      } else {
        number.write(ch);
      }
    }
    flush();
    return b.toString().trimRight();
  }

  /// Выражение из готовой суммы — для правки существующей операции.
  factory AmountExpression.fromMoney(Money m) {
    final factor = m.currency.minorFactor;
    final whole = m.amountMinor.abs() ~/ factor;
    final minor = m.amountMinor.abs() % factor;
    if (minor == 0) return AmountExpression('$whole');
    final fraction = minor
        .toString()
        .padLeft(m.currency.minorUnits, '0')
        .replaceFirst(RegExp(r'0+$'), '');
    return AmountExpression('$whole,$fraction');
  }

  static String _group(String digits) {
    final b = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) b.write(' ');
      b.write(digits[i]);
    }
    return b.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is AmountExpression && other.text == text;

  @override
  int get hashCode => text.hashCode;
}
