/// Ядро U-Assistant: чистый Dart, без Flutter (ARCHITECTURE §1).
library;

export 'package:decimal/decimal.dart' show Decimal;

export 'src/common/app_failure.dart';
export 'src/common/clock.dart';
export 'src/common/entity_id.dart';
export 'src/common/local_date.dart';
export 'src/common/result.dart';
export 'src/common/search_text.dart';
export 'src/common/settings_repository.dart';
export 'src/common/unit_of_work.dart';
export 'src/finance/account.dart';
export 'src/finance/calculations.dart';
export 'src/finance/category.dart';
export 'src/finance/repositories.dart';
export 'src/finance/transaction.dart';
export 'src/finance/transfer.dart';
export 'src/money/currency.dart';
export 'src/money/exchange_rate.dart';
export 'src/money/money.dart';
