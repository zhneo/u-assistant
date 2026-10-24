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
  static const _onboardingStepKey = 'onboarding_step';
  static const _onboardingDoneKey = 'onboarding_done';

  final AppDatabase _db;
  final Clock _clock;
  Currency? _cachedBase;

  DriftSettingsRepository(this._db, this._clock);

  /// Читает базовую валюту в память. Вызывается один раз при запуске.
  Future<void> load() async => _cachedBase = await baseCurrency();

  /// Базовая валюта из памяти; до онбординга — исключение (ошибка программиста).
  Currency get cachedBase =>
      _cachedBase ?? (throw StateError('Базовая валюта ещё не задана'));

  Future<Object?> _read(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row == null ? null : jsonDecode(row.value);
  }

  Stream<Object?> _watch(String key) =>
      (_db.select(_db.appSettings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : jsonDecode(row.value));

  Future<void> _write(String key, Object value) => _db
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
      _watch(_baseCurrencyKey)
          .map((v) => v == null ? null : Currency.tryParse(v as String));

  @override
  Future<Currency?> baseCurrency() async {
    final code = await _read(_baseCurrencyKey);
    return code == null ? null : Currency.tryParse(code as String);
  }

  @override
  Future<void> setBaseCurrency(Currency currency) async {
    await _write(_baseCurrencyKey, currency.code);
    _cachedBase = currency;
  }

  @override
  Future<EntityId?> lastAccountId() async {
    final id = await _read(_lastAccountKey);
    return id == null ? null : EntityId(id as String);
  }

  @override
  Future<void> setLastAccountId(EntityId id) =>
      _write(_lastAccountKey, id.value);

  @override
  Future<int> onboardingStep() async =>
      (await _read(_onboardingStepKey) as int?) ?? 0;

  @override
  Future<void> setOnboardingStep(int step) => _write(_onboardingStepKey, step);

  @override
  Stream<bool> watchOnboardingDone() =>
      _watch(_onboardingDoneKey).map((v) => v == true);

  @override
  Future<void> completeOnboarding() => _write(_onboardingDoneKey, true);
}
