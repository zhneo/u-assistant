import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Настройки, которые читают несколько фич (ARCHITECTURE §1.3: общее — в `services`).

/// Базовая валюта; null — онбординг ещё не дошёл до выбора валюты.
final baseCurrencyProvider = StreamProvider<Currency?>(
  (ref) => ref.watch(settingsRepositoryProvider).watchBaseCurrency(),
);
