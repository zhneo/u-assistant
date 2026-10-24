/// Валюта по ISO 4217 с числом дробных разрядов (REQUIREMENTS §6.1).
///
/// Таблица — встроенная константа (NFR-NET-03: ничего не грузится из сети).
/// Источник разрядности — ISO 4217 «List one» (SIX Group). Набор расширяется по мере надобности;
/// неизвестный код не угадывается, а отклоняется ([Currency.tryParse] возвращает null).
final class Currency {
  final String code;
  final int minorUnits;
  final String symbol;

  const Currency._(this.code, this.minorUnits, this.symbol);

  /// Множитель «основная единица → минимальная»: 100 для KZT, 1 для JPY, 1000 для KWD.
  int get minorFactor => _pow10(minorUnits);

  static Currency? tryParse(String code) => _byCode[code.toUpperCase()];

  static Currency of(String code) =>
      tryParse(code) ??
      (throw ArgumentError.value(code, 'code', 'Неизвестная валюта ISO 4217'));

  static Iterable<Currency> get all => _byCode.values;

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;

  static const kzt = Currency._('KZT', 2, '₸');
  static const usd = Currency._('USD', 2, r'$');
  static const eur = Currency._('EUR', 2, '€');
  static const rub = Currency._('RUB', 2, '₽');
  static const jpy = Currency._('JPY', 0, '¥');
  static const kwd = Currency._('KWD', 3, 'KWD');
}

int _pow10(int n) {
  var r = 1;
  for (var i = 0; i < n; i++) {
    r *= 10;
  }
  return r;
}

const _list = <Currency>[
  Currency.kzt,
  Currency.usd,
  Currency.eur,
  Currency.rub,
  Currency.jpy,
  Currency.kwd,
  Currency._('KGS', 2, 'KGS'),
  Currency._('UZS', 2, 'UZS'),
  Currency._('TJS', 2, 'TJS'),
  Currency._('TMT', 2, 'TMT'),
  Currency._('AZN', 2, '₼'),
  Currency._('AMD', 2, '֏'),
  Currency._('GEL', 2, '₾'),
  Currency._('BYN', 2, 'Br'),
  Currency._('UAH', 2, '₴'),
  Currency._('MNT', 2, '₮'),
  Currency._('CNY', 2, '¥'),
  Currency._('TRY', 2, '₺'),
  Currency._('AED', 2, 'AED'),
  Currency._('GBP', 2, '£'),
  Currency._('CHF', 2, 'CHF'),
  Currency._('CAD', 2, 'CAD'),
  Currency._('AUD', 2, 'AUD'),
  Currency._('PLN', 2, 'zł'),
  Currency._('CZK', 2, 'Kč'),
  Currency._('HUF', 2, 'Ft'),
  Currency._('SEK', 2, 'kr'),
  Currency._('NOK', 2, 'kr'),
  Currency._('DKK', 2, 'kr'),
  Currency._('INR', 2, '₹'),
  Currency._('THB', 2, '฿'),
  Currency._('IDR', 2, 'Rp'),
  Currency._('KRW', 0, '₩'),
  Currency._('VND', 0, '₫'),
  Currency._('ISK', 0, 'kr'),
  Currency._('CLP', 0, 'CLP'),
  Currency._('BHD', 3, 'BHD'),
  Currency._('OMR', 3, 'OMR'),
  Currency._('JOD', 3, 'JOD'),
  Currency._('TND', 3, 'TND'),
];

final Map<String, Currency> _byCode = {for (final c in _list) c.code: c};
