import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/clock_provider.dart';
import 'database/app_database.dart';
import 'database/database_provider.dart';
import 'finance/finance_repositories.dart';
import 'settings/drift_settings_repository.dart';

/// Провайдеры слоя данных. Типы — интерфейсы `core`: сценарии и тесты не зависят от drift.

final class DriftUnitOfWork implements UnitOfWork {
  final AppDatabase _db;
  DriftUnitOfWork(this._db);

  @override
  Future<T> run<T>(Future<T> Function() action) => _db.transaction(action);
}

final unitOfWorkProvider = Provider<UnitOfWork>(
  (ref) => DriftUnitOfWork(ref.watch(databaseProvider)),
);

/// Конкретный тип нужен запуску приложения (`load()`) и репозиторию операций.
final driftSettingsProvider = Provider<DriftSettingsRepository>(
  (ref) => DriftSettingsRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => ref.watch(driftSettingsProvider),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => DriftAccountRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => DriftCategoryRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => DriftExchangeRateRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final settings = ref.watch(driftSettingsProvider);
  return DriftTransactionRepository(
    ref.watch(databaseProvider),
    () => settings.cachedBase,
  );
});
