import 'dart:convert';

import 'package:core/core.dart';

import '../database/app_database.dart';

/// Настройки поверх `app_setting` (DATABASE §4.1). Значения хранятся в JSON.
///
/// Базовая валюта нужна синхронно (перевод строк операций в модели), поэтому
/// она держится в памяти: [load] вызывается при запуске, [setBaseCurrency] обновляет копию.
final class DriftSettingsRepository implements SettingsRepository {
  static const _baseCurrencyKey = 'base_currency';
  static const _lastAccountKey = 'last_account_id';

  final AppDatabase _db;
  final Clock _clock;
  Currency? _cachedBase;

  DriftSettingsRepository(this._db, this._clock);

  /// Читает базовую валюту в память. Вызывается один раз при запуске.
  Future<void> load() async => _cachedBase = await baseCurrency();

  /// Базовая валюта из памяти; до онбординга — исключение (ошибка программиста).
  Currency get cachedBase =>
      _cachedBase ?? (throw StateError('Базовая валюта ещё не задана'));

  Future<String?> _read(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row == null ? null : jsonDecode(row.value) as String?;
  }

  Future<void> _write(String key, String value) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          key: key,
          value: jsonEncode(value),
          updatedAt: _clock.now().toUtc().millisecondsSinceEpoch,
        ),
      );

  @override
  Stream<Currency?> watchBaseCurrency() =>
      (_db.select(
        _db.appSettings,
      )..where((s) => s.key.equals(_baseCurrencyKey))).watchSingleOrNull().map(
        (row) => row == null
            ? null
            : Currency.tryParse(jsonDecode(row.value) as String),
      );

  @override
  Future<Currency?> baseCurrency() async {
    final code = await _read(_baseCurrencyKey);
    return code == null ? null : Currency.tryParse(code);
  }

  @override
  Future<void> setBaseCurrency(Currency currency) async {
    await _write(_baseCurrencyKey, currency.code);
    _cachedBase = currency;
  }

  @override
  Future<EntityId?> lastAccountId() async {
    final id = await _read(_lastAccountKey);
    return id == null ? null : EntityId(id);
  }

  @override
  Future<void> setLastAccountId(EntityId id) =>
      _write(_lastAccountKey, id.value);
}
