import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:probe_app/probe.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('P1/P2 на устройстве: core из workspace + шифрованная SQLite с FTS5', (tester) async {
    final r = await runProbe();
    // ignore: avoid_print
    print('PROBE_RESULT $r');
    expect(r['cipher'], 'chacha20');
    expect(r['headerPlain'], isFalse);
    expect(r['openedWithoutKey'], isFalse);
    expect(r['ftsHit'], 1);
  });
}
