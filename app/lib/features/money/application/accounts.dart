import 'package:core/core.dart';

import 'finance_setup.dart';

/// Данные счёта из формы (SCR-35, FR-FIN-01).
final class AccountInput {
  final String name;
  final AccountType type;
  final Currency currency;
  final Money? openingBalance;
  final BudgetMode budgetMode;
  final bool hidden;
  final int colorIndex;

  const AccountInput({
    required this.name,
    required this.type,
    required this.currency,
    this.openingBalance,
    this.budgetMode = BudgetMode.onBudget,
    this.hidden = false,
    this.colorIndex = 3,
  });
}

/// Создать или изменить счёт. Валюту счёта с операциями менять нельзя (FR-FIN-03).
final class SaveAccount {
  final UnitOfWork _uow;
  final AccountRepository _accounts;
  SaveAccount(this._uow, this._accounts);

  Future<Result<Account>> call(
    AccountInput input, {
    EntityId? existingId,
  }) async {
    final name = Account.validateName(input.name);
    if (name case Err(:final failure)) return Err(failure);
    final opening = input.openingBalance ?? Money.zero(input.currency);
    if (opening.currency != input.currency) {
      throw ArgumentError('Начальный баланс — в валюте счёта');
    }

    return _uow.run(() async {
      final Account account;
      if (existingId == null) {
        final all = await _accounts.all();
        account = Account(
          id: EntityId.generate(),
          name: name.value,
          type: input.type,
          currency: input.currency,
          openingBalance: opening,
          budgetMode: input.budgetMode,
          hidden: input.hidden,
          colorIndex: input.colorIndex,
          icon: accountIconFor(input.type),
          sortOrder: all.isEmpty
              ? 0
              : all.map((a) => a.sortOrder).reduce((a, b) => a > b ? a : b) + 1,
        );
      } else {
        final old = await _accounts.get(existingId);
        if (old == null) return const Err(NotFoundFailure('account'));
        if (old.currency != input.currency &&
            await _accounts.hasTransactions(old.id)) {
          return const Err(ConflictFailure(ConflictReason.currencyLocked));
        }
        // Смена режима бюджета влияет на report_effect переводов (§5.2) —
        // пересчёт появится вместе с редактированием режима в SCR-35.
        account = Account(
          id: old.id,
          name: name.value,
          type: input.type,
          currency: input.currency,
          openingBalance: opening,
          budgetMode: old.budgetMode,
          hidden: input.hidden,
          archivedAt: old.archivedAt,
          colorIndex: input.colorIndex,
          icon: accountIconFor(input.type),
          sortOrder: old.sortOrder,
        );
      }
      await _accounts.save(account);
      return Ok(account);
    });
  }
}

/// Корректировка баланса (FR-FIN-02): пользователь вводит фактический остаток,
/// разница записывается операцией-корректировкой — не доход и не расход.
final class AdjustBalance {
  final UnitOfWork _uow;
  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final Clock _clock;
  AdjustBalance(this._uow, this._accounts, this._transactions, this._clock);

  /// Возвращает null, если остаток уже совпадает и корректировка не нужна.
  Future<Result<FinTransaction?>> call(
    EntityId accountId,
    Money actual,
    LocalDate date,
  ) => _uow.run(() async {
    final account = await _accounts.get(accountId);
    if (account == null) return const Err(NotFoundFailure('account'));
    if (actual.currency != account.currency) {
      throw ArgumentError('Остаток — в валюте счёта');
    }
    final current = (await _accounts.watchActive().first)
        .where((a) => a.account.id == accountId)
        .map((a) => a.balance)
        .firstOrNull;
    if (current == null) return const Err(NotFoundFailure('account'));
    final diff = actual - current;
    if (diff.isZero) return const Ok(null);
    final now = _clock.now().toUtc();
    final t = FinTransaction(
      id: EntityId.generate(),
      kind: TransactionKind.adjustment,
      accountId: account.id,
      amount: diff,
      reportEffect: ReportEffect.none,
      date: date,
      createdAt: now,
      updatedAt: now,
    );
    await _transactions.insert(t);
    return Ok(t);
  });
}

/// Архивировать счёт или вернуть из архива (FR-FIN-04: удалять счёт с операциями
/// можно только через архив или явный перенос — перенос появится в SCR-35).
final class SetAccountArchived {
  final AccountRepository _accounts;
  final Clock _clock;
  SetAccountArchived(this._accounts, this._clock);

  Future<Result<void>> call(EntityId id, {required bool archived}) async {
    final a = await _accounts.get(id);
    if (a == null) return const Err(NotFoundFailure('account'));
    await _accounts.save(
      archived
          ? a.copyWith(archivedAt: _clock.now().toUtc())
          : a.copyWith(clearArchived: true),
    );
    return const Ok(null);
  }
}
