import 'package:decimal/decimal.dart';

import '../common/app_failure.dart';
import '../common/entity_id.dart';
import '../common/local_date.dart';
import '../common/result.dart';
import '../money/money.dart';
import 'account.dart';

/// Тип операции (DATABASE §4.5).
enum TransactionKind {
  expense('expense'),
  income('income'),
  transferOut('transfer_out'),
  transferIn('transfer_in'),
  adjustment('adjustment'),
  debtOut('debt_out'),
  debtIn('debt_in');

  final String dbValue;
  const TransactionKind(this.dbValue);

  static TransactionKind fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'TransactionKind'),
  );

  bool get isTransfer => this == transferOut || this == transferIn;

  /// Знак влияния на баланс счёта (§6.2). У корректировки знак хранится в самой сумме.
  int get balanceSign => switch (this) {
    income || transferIn || debtIn || adjustment => 1,
    expense || transferOut || debtOut => -1,
  };
}

enum TransactionStatus {
  posted('posted'),
  planned('planned');

  final String dbValue;
  const TransactionStatus(this.dbValue);

  static TransactionStatus fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'TransactionStatus'),
  );
}

/// Как операция входит в отчёты доходов и расходов (DATABASE §5.2).
enum ReportEffect {
  expense('expense'),
  income('income'),
  none('none');

  final String dbValue;
  const ReportEffect(this.dbValue);

  static ReportEffect fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'ReportEffect'),
  );
}

/// `report_effect` для операций, кроме переводов.
ReportEffect reportEffectOf(TransactionKind kind) => switch (kind) {
  TransactionKind.expense => ReportEffect.expense,
  TransactionKind.income => ReportEffect.income,
  TransactionKind.adjustment ||
  TransactionKind.debtOut ||
  TransactionKind.debtIn => ReportEffect.none,
  TransactionKind.transferOut || TransactionKind.transferIn =>
    throw ArgumentError('Для перевода используйте transferEffects'),
};

/// `report_effect` двух частей перевода (DATABASE §5.2, REQUIREMENTS §6.4, R1):
/// - оба счёта в одном режиме → перевод не доход и не расход;
/// - «в бюджете» → «только отслеживать» → расход (категория обязательна);
/// - «только отслеживать» → «в бюджете» → доход (категория обязательна).
({ReportEffect out, ReportEffect into}) transferEffects(
  BudgetMode from,
  BudgetMode to,
) {
  if (from == to) return (out: ReportEffect.none, into: ReportEffect.none);
  if (from == BudgetMode.onBudget) {
    return (out: ReportEffect.expense, into: ReportEffect.none);
  }
  return (out: ReportEffect.none, into: ReportEffect.income);
}

/// Финансовая операция — строка `fin_transaction` (DATABASE §4.5).
final class FinTransaction {
  static const maxNoteLength = 500;

  final EntityId id;
  final TransactionKind kind;
  final TransactionStatus status;
  final EntityId accountId;
  final EntityId? categoryId;

  /// Сумма в валюте счёта; ≥ 0, кроме корректировки (§6.1).
  final Money amount;

  /// Курс к базовой, применённый при вводе; null — валюта базовая или курса не было.
  final Decimal? rateToBase;

  /// Сумма в базовой валюте, зафиксированная при записи (I8); null — курса не было.
  final Money? amountBase;
  final ReportEffect reportEffect;
  final bool isRefund;
  final LocalDate date;

  /// Время `HH:MM` — необязательно.
  final String? time;
  final String? note;
  final EntityId? transferGroupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  FinTransaction({
    required this.id,
    required this.kind,
    required this.accountId,
    required this.amount,
    required this.reportEffect,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.status = TransactionStatus.posted,
    this.categoryId,
    this.rateToBase,
    this.amountBase,
    this.isRefund = false,
    this.time,
    this.note,
    this.transferGroupId,
    this.deletedAt,
  }) {
    if (kind != TransactionKind.adjustment && amount.isNegative) {
      throw ArgumentError('Сумма операции не может быть отрицательной');
    }
    if ((kind == TransactionKind.expense || kind == TransactionKind.income) &&
        categoryId == null) {
      throw ArgumentError('У дохода и расхода категория обязательна');
    }
    if (kind.isTransfer && transferGroupId == null) {
      throw ArgumentError('У части перевода должен быть transferGroupId');
    }
  }

  /// Вклад в баланс счёта со знаком (§6.2).
  Money get signedAmount => kind.balanceSign > 0
      ? amount
      : Money(-amount.amountMinor, amount.currency);

  bool get isDeleted => deletedAt != null;

  /// Комментарий: обрезка пробелов, пустой → null, не длиннее 500.
  static Result<String?> validateNote(String? raw) {
    final note = raw?.trim();
    if (note == null || note.isEmpty) return const Ok(null);
    if (note.length > maxNoteLength) {
      return const Err(ValidationFailure('note', ValidationReason.tooLong));
    }
    return Ok(note);
  }

  FinTransaction copyWith({
    EntityId? accountId,
    EntityId? categoryId,
    Money? amount,
    Decimal? rateToBase,
    Money? amountBase,
    bool clearBase = false,
    ReportEffect? reportEffect,
    LocalDate? date,
    String? time,
    String? note,
    bool clearNote = false,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) => FinTransaction(
    id: id,
    kind: kind,
    status: status,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    rateToBase: clearBase ? null : rateToBase ?? this.rateToBase,
    amountBase: clearBase ? null : amountBase ?? this.amountBase,
    reportEffect: reportEffect ?? this.reportEffect,
    isRefund: isRefund,
    date: date ?? this.date,
    time: time ?? this.time,
    note: clearNote ? null : note ?? this.note,
    transferGroupId: transferGroupId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is FinTransaction &&
      other.id == id &&
      other.kind == kind &&
      other.status == status &&
      other.accountId == accountId &&
      other.categoryId == categoryId &&
      other.amount == amount &&
      other.rateToBase == rateToBase &&
      other.amountBase == amountBase &&
      other.reportEffect == reportEffect &&
      other.isRefund == isRefund &&
      other.date == date &&
      other.time == time &&
      other.note == note &&
      other.transferGroupId == transferGroupId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;

  @override
  int get hashCode => Object.hashAll([
    id,
    kind,
    status,
    accountId,
    categoryId,
    amount,
    rateToBase,
    amountBase,
    reportEffect,
    isRefund,
    date,
    time,
    note,
    transferGroupId,
    createdAt,
    updatedAt,
    deletedAt,
  ]);

  // Сумма и комментарий — пользовательские данные, в toString не попадают.
  @override
  String toString() => 'FinTransaction($id, ${kind.dbValue}, $date)';
}
