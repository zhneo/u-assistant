import 'dart:io';

import 'package:core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Те же проверки, что в probes/p2_p3_sqlite3mc, но на устройстве.
Future<Map<String, Object?>> runProbe() async {
  final dir = await getApplicationSupportDirectory();
  final path = '${dir.path}/probe.db';
  final f = File(path);
  if (f.existsSync()) f.deleteSync();

  final db = sqlite3.open(path)..execute("PRAGMA key = 'probe-key-1';");
  final cipher = db.select('PRAGMA cipher;').first.values.first;
  db.execute("CREATE VIRTUAL TABLE s USING fts5(title, tokenize = 'unicode61 remove_diacritics 2');");
  db.execute('INSERT INTO s(title) VALUES (?);', [normalizeForSearch('Ещё раз проверить ёлку')]);
  final hit = db.select('SELECT count(*) AS c FROM s WHERE s MATCH ?;', [normalizeForSearch('ЕЛКУ')]).first['c'];
  db.close();

  final header = String.fromCharCodes(f.readAsBytesSync().take(15));
  var openedWithoutKey = true;
  try {
    sqlite3.open(path).select('SELECT count(*) FROM s;');
  } on SqliteException {
    openedWithoutKey = false;
  }

  return {
    'platform': Platform.operatingSystem,
    'sqlite': sqlite3.version.libVersion,
    'cipher': cipher,
    'headerPlain': header == 'SQLite format 3',
    'openedWithoutKey': openedWithoutKey,
    'ftsHit': hit,
  };
}
