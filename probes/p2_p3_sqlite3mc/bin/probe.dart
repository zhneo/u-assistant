// Проба P2/P3. Запуск: dart run bin/probe.dart
// Проверяет на Windows (та же сборка sqlite3mc, что пойдёт на Android и iOS):
//  P2  — база шифруется: без ключа не открывается, заголовок файла не «SQLite format 3»;
//  P3  — FTS5 есть в сборке; поиск по кириллице без учёта регистра и «ё/е»;
//  B1  — VACUUM INTO даёт снимок; зашифрован ли он тем же ключом;
//  B2  — перешифровка копии снимка в открытый вид через PRAGMA rekey = ''.
// Пишет итог в out/result.txt. Никаких пользовательских данных — только тестовые строки.
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

final _out = StringBuffer();

void log(String s) {
  stdout.writeln(s);
  _out.writeln(s);
}

void main() {
  final dir = Directory('out')..createSync(recursive: true);
  for (final f in dir.listSync()) {
    f.deleteSync();
  }
  final mainPath = '${dir.path}/main.db';

  log('sqlite version: ${sqlite3.version}');

  // --- P2: шифрование ---
  final db = sqlite3.open(mainPath);
  db.execute("PRAGMA key = 'probe-key-1';");
  final cipher = db.select('PRAGMA cipher;');
  log('cipher: ${cipher.isEmpty ? '(нет PRAGMA cipher)' : cipher.first.values}');
  db.execute('CREATE TABLE note(id INTEGER PRIMARY KEY, title TEXT);');
  db.execute("INSERT INTO note(title) VALUES ('Позвонить преподавателю'), ('Ещё раз проверить ёлку');");
  final opts = db.select('PRAGMA compile_options;').map((r) => r.values.first.toString()).toList();
  log('FTS5 в compile_options: ${opts.any((o) => o.contains('FTS5'))}');
  log('JSON в compile_options: ${opts.any((o) => o.contains('JSON'))} (в новых SQLite JSON встроен всегда)');
  db.dispose();

  final header = File(mainPath).readAsBytesSync().take(16).toList();
  final plainHeader = 'SQLite format 3'.codeUnits;
  final looksPlain = List.generate(15, (i) => header[i] == plainHeader[i]).every((x) => x);
  log('P2 заголовок файла открытый (плохо): $looksPlain');

  try {
    final noKey = sqlite3.open(mainPath);
    noKey.select('SELECT count(*) FROM note;');
    log('P2 открылась без ключа (плохо): true');
    noKey.dispose();
  } on SqliteException catch (e) {
    log('P2 без ключа не открывается (хорошо): ${e.message}');
  }

  final withKey = sqlite3.open(mainPath)..execute("PRAGMA key = 'probe-key-1';");
  log('P2 с ключом строк: ${withKey.select('SELECT count(*) AS c FROM note;').first['c']}');

  // --- P3: FTS5 и кириллица ---
  try {
    withKey.execute("CREATE VIRTUAL TABLE s USING fts5(title, tokenize = 'unicode61 remove_diacritics 2');");
    withKey.execute('INSERT INTO s(title) SELECT title FROM note;');
    for (final q in ['преподавателю', 'ПРЕПОДАВАТЕЛЮ', 'препод*', 'еще', 'елку', 'ёлку']) {
      final n = withKey.select('SELECT count(*) AS c FROM s WHERE s MATCH ?;', [q]).first['c'];
      log('P3 MATCH "$q" -> $n');
    }
  } on SqliteException catch (e) {
    log('P3 FTS5 недоступен: ${e.message}');
  }

  // --- B1: VACUUM INTO ---
  final snapPath = '${dir.path}/snap.db';
  try {
    withKey.execute("VACUUM INTO '$snapPath';");
    final snapHeader = File(snapPath).readAsBytesSync().take(15).toList();
    final snapPlain = List.generate(15, (i) => snapHeader[i] == plainHeader[i]).every((x) => x);
    log('B1 VACUUM INTO выполнен; снимок открытый: $snapPlain');
    try {
      final s = sqlite3.open(snapPath)..execute("PRAGMA key = 'probe-key-1';");
      log('B1 снимок с тем же ключом, строк: ${s.select('SELECT count(*) AS c FROM note;').first['c']}');
      s.dispose();
    } on SqliteException catch (e) {
      log('B1 снимок с тем же ключом не открылся: ${e.message}');
    }
  } on SqliteException catch (e) {
    log('B1 VACUUM INTO ошибка: ${e.message}');
  }
  withKey.dispose();

  // --- B2: перешифровка копии снимка в открытый вид ---
  final plainPath = '${dir.path}/plain.db';
  try {
    File(snapPath).copySync(plainPath);
    final p = sqlite3.open(plainPath)..execute("PRAGMA key = 'probe-key-1';");
    p.execute("PRAGMA rekey = '';");
    p.dispose();
    final h = File(plainPath).readAsBytesSync().take(15).toList();
    final isPlain = List.generate(15, (i) => h[i] == plainHeader[i]).every((x) => x);
    final reopened = sqlite3.open(plainPath);
    final c = reopened.select('SELECT count(*) AS c FROM note;').first['c'];
    reopened.dispose();
    log('B2 rekey в открытый вид: заголовок открытый=$isPlain, строк без ключа=$c');

    // И обратно: открытая копия -> зашифровать новым ключом (как при восстановлении на новом устройстве)
    final r = sqlite3.open(plainPath)..execute("PRAGMA rekey = 'new-device-key';");
    r.dispose();
    final r2 = sqlite3.open(plainPath)..execute("PRAGMA key = 'new-device-key';");
    log('B2 повторное шифрование новым ключом, строк: ${r2.select('SELECT count(*) AS c FROM note;').first['c']}');
    r2.dispose();
  } on SqliteException catch (e) {
    log('B2 ошибка: ${e.message}');
  }

  File('${dir.path}/result.txt').writeAsStringSync(_out.toString());
}
