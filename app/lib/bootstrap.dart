import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:core/core.dart' show SystemClock;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'data/database/database_key.dart';
import 'data/database/database_provider.dart';
import 'data/providers.dart';
import 'data/settings/drift_settings_repository.dart';
import 'platform/secure_key_store.dart';
import 'services/logging/app_logging.dart';

final _log = Logger('startup');

/// Запуск (ARCHITECTURE §1.2 «bootstrap»): журнал → перехват ошибок → форматы дат → база → UI.
/// Блокировка (SCR-01) и онбординг (SCR-02) встанут перед UI в вехах M3 и M1.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final support = await getApplicationSupportDirectory();
  setupLogging(Directory('${support.path}/logs'), echoToConsole: kDebugMode);

  // Неожиданные ошибки не роняют приложение молча: тип и стек — в журнал (ARCHITECTURE §9).
  FlutterError.onError = (details) {
    Logger('flutter')
        .severe('FlutterError', details.exception.runtimeType, details.stack);
    if (kDebugMode) FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger('platform').severe('Uncaught', error.runtimeType, stack);
    return true;
  };

  await initializeDateFormatting('ru');

  AppDatabase? db;
  DriftSettingsRepository? settings;
  try {
    final key = await obtainDatabaseKey(FlutterSecureKeyStore());
    db = openAppDatabase(File('${support.path}/u_assistant.db'), key);
    await db.customSelect('SELECT 1').get();
    _log.info('database opened, schema v${db.schemaVersion}');
    // Базовая валюта нужна синхронно при чтении операций — загружаем до UI.
    settings = DriftSettingsRepository(db, const SystemClock());
    await settings.load();
  } catch (e, s) {
    _log.severe('database open failed', e.runtimeType, s);
    db = null;
  }

  runApp(
    ProviderScope(
      overrides: [
        if (db != null) databaseProvider.overrideWithValue(db),
        if (settings != null) driftSettingsProvider.overrideWithValue(settings),
      ],
      child: UAssistantApp(startupFailed: db == null),
    ),
  );
}
