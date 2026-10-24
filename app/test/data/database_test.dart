import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:u_assistant/data/database/app_database.dart';
import 'package:u_assistant/data/database/database_key.dart';
import 'package:u_assistant/platform/secure_key_store.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('ua_db_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  const key1 =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
  const key2 =
      'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

  test('файл базы зашифрован: заголовок не «SQLite format 3», данные читаются с ключом (D-044)', () async {
    final file = File('${dir.path}/t.db');
    final db = openAppDatabase(file, key1);
    await db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(key: 'k', value: '"v"', updatedAt: 1),
        );
    await db.close();

    final header = String.fromCharCodes(file.readAsBytesSync().take(15));
    expect(header, isNot('SQLite format 3'));

    final again = openAppDatabase(file, key1);
    final rows = await again.select(again.appSettings).get();
    expect(rows.single.key, 'k');
    await again.close();
  });

  test('с неверным ключом база не открывается', () async {
    final file = File('${dir.path}/t.db');
    final db = openAppDatabase(file, key1);
    await db.customSelect('SELECT 1').get();
    await db.close();

    final wrong = openAppDatabase(file, key2);
    await expectLater(wrong.customSelect('SELECT 1').get(), throwsA(anything));
    await wrong.close();
  });

  test('внешние ключи включены, версия схемы 1', () async {
    final db = openAppDatabase(File('${dir.path}/t.db'), key1);
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.data.values.first, 1);
    expect(db.schemaVersion, 1);
    await db.close();
  });

  test(
    'ключ: генерируется один раз (64 hex) и затем переиспользуется',
    () async {
      final store = InMemoryKeyStore();
      final k1 = await obtainDatabaseKey(store, random: Random(1));
      final k2 = await obtainDatabaseKey(store, random: Random(2));
      expect(k1, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(k2, k1);
    },
  );

  test('ключ неверного формата отклоняется до открытия', () {
    expect(
      () => openAppDatabase(File('${dir.path}/t.db'), 'short'),
      throwsArgumentError,
    );
  });
}
