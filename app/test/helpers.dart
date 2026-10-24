import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:u_assistant/app.dart';
import 'package:u_assistant/data/database/app_database.dart';
import 'package:u_assistant/data/database/database_provider.dart';
import 'package:u_assistant/services/clock_provider.dart';

/// Приложение с базой в памяти и фиксированными часами (TESTING_STRATEGY §6–§7).
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
}) async {
  await initializeDateFormatting('ru');
  final db = AppDatabase(NativeDatabase.memory());
  addTearDown(db.close);
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(FixedClock()),
      ],
      child: const UAssistantApp(),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}
