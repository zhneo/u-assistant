import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Локальная база (ARCHITECTURE §5, DATABASE.md). Файл зашифрован SQLite3MultipleCiphers.
@DriftDatabase(tables: [AppSettings], include: {'finance.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Версия схемы. Любое изменение схемы = новая версия + снимок в `drift_schemas/`
  /// + тест миграции (ARCHITECTURE §11, TESTING_STRATEGY §3.7).
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      // В SQLite внешние ключи по умолчанию выключены (DATABASE §1).
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Ключ базы — 256 бит в виде 64 шестнадцатеричных символов (DATA_SECURITY §3).
final _hexKey = RegExp(r'^[0-9a-f]{64}$');

/// Открывает зашифрованную базу. Ключ проверяется сразу: неверный ключ даёт исключение
/// при открытии, а не позже посреди работы.
AppDatabase openAppDatabase(File file, String hexKey) {
  if (!_hexKey.hasMatch(hexKey)) {
    throw ArgumentError('Ключ базы должен быть 64 hex-символа');
  }
  final executor = NativeDatabase.createInBackground(
    file,
    setup: (raw) {
      raw.execute("PRAGMA hexkey = '$hexKey';");
      // Проверка ключа: без верного ключа чтение схемы падает с «file is not a database».
      raw.select('SELECT count(*) FROM sqlite_master;');
      raw.execute('PRAGMA journal_mode = WAL;');
      raw.execute('PRAGMA busy_timeout = 5000;');
    },
  );
  return AppDatabase(executor);
}
