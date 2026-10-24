import 'package:core/core.dart';

import 'app_localizations.dart';

/// Текст ожидаемой ошибки для пользователя — в одном месте (ARCHITECTURE §9).
/// Правило USER_FLOWS P8: что случилось и что сделать; данные в форме сохраняются.
String failureMessage(AppLocalizations l, AppFailure f) => switch (f) {
  ValidationFailure(field: 'amount') => l.amountInvalid,
  ValidationFailure(field: 'creditAmount') => l.creditRequired,
  ValidationFailure(field: 'toAccount') => l.chooseDifferentAccounts,
  ValidationFailure(field: 'category') => l.categoryRequired,
  ValidationFailure(field: 'rate') => l.rateInvalid,
  ValidationFailure(field: 'name', reason: ValidationReason.tooLong) =>
    l.nameTooLong,
  ValidationFailure(field: 'name') => l.nameRequired,
  ConflictFailure(reason: ConflictReason.currencyLocked) =>
    l.accountCurrencyLocked,
  ConflictFailure(reason: ConflictReason.hasDependents) => l.budgetModeLocked,
  NotFoundFailure() => l.notFound,
  _ => l.saveFailed,
};
