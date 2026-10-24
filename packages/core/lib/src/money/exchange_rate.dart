import 'package:decimal/decimal.dart';

import '../common/app_failure.dart';
import '../common/entity_id.dart';
import '../common/local_date.dart';
import '../common/result.dart';
import 'currency.dart';
import 'money.dart';

/// Курс, введённый вручную (FR-FIN-15, DATABASE §4.4):
/// «1 [currency] = [rate] [baseCurrency]», действует с [validFrom].
final class ExchangeRate {
  final EntityId id;
  final Currency currency;
  final Currency baseCurrency;
  final Decimal rate;
  final LocalDate validFrom;

  ExchangeRate({
    required this.id,
    required this.currency,
    required this.baseCurrency,
    required this.rate,
    required this.validFrom,
  }) {
    if (rate <= Decimal.zero) {
      throw ArgumentError.value(rate, 'rate', 'Курс должен быть положительным');
    }
    if (currency == baseCurrency) {
      throw ArgumentError('Курс валюты к самой себе не хранится');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ExchangeRate &&
      other.id == id &&
      other.currency == currency &&
      other.baseCurrency == baseCurrency &&
      other.rate == rate &&
      other.validFrom == validFrom;

  @override
  int get hashCode => Object.hash(id, currency, baseCurrency, rate, validFrom);

  @override
  String toString() => 'ExchangeRate($currency→$baseCurrency from $validFrom)';
}

/// Курс, действующий на [date]: максимальный `validFrom ≤ date` (DATABASE §4.4).
/// Возвращает null, если курса нет: приложение не подставляет выдуманный (FR-FIN-16).
ExchangeRate? rateOn(
  Iterable<ExchangeRate> rates,
  Currency currency,
  Currency base,
  LocalDate date,
) {
  ExchangeRate? best;
  for (final r in rates) {
    if (r.currency != currency || r.baseCurrency != base) continue;
    if (r.validFrom.isAfter(date)) continue;
    if (best == null || r.validFrom.isAfter(best.validFrom)) best = r;
  }
  return best;
}

/// Разбор курса, введённого человеком: «470,50», «470.5», «1 250».
/// Не больше 10 знаков после запятой, строго больше нуля.
Result<Decimal> parseRate(String input) {
  final s = input.replaceAll(RegExp(r'[\s  ]'), '').replaceAll(',', '.');
  final m = RegExp(r'^\d+(\.\d{1,10})?$').firstMatch(s);
  if (m == null) {
    return const Err(ValidationFailure('rate', ValidationReason.invalidFormat));
  }
  final value = Decimal.parse(s);
  if (value <= Decimal.zero) {
    return const Err(
      ValidationFailure('rate', ValidationReason.mustBePositive),
    );
  }
  return Ok(value);
}

/// Курс для интерфейса: «470,50», «0,0021», «1 250,00» — не меньше двух знаков после запятой.
String formatRate(Decimal rate) {
  var s = rate.toString();
  if (!s.contains('.')) s = '$s.00';
  final parts = s.split('.');
  var frac = parts[1];
  if (frac.length < 2) frac = frac.padRight(2, '0');
  final whole = parts[0];
  final b = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) b.write(' ');
    b.write(whole[i]);
  }
  return '$b,$frac';
}

/// Сумма операции в базовой валюте, фиксируемая при записи (REQUIREMENTS §6.4, §6.9, I8).
///
/// - валюта совпадает с базовой → курс не нужен, сумма та же;
/// - курс есть → пересчёт с округлением «половина к чётному» один раз;
/// - курса нет → `amountBase = null`, итог будет помечен «неполный» (AC-16).
({Decimal? rate, Money? amountBase}) toBase(
  Money amount,
  Currency base,
  ExchangeRate? rate,
) {
  if (amount.currency == base) return (rate: null, amountBase: amount);
  if (rate == null) return (rate: null, amountBase: null);
  assert(rate.currency == amount.currency && rate.baseCurrency == base);
  return (rate: rate.rate, amountBase: amount.convert(rate.rate, base));
}
