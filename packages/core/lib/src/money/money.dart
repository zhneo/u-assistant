import 'package:decimal/decimal.dart';

import '../common/app_failure.dart';
import '../common/result.dart';
import 'currency.dart';

/// Денежная сумма: целое число минимальных единиц + валюта (REQUIREMENTS §6.1, D-011).
///
/// `double` для денег не используется нигде. Арифметика разрешена только между суммами
/// одной валюты; попытка сложить тенге с долларами — ошибка программиста ([ArgumentError]).
final class Money implements Comparable<Money> {
  final int amountMinor;
  final Currency currency;

  const Money(this.amountMinor, this.currency);

  factory Money.zero(Currency currency) => Money(0, currency);

  bool get isZero => amountMinor == 0;
  bool get isNegative => amountMinor < 0;
  bool get isPositive => amountMinor > 0;

  Money operator +(Money other) =>
      Money(amountMinor + _same(other).amountMinor, currency);
  Money operator -(Money other) =>
      Money(amountMinor - _same(other).amountMinor, currency);
  Money operator -() => Money(-amountMinor, currency);

  Money abs() => isNegative ? -this : this;

  @override
  int compareTo(Money other) => amountMinor.compareTo(_same(other).amountMinor);

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator >(Money other) => compareTo(other) > 0;

  Money _same(Money other) {
    if (other.currency != currency) {
      throw ArgumentError(
        'Нельзя смешивать валюты: $currency и ${other.currency}',
      );
    }
    return other;
  }

  /// Пересчёт в другую валюту по курсу «сколько единиц [target] за 1 единицу [currency]».
  ///
  /// Округление до минимальной единицы [target] — «половина к чётному», один раз (§6.9).
  Money convert(Decimal rate, Currency target) {
    if (rate <= Decimal.zero) {
      throw ArgumentError.value(rate, 'rate', 'Курс должен быть положительным');
    }
    if (target == currency) return this;
    final exact =
        Decimal.fromInt(amountMinor) *
        rate *
        Decimal.fromInt(target.minorFactor) /
        Decimal.fromInt(currency.minorFactor);
    return Money(
      roundHalfEven(exact.toDecimal(scaleOnInfinitePrecision: 12)).toInt(),
      target,
    );
  }

  /// Разбор суммы, введённой человеком: «3500», «3 500», «3 500,50», «12345.5».
  /// Пробелы (в том числе неразрывные) — разделители тысяч; «,» или «.» — дробная часть.
  static Result<Money> parse(String input, Currency currency) {
    final s = input.replaceAll(RegExp(r'[\s  ]'), '');
    final m = RegExp(r'^(-?)(\d+)(?:[.,](\d+))?$').firstMatch(s);
    if (m == null) {
      return const Err(
        ValidationFailure('amount', ValidationReason.invalidFormat),
      );
    }
    final fraction = m.group(3) ?? '';
    if (fraction.length > currency.minorUnits) {
      return const Err(
        ValidationFailure('amount', ValidationReason.invalidFormat),
      );
    }
    final whole = int.parse(m.group(2)!);
    final minor = int.parse(
      fraction.padRight(currency.minorUnits, '0').isEmpty
          ? '0'
          : fraction.padRight(currency.minorUnits, '0'),
    );
    final value = whole * currency.minorFactor + minor;
    return Ok(Money(m.group(1) == '-' ? -value : value, currency));
  }

  /// Формат для интерфейса на русском: `1 234 567,89 ₸`, `−3 500 ₸` (NFR-L10N-02).
  ///
  /// [showZeroMinor] = false скрывает «,00» (списки); в формах и экспорте — true.
  String format({bool showZeroMinor = false, bool withSymbol = true}) {
    final negative = amountMinor < 0;
    final abs = amountMinor.abs();
    final factor = currency.minorFactor;
    final whole = abs ~/ factor;
    final minor = abs % factor;
    final grouped = _group(whole.toString());
    final minorPart = currency.minorUnits == 0 || (minor == 0 && !showZeroMinor)
        ? ''
        : ',${minor.toString().padLeft(currency.minorUnits, '0')}';
    final sign = negative ? '−' : '';
    final symbol = withSymbol ? ' ${currency.symbol}' : '';
    return '$sign$grouped$minorPart$symbol';
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
      other is Money &&
      other.amountMinor == amountMinor &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(amountMinor, currency);

  @override
  String toString() => 'Money($amountMinor ${currency.code})';
}

/// Округление «половина к чётному» (банковское), REQUIREMENTS §6.9.
BigInt roundHalfEven(Decimal x) {
  final floor = x.floor();
  final frac = x - floor;
  final half = Decimal.parse('0.5');
  final f = floor.toBigInt();
  if (frac > half) return f + BigInt.one;
  if (frac < half) return f;
  return f.isEven ? f : f + BigInt.one;
}
