import '../money/currency.dart';
import 'entity_id.dart';

/// Типизированные настройки поверх `app_setting` (DATABASE §4.1, ARCHITECTURE §6).
abstract interface class SettingsRepository {
  /// Базовая валюта; null — онбординг ещё не дошёл до выбора валюты (FR-FIN-14).
  Stream<Currency?> watchBaseCurrency();
  Future<Currency?> baseCurrency();
  Future<void> setBaseCurrency(Currency currency);

  /// Последний использованный счёт — по умолчанию в новой операции (FR-FIN-05).
  Future<EntityId?> lastAccountId();
  Future<void> setLastAccountId(EntityId id);

  /// Шаг онбординга, на котором приложение закрыли (SCR-02: продолжить с того же шага).
  Future<int> onboardingStep();
  Future<void> setOnboardingStep(int step);

  /// Онбординг пройден — охранник маршрутов пускает в приложение (ARCHITECTURE §4).
  Stream<bool> watchOnboardingDone();
  Future<void> completeOnboarding();
}
