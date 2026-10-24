import 'package:decimal/decimal.dart';

import '../common/app_failure.dart';
import '../common/result.dart';
import '../money/money.dart';
import 'account.dart';

/// Проверенные суммы перевода (FR-FIN-07, REQUIREMENTS §6.9).
final class TransferAmounts {
  final Money debit;
  final Money credit;
  const TransferAmounts(this.debit, this.credit);

  bool get isCrossCurrency => debit.currency != credit.currency;

  /// Применённый курс «единиц валюты зачисления за 1 единицу списания» — только для показа.
  /// Выводится из двух сумм; ничего не округляется задним числом.
  Decimal? get displayRate {
    if (!isCrossCurrency) return null;
    Decimal major(Money m) =>
        (Decimal.fromInt(m.amountMinor) /
                Decimal.fromInt(m.currency.minorFactor))
            .toDecimal(scaleOnInfinitePrecision: 10);
    return (major(credit) / major(debit)).toDecimal(
      scaleOnInfinitePrecision: 6,
    );
  }
}

/// Проверка перевода:
/// - счета разные и в валюте своих сумм;
/// - суммы больше нуля;
/// - в одной валюте сумма зачисления равна сумме списания (вторая сумма не вводится);
/// - в разных валютах нужны обе суммы (AC-02).
Result<TransferAmounts> validateTransfer({
  required Account from,
  required Account to,
  required Money? debit,
  Money? credit,
}) {
  if (from.id == to.id) {
    return const Err(
      ValidationFailure('toAccount', ValidationReason.sameValue),
    );
  }
  if (debit == null) {
    return const Err(ValidationFailure('amount', ValidationReason.required));
  }
  if (debit.currency != from.currency) {
    throw ArgumentError('Сумма списания должна быть в валюте счёта-источника');
  }
  if (!debit.isPositive) {
    return const Err(
      ValidationFailure('amount', ValidationReason.mustBePositive),
    );
  }
  if (from.currency == to.currency) {
    if (credit != null && credit != debit) {
      throw ArgumentError('В одной валюте суммы списания и зачисления равны');
    }
    return Ok(TransferAmounts(debit, debit));
  }
  if (credit == null) {
    return const Err(
      ValidationFailure('creditAmount', ValidationReason.required),
    );
  }
  if (credit.currency != to.currency) {
    throw ArgumentError('Сумма зачисления должна быть в валюте получателя');
  }
  if (!credit.isPositive) {
    return const Err(
      ValidationFailure('creditAmount', ValidationReason.mustBePositive),
    );
  }
  return Ok(TransferAmounts(debit, credit));
}
