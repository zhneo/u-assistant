import 'dart:math';

import '../../platform/secure_key_store.dart';

const _keyName = 'db_key_v1';

/// Ключ базы: читается из защищённого хранилища, при первом запуске генерируется
/// криптостойким генератором и сохраняется (DATA_SECURITY §3).
Future<String> obtainDatabaseKey(SecureKeyStore store, {Random? random}) async {
  final existing = await store.read(_keyName);
  if (existing != null) return existing;
  final rnd = random ?? Random.secure();
  final key = List.generate(
    32,
    (_) => rnd.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
  await store.write(_keyName, key);
  return key;
}
