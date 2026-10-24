// Проверка архитектурных правил (ARCHITECTURE §1.3, DATA_SECURITY §8).
// Запуск из корня репозитория: dart run tool/check_architecture.dart
// Выход с кодом 1, если найдено нарушение — CI падает.
import 'dart:io';

final _violations = <String>[];

void main() {
  _checkCoreIsPureDart();
  _checkPresentationLayer();
  _checkFeatureIsolation();
  _checkAndroidPermissions();

  if (_violations.isEmpty) {
    stdout.writeln('Архитектурные правила: нарушений нет.');
    return;
  }
  stderr.writeln('Нарушения архитектурных правил (${_violations.length}):');
  for (final v in _violations) {
    stderr.writeln('  - $v');
  }
  exit(1);
}

Iterable<File> _dartFiles(String dir) => Directory(dir).existsSync()
    ? Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
    : const <File>[];

Iterable<(int, String)> _imports(File f) sync* {
  final lines = f.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final l = lines[i].trim();
    if (l.startsWith('import ') || l.startsWith('export ')) yield (i + 1, l);
  }
}

String _rel(File f) => f.path.replaceAll(r'\', '/');

/// Правило 1: ядро — чистый Dart, без Flutter и без кода приложения.
void _checkCoreIsPureDart() {
  const forbidden = [
    'package:flutter/',
    'package:material_ui',
    'package:cupertino_ui',
    'dart:ui',
    'package:u_assistant',
  ];
  for (final f in _dartFiles('packages/core/lib')) {
    for (final (line, imp) in _imports(f)) {
      if (forbidden.any(imp.contains)) {
        _violations.add(
          '${_rel(f)}:$line — ядро импортирует Flutter/приложение: $imp',
        );
      }
    }
  }
}

/// Правило 2: экраны не обращаются к базе и платформе напрямую.
void _checkPresentationLayer() {
  for (final f in _dartFiles('app/lib/features')) {
    if (!_rel(f).contains('/presentation/')) continue;
    for (final (line, imp) in _imports(f)) {
      if (RegExp(r'''['"].*/(data|platform)/''').hasMatch(imp)) {
        _violations.add(
          '${_rel(f)}:$line — экран импортирует data/platform напрямую: $imp',
        );
      }
    }
  }
}

/// Правило 3: фича не импортирует внутренности другой фичи.
void _checkFeatureIsolation() {
  for (final f in _dartFiles('app/lib/features')) {
    final own = RegExp(r'features/([^/]+)/').firstMatch(_rel(f))?.group(1);
    for (final (line, imp) in _imports(f)) {
      final other = RegExp(r'features/([^/]+)/').firstMatch(imp)?.group(1);
      if (other != null && other != own) {
        _violations.add(
          '${_rel(f)}:$line — фича «$own» импортирует фичу «$other»: $imp',
        );
      }
    }
  }
}

/// Приложение не запрашивает разрешений сверх списка DATA_SECURITY §9; INTERNET — запрещён.
void _checkAndroidPermissions() {
  const allowed = {
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.SCHEDULE_EXACT_ALARM',
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'android.permission.RECORD_AUDIO',
    'android.permission.READ_CALENDAR',
    'android.permission.USE_BIOMETRIC',
    'android.permission.VIBRATE',
  };
  final manifest = File('app/android/app/src/main/AndroidManifest.xml');
  if (!manifest.existsSync()) return;
  final perms = RegExp(r'uses-permission[^>]*android:name="([^"]+)"')
      .allMatches(manifest.readAsStringSync())
      .map((m) => m.group(1)!);
  for (final p in perms) {
    if (!allowed.contains(p)) {
      _violations.add(
        'AndroidManifest.xml — разрешение вне списка DATA_SECURITY §9: $p',
      );
    }
  }
}
