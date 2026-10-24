import 'dart:io';

import 'package:logging/logging.dart';

/// Технический журнал (ARCHITECTURE §10, DATA_SECURITY §7, FR-HIS-04).
///
/// Правило для всего кода: в сообщения логов не попадают тексты, суммы, названия,
/// контрагенты и распознанная речь — только типы событий и ID. Поэтому из ошибок
/// записывается только их тип (`runtimeType`), а не текст: текст исключения может
/// содержать пользовательские данные.
class RotatingFileLogSink {
  final File file;
  final int maxBytes;

  RotatingFileLogSink(this.file, {this.maxBytes = 512 * 1024}) {
    file.parent.createSync(recursive: true);
  }

  File get _previous => File('${file.path}.1');

  /// Журнал ограничен двумя файлами по [maxBytes] (≤ 1 МБ вместе).
  void write(String line) {
    if (file.existsSync() && file.lengthSync() + line.length > maxBytes) {
      if (_previous.existsSync()) _previous.deleteSync();
      file.renameSync(_previous.path);
    }
    file.writeAsStringSync('$line\n', mode: FileMode.append, flush: false);
  }
}

/// Форматирует запись без пользовательских данных.
String formatLogRecord(LogRecord r) {
  final b = StringBuffer()
    ..write(r.time.toUtc().toIso8601String())
    ..write(' ')
    ..write(r.level.name)
    ..write(' ')
    ..write(r.loggerName)
    ..write(': ')
    ..write(r.message);
  if (r.error != null) {
    b.write(' error=${r.error is Type ? r.error : r.error.runtimeType}');
  }
  if (r.stackTrace != null) {
    final top = r.stackTrace.toString().split('\n').take(6).join(' | ');
    b.write(' stack=$top');
  }
  return b.toString();
}

/// Подключает журнал к файлу. В отладочной сборке записи дублируются в консоль.
void setupLogging(Directory dir, {bool echoToConsole = false}) {
  final sink = RotatingFileLogSink(File('${dir.path}/app.log'));
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) {
    final line = formatLogRecord(r);
    sink.write(line);
    if (echoToConsole) stdout.writeln(line);
  });
}
