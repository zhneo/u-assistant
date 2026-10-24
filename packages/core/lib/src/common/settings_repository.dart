import '../money/currency.dart';
import 'entity_id.dart';

/// Типизированные настройки поверх `app_setting` (DATABASE §4.1, ARCHITECTURE §6).
abstract interface class SettingsRepository {
  /// Базовая валюта; null — онбординг ещё не пройден (FR-FIN-14).
  Stream<Currency?> watchBaseCurrency();
  Future<Currency?> baseCurrency();
  Future<void> setBaseCurrency(Currency currency);

  /// Последний использованный счёт — по умолчанию в новой операции (FR-FIN-05).
  Future<EntityId?> lastAccountId();
  Future<void> setLastAccountId(EntityId id);
}
