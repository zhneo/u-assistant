import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:u_assistant/services/logging/app_logging.dart';

void main() {
  test('в журнал попадает тип ошибки, а не её текст с пользовательскими данными (AC-24)', () {
    final secret = Exception('Расход 3 500 ₸ «Продукты», заметка про диплом');
    final line = formatLogRecord(
      LogRecord(Level.SEVERE, 'transaction.save failed', 'money', secret),
    );
    expect(line, contains('transaction.save failed'));
    expect(line, contains('error=_Exception'));
    expect(line, isNot(contains('3 500')));
    expect(line, isNot(contains('Продукты')));
    expect(line, isNot(contains('диплом')));
  });

  test('ротация: не больше двух файлов', () {
    final dir = Directory.systemTemp.createTempSync('ua_log_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final sink = RotatingFileLogSink(
      File('${dir.path}/app.log'),
      maxBytes: 200,
    );
    for (var i = 0; i < 50; i++) {
      sink.write('line $i ${'x' * 20}');
    }
    final files = dir
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .toSet();
    expect(files, {'app.log', 'app.log.1'});
    expect(File('${dir.path}/app.log').lengthSync(), lessThanOrEqualTo(200));
  });
}
