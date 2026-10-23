import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('ё и регистр нормализуются', () {
    expect(normalizeForSearch('Ещё раз ЁЛКА'), 'еще раз елка');
  });
}
