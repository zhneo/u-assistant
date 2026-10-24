import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'finance_seed.dart';

/// Шаги онбординга SCR-02. Шаг запоминается: если приложение закрыли на шаге 2 или 3,
/// при следующем запуске онбординг продолжается с того же места.
abstract final class OnboardingStep {
  static const currency = 0;
  static const cash = 1;
  static const privacy = 2;
}

final class OnboardingFlow {
  final UnitOfWork _uow;
  final SettingsRepository _settings;
  final AccountRepository _accounts;
  final EnsureDefaultCategories _ensureCategories;

  OnboardingFlow(
    this._uow,
    this._settings,
    this._accounts,
    this._ensureCategories,
  );

  Future<int> currentStep() => _settings.onboardingStep();

  /// Шаг 1 «Далее»: базовая валюта и стандартные категории — одной транзакцией.
  Future<void> chooseCurrency(Currency currency) => _uow.run(() async {
    await _settings.setBaseCurrency(currency);
    await _ensureCategories();
    await _settings.setOnboardingStep(OnboardingStep.cash);
  });

  /// Шаг 2 «Создать счёт»: счёт наличных в базовой валюте (начальный баланс может быть 0).
  Future<Result<Account>> createCashAccount(String name, Money opening) async {
    final checked = Account.validateName(name);
    if (checked case Err(:final failure)) return Err(failure);
    final base = await _settings.baseCurrency();
    if (base == null || opening.currency != base) {
      throw StateError('Счёт наличных создаётся в базовой валюте');
    }
    final account = Account(
      id: EntityId.generate(),
      name: checked.value,
      type: AccountType.cash,
      currency: base,
      openingBalance: opening,
      icon: AccountType.cash.defaultIcon,
    );
    await _uow.run(() async {
      await _accounts.save(account);
      await _settings.setLastAccountId(account.id);
      await _settings.setOnboardingStep(OnboardingStep.privacy);
    });
    return Ok(account);
  }

  /// Шаг 2 «Пропустить».
  Future<void> skipCashAccount() =>
      _settings.setOnboardingStep(OnboardingStep.privacy);

  /// Шаг 3 «Начать».
  Future<void> complete() => _settings.completeOnboarding();
}

final ensureDefaultCategoriesProvider = Provider(
  (ref) => EnsureDefaultCategories(ref.watch(categoryRepositoryProvider)),
);

final onboardingFlowProvider = Provider(
  (ref) => OnboardingFlow(
    ref.watch(unitOfWorkProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(accountRepositoryProvider),
    ref.watch(ensureDefaultCategoriesProvider),
  ),
);

/// Пройден ли онбординг — для охранника маршрутов.
final onboardingDoneProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchOnboardingDone(),
);
