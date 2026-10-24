import 'package:core/core.dart';

/// Адреса экранов (ARCHITECTURE §4). Отдельно от построения маршрутов: экраны знают
/// адреса, но не импортируют друг друга — переходы между фичами идут по адресам.
abstract final class AppRoutes {
  static const today = '/today';
  static const tasks = '/tasks';
  static const money = '/money';
  static const notes = '/notes';
  static const onboarding = '/onboarding';

  static const accounts = '/money/accounts';
  static String account(EntityId id) => '/money/accounts/${id.value}';
  static String operation(EntityId id) => '/money/operations/${id.value}';

  /// Полноэкранные формы поверх нижней панели; «Назад» закрывает их.
  static String newOperation(TransactionKind kind, {EntityId? from}) =>
      '/new/${kind.dbValue}${from == null ? '' : '?from=${from.value}'}';
  static String editOperation(EntityId id) => '/edit/operation/${id.value}';
  static const newAccount = '/new/account';
  static String editAccount(EntityId id) => '/edit/account/${id.value}';
}
