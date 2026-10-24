import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Часы приложения (ARCHITECTURE §8). В тестах переопределяются на [FixedClock].
final clockProvider = Provider<Clock>((ref) => const SystemClock());
