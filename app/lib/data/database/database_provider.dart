import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// База приложения. Открывается при запуске (bootstrap) и подставляется через override;
/// в тестах — база в памяти.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'databaseProvider должен быть переопределён при запуске',
  ),
);
