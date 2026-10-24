import 'package:core/core.dart';

import '../../../l10n/app_localizations.dart';

/// Подписи модуля «Деньги», общие для нескольких экранов.

String accountTypeLabel(AppLocalizations l, AccountType t) => switch (t) {
  AccountType.cash => l.accountTypeCash,
  AccountType.card => l.accountTypeCard,
  AccountType.bank => l.accountTypeBank,
  AccountType.deposit => l.accountTypeDeposit,
  AccountType.credit => l.accountTypeCredit,
  AccountType.other => l.accountTypeOther,
};

/// Группы счетов на SCR-34: наличные, карты, счета и вклады, кредиты, другое.
enum AccountGroup { cash, cards, bank, credit, other }

AccountGroup accountGroupOf(AccountType t) => switch (t) {
  AccountType.cash => AccountGroup.cash,
  AccountType.card => AccountGroup.cards,
  AccountType.bank || AccountType.deposit => AccountGroup.bank,
  AccountType.credit => AccountGroup.credit,
  AccountType.other => AccountGroup.other,
};

String accountGroupLabel(AppLocalizations l, AccountGroup g) => switch (g) {
  AccountGroup.cash => l.accountGroupCash,
  AccountGroup.cards => l.accountGroupCards,
  AccountGroup.bank => l.accountGroupBank,
  AccountGroup.credit => l.accountGroupCredit,
  AccountGroup.other => l.accountGroupOther,
};

/// Сумма операции со знаком для списков (DESIGN_SYSTEM §2.3): доход «+», расход «−»,
/// перевод без знака. [relativeTo] — счёт, с точки зрения которого показывается перевод.
String signedAmount(FinTransaction t, {EntityId? relativeTo}) {
  final abs = t.amount.abs().format();
  return switch (t.kind) {
    TransactionKind.income || TransactionKind.debtIn => '+$abs',
    TransactionKind.expense || TransactionKind.debtOut => '−$abs',
    TransactionKind.adjustment => t.amount.isNegative ? '−$abs' : '+$abs',
    TransactionKind.transferOut => relativeTo == null ? abs : '−$abs',
    TransactionKind.transferIn => relativeTo == null ? abs : '+$abs',
  };
}
