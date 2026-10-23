// Пробы на устройстве: P4 (уведомления), P5 (распознавание речи), P6 (скорость шифрования).
// Временный код этапа 7 — не образец для приложения.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

typedef Log = void Function(String line);

// ---------- P4: уведомления ----------

final _notifications = FlutterLocalNotificationsPlugin();
var _notificationsReady = false;

const _details = NotificationDetails(
  android: AndroidNotificationDetails('probe', 'Проба уведомлений', importance: Importance.high, priority: Priority.high),
  iOS: DarwinNotificationDetails(),
);

Future<void> initNotifications(Log log) async {
  if (_notificationsReady) return;
  tzdata.initializeTimeZones();
  await _notifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
  );
  _notificationsReady = true;
  log('P4 плагин уведомлений инициализирован');
}

Future<void> requestNotificationPermission(Log log) async {
  await initNotifications(log);
  if (Platform.isIOS) {
    final ok = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    log('P4 iOS разрешение на уведомления: $ok');
  } else {
    final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    log('P4 Android разрешение на уведомления: ${await android?.requestNotificationsPermission()}');
    log('P4 Android точные будильники до запроса: ${await android?.canScheduleExactNotifications()}');
    await android?.requestExactAlarmsPermission();
    log('P4 Android точные будильники после запроса: ${await android?.canScheduleExactNotifications()}');
  }
}

Future<void> scheduleIn(Duration delay, Log log) async {
  await initNotifications(log);
  var mode = AndroidScheduleMode.exactAllowWhileIdle;
  if (Platform.isAndroid) {
    final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (await android?.canScheduleExactNotifications() != true) {
      mode = AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }
  final at = tz.TZDateTime.now(tz.UTC).add(delay);
  await _notifications.zonedSchedule(
    id: 1,
    scheduledDate: at,
    notificationDetails: _details,
    androidScheduleMode: mode,
    title: 'U-Assistant: проба P4',
    body: 'Запланировано на ${at.toLocal().toIso8601String().substring(11, 19)}',
  );
  log('P4 запланировано через ${delay.inSeconds} с (режим $mode) на ${at.toLocal()}');
}

/// Проверка лимита iOS: в очереди остаются только 64 уведомления.
Future<void> checkPendingLimit(Log log) async {
  await initNotifications(log);
  final base = tz.TZDateTime.now(tz.UTC).add(const Duration(days: 2));
  for (var i = 0; i < 70; i++) {
    await _notifications.zonedSchedule(
      id: 100 + i,
      scheduledDate: base.add(Duration(minutes: i)),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: 'Лимит $i',
    );
  }
  final pending = await _notifications.pendingNotificationRequests();
  log('P4 запланировано 70, в очереди ОС: ${pending.length}');
  for (var i = 0; i < 70; i++) {
    await _notifications.cancel(id: 100 + i);
  }
  log('P4 тестовые 70 отменены, в очереди: ${(await _notifications.pendingNotificationRequests()).length}');
}

// ---------- P5: распознавание речи ----------

final _speech = SpeechToText();
var _speechReady = false;
String? _ruLocale;

Future<void> initSpeech(Log log) async {
  if (_speechReady) return;
  _speechReady = await _speech.initialize(
    onError: (SpeechRecognitionError e) => log('P5 ошибка: ${e.errorMsg} (постоянная: ${e.permanent})'),
    onStatus: (s) => log('P5 статус: $s'),
  );
  log('P5 распознавание доступно: $_speechReady');
  if (!_speechReady) return;
  final locales = await _speech.locales();
  final ids = locales.map((l) => l.localeId).toList();
  _ruLocale = ids.firstWhere((id) => id.toLowerCase().startsWith('ru'), orElse: () => '');
  final kk = ids.where((id) => id.toLowerCase().startsWith('kk')).toList();
  log('P5 локалей: ${ids.length}; русская: ${_ruLocale!.isEmpty ? 'нет' : _ruLocale}; казахская: ${kk.isEmpty ? 'нет' : kk.join(', ')}');
}

Future<void> listen({required bool onDevice, required Log log, required void Function(String) onText}) async {
  await initSpeech(log);
  if (!_speechReady || (_ruLocale ?? '').isEmpty) {
    log('P5 русская локаль недоступна — проверка невозможна');
    return;
  }
  log('P5 слушаю (только на устройстве: $onDevice). Скажите фразу из корпуса и нажмите «Стоп».');
  final sw = Stopwatch()..start();
  await _speech.listen(
    onResult: (r) {
      onText(r.recognizedWords);
      if (r.finalResult) {
        log('P5 итог за ${sw.elapsedMilliseconds} мс: «${r.recognizedWords}»');
      }
    },
    listenOptions: SpeechListenOptions(
      localeId: _ruLocale,
      onDevice: onDevice,
      partialResults: true,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      autoPunctuation: true,
    ),
  );
}

Future<void> stopListening() => _speech.stop();

// ---------- P6: скорость шифрования на устройстве ----------

// Нативное ускорение (cryptography_flutter) подключается автоматически: пакет есть в зависимостях.
Future<void> measureCrypto(Log log) async {
  final rnd = Random.secure();
  final salt = List<int>.generate(16, (_) => rnd.nextInt(256));
  final password = SecretKey('correct horse battery staple'.codeUnits);
  for (final (mem, it) in [(32768, 3), (65536, 3)]) {
    final sw = Stopwatch()..start();
    await Argon2id(memory: mem, iterations: it, parallelism: 1, hashLength: 32)
        .deriveKey(secretKey: password, nonce: salt);
    log('P6 Argon2id ${mem ~/ 1024} МиБ × $it: ${sw.elapsedMilliseconds} мс');
  }
  final aes = AesGcm.with256bits();
  final key = await aes.newSecretKey();
  final data = Uint8List(20 * 1024 * 1024);
  final sw = Stopwatch()..start();
  final box = await aes.encrypt(data, secretKey: key);
  final enc = sw.elapsedMilliseconds;
  await aes.decrypt(box, secretKey: key);
  log('P6 AES-256-GCM 20 МБ (${aes.runtimeType}): шифрование $enc мс, туда-обратно ${sw.elapsedMilliseconds} мс');
}
