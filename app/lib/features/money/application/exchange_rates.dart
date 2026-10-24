import 'package:core/core.dart';

/// Сохранить курс «1 [currency] = rate базовой» с датой действия (SCR-44, FR-FIN-15).
///
/// Операции этой валюты, у которых суммы в базовой ещё нет (курса не было), дополняются
/// по курсу на дату операции. Операции с уже зафиксированной суммой не меняются (I8).
final class SaveExchangeRate {
  final UnitOfWork _uow;
  final ExchangeRateRepository _rates;
  final TransactionRepository _transactions;
  final SettingsRepository _settings;
  final Clock _clock;

  SaveExchangeRate(
    this._uow,
    this._rates,
    this._transactions,
    this._settings,
    this._clock,
  );

  /// Возвращает число операций, получивших сумму в базовой валюте.
  Future<Result<int>> call({
    required Currency currency,
    required String rateText,
    required LocalDate validFrom,
  }) async {
    final parsed = parseRate(rateText);
    if (parsed case Err(:final failure)) return Err(failure);
    final base = await _settings.baseCurrency();
    if (base == null) throw StateError('Базовая валюта не задана');
    if (currency == base) {
      return const Err(
        ValidationFailure('currency', ValidationReason.sameValue),
      );
    }

    return _uow.run(() async {
      await _rates.save(
        ExchangeRate(
          id: EntityId.generate(),
          currency: currency,
          baseCurrency: base,
          rate: parsed.value,
          validFrom: validFrom,
        ),
      );
      var filled = 0;
      final now = _clock.now().toUtc();
      for (final t in await _transactions.missingBase(currency)) {
        final rate = await _rates.at(currency, base, t.date);
        if (rate == null) continue;
        final priced = toBase(t.amount, base, rate);
        await _transactions.update(
          t.copyWith(
            rateToBase: priced.rate,
            amountBase: priced.amountBase,
            updatedAt: now,
          ),
        );
        filled++;
      }
      return Ok(filled);
    });
  }
}
