import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Часы приложения (ARCHITECTURE §8). В тестах переопределяются на [FixedClock].
final clockProvider = Provider<Clock>((ref) => const SystemClock());

/// Сегодняшняя локальная дата — для «Сегодня», периодов и даты новой операции.
final todayProvider = Provider<LocalDate>(
  (ref) => LocalDate.fromDateTime(ref.watch(clockProvider).now()),
);
