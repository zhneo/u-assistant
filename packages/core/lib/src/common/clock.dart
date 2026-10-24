/// Источник текущего времени (ARCHITECTURE §8).
///
/// Код никогда не вызывает `DateTime.now()` напрямую — только через [Clock].
/// В тестах подставляется [FixedClock], и относительные даты («завтра») не «плывут».
abstract interface class Clock {
  DateTime now();
}

final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Часы для тестов. По умолчанию — пятница, 23.10.2026, 14:00 (TESTING_STRATEGY §6).
final class FixedClock implements Clock {
  DateTime _now;
  FixedClock([DateTime? now]) : _now = now ?? DateTime(2026, 10, 23, 14);

  @override
  DateTime now() => _now;

  void advance(Duration d) => _now = _now.add(d);

  void set(DateTime value) => _now = value;
}
