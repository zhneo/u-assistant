// Проба P6. Запуск: dart run bin/probe.dart  (лучше: dart compile exe bin/probe.dart && bin\probe.exe —
// на телефоне код будет скомпилирован AOT, а `dart run` работает в JIT и медленнее).
// Цель BACKUP_AND_RESTORE §8: вывод ключа 0,5–1,5 с на слабом Android. Здесь — базовая точка на ПК.
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final rnd = Random.secure();
  final salt = List<int>.generate(16, (_) => rnd.nextInt(256));
  final password = SecretKey('correct horse battery staple'.codeUnits);

  for (final (mem, it) in [(19456, 2), (32768, 3), (65536, 3)]) {
    final kdf = Argon2id(memory: mem, iterations: it, parallelism: 1, hashLength: 32);
    final sw = Stopwatch()..start();
    await kdf.deriveKey(secretKey: password, nonce: salt);
    sw.stop();
    print('Argon2id memory=${mem ~/ 1024} МиБ iterations=$it: ${sw.elapsedMilliseconds} мс');
  }

  final pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 600000, bits: 256);
  final sw2 = Stopwatch()..start();
  await pbkdf2.deriveKey(secretKey: password, nonce: salt);
  sw2.stop();
  print('PBKDF2-SHA256 600 000 итераций: ${sw2.elapsedMilliseconds} мс');

  final aes = AesGcm.with256bits();
  final key = await aes.newSecretKey();
  final data = Uint8List(20 * 1024 * 1024); // 20 МБ — порядок размера базы за 3 года (DATABASE §11)
  final sw3 = Stopwatch()..start();
  final box = await aes.encrypt(data, secretKey: key);
  final enc = sw3.elapsedMilliseconds;
  await aes.decrypt(box, secretKey: key);
  sw3.stop();
  print('AES-256-GCM 20 МБ: шифрование $enc мс, шифрование+расшифровка ${sw3.elapsedMilliseconds} мс');
}
