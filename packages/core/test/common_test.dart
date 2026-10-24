import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('Result: fold и value', () {
    const ok = Ok<int>(5);
    const err = Err<int>(MissingRateFailure('USD'));
    expect(ok.fold((v) => v * 2, (_) => -1), 10);
    expect(err.fold((v) => v, (f) => f.toString()), 'MissingRateFailure(USD)');
    expect(() => err.value, throwsStateError);
  });

  test('EntityId: UUID v7, уникальный, проверка формата', () {
    final a = EntityId.generate();
    final b = EntityId.generate();
    expect(a.value.length, 36);
    expect(a == b, isFalse);
    expect(EntityId.isValid(a.value), isTrue);
    expect(EntityId.isValid('not-a-uuid'), isFalse);
  });

  test('FixedClock: по умолчанию пятница 23.10.2026 14:00, можно сдвигать', () {
    final c = FixedClock();
    expect(c.now(), DateTime(2026, 10, 23, 14));
    expect(c.now().weekday, DateTime.friday);
    c.advance(const Duration(days: 1));
    expect(c.now().day, 24);
  });

  test('normalizeForSearch: ё → е и нижний регистр (D-043)', () {
    expect(normalizeForSearch('Ещё раз ЁЛКА'), 'еще раз елка');
  });

  test('toString ошибок не содержит пользовательских данных', () {
    expect(
      const ValidationFailure('amount', ValidationReason.required).toString(),
      'ValidationFailure(amount, required)',
    );
  });
}
