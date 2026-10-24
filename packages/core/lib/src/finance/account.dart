import '../common/app_failure.dart';
import '../common/entity_id.dart';
import '../common/result.dart';
import '../money/currency.dart';
import '../money/money.dart';

/// Тип счёта (FR-FIN-01, DATABASE §4.2). [dbValue] — значение в базе и `CHECK`.
enum AccountType {
  cash('cash'),
  card('card'),
  bank('bank'),
  deposit('deposit'),
  credit('credit'),
  other('other');

  final String dbValue;
  const AccountType(this.dbValue);

  static AccountType fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'AccountType'),
  );

  /// Ключ иконки счёта по умолчанию (набор иконок — в приложении).
  String get defaultIcon => switch (this) {
    cash => 'cash',
    card => 'card',
    bank => 'bank',
    deposit => 'savings',
    credit => 'credit',
    other => 'wallet',
  };
}

/// «В бюджете» или «только отслеживать» (R1, REQUIREMENTS §6.4).
enum BudgetMode {
  onBudget('on_budget'),
  tracking('tracking');

  final String dbValue;
  const BudgetMode(this.dbValue);

  static BudgetMode fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'BudgetMode'),
  );
}

/// Счёт (FR-FIN-01). Валюта неизменна, если у счёта есть операции (FR-FIN-03).
final class Account {
  static const maxNameLength = 60;

  final EntityId id;
  final String name;
  final AccountType type;
  final Currency currency;

  /// Начальный баланс в валюте счёта; у кредита может быть отрицательным.
  final Money openingBalance;
  final BudgetMode budgetMode;

  /// Скрыть из общего баланса (§6.3).
  final bool hidden;
  final DateTime? archivedAt;
  final int colorIndex;
  final String icon;
  final int sortOrder;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.openingBalance,
    this.budgetMode = BudgetMode.onBudget,
    this.hidden = false,
    this.archivedAt,
    this.colorIndex = 3,
    this.icon = 'wallet',
    this.sortOrder = 0,
  }) {
    if (openingBalance.currency != currency) {
      throw ArgumentError('Начальный баланс должен быть в валюте счёта');
    }
  }

  bool get isArchived => archivedAt != null;

  /// Проверка названия: 1–60 символов после обрезки пробелов.
  static Result<String> validateName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) {
      return const Err(ValidationFailure('name', ValidationReason.required));
    }
    if (name.length > maxNameLength) {
      return const Err(ValidationFailure('name', ValidationReason.tooLong));
    }
    return Ok(name);
  }

  Account copyWith({
    String? name,
    AccountType? type,
    Money? openingBalance,
    BudgetMode? budgetMode,
    bool? hidden,
    DateTime? archivedAt,
    bool clearArchived = false,
    int? colorIndex,
    String? icon,
    int? sortOrder,
  }) => Account(
    id: id,
    name: name ?? this.name,
    type: type ?? this.type,
    currency: currency,
    openingBalance: openingBalance ?? this.openingBalance,
    budgetMode: budgetMode ?? this.budgetMode,
    hidden: hidden ?? this.hidden,
    archivedAt: clearArchived ? null : archivedAt ?? this.archivedAt,
    colorIndex: colorIndex ?? this.colorIndex,
    icon: icon ?? this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.currency == currency &&
      other.openingBalance == openingBalance &&
      other.budgetMode == budgetMode &&
      other.hidden == hidden &&
      other.archivedAt == archivedAt &&
      other.colorIndex == colorIndex &&
      other.icon == icon &&
      other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    currency,
    openingBalance,
    budgetMode,
    hidden,
    archivedAt,
    colorIndex,
    icon,
    sortOrder,
  );

  // Название — пользовательские данные, в toString не попадает (DATA_SECURITY §7).
  @override
  String toString() => 'Account($id, ${type.dbValue}, $currency)';
}

/// Счёт с текущим балансом — для списков и обзора.
final class AccountWithBalance {
  final Account account;
  final Money balance;
  const AccountWithBalance(this.account, this.balance);

  @override
  bool operator ==(Object other) =>
      other is AccountWithBalance &&
      other.account == account &&
      other.balance == balance;

  @override
  int get hashCode => Object.hash(account, balance);
}
