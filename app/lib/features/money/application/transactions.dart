import 'package:core/core.dart';

/// Данные расхода или дохода из формы (FR-FIN-05). Обязательна только сумма;
/// без категории операция попадает в системную «Без категории».
final class IncomeExpenseInput {
  final TransactionKind kind;
  final Money? amount;
  final EntityId accountId;
  final EntityId? categoryId;
  final LocalDate date;
  final String? time;
  final String? note;
  final bool isRefund;

  const IncomeExpenseInput({
    required this.kind,
    required this.amount,
    required this.accountId,
    required this.date,
    this.categoryId,
    this.time,
    this.note,
    this.isRefund = false,
  });
}

/// Общие шаги записи операций: базовая валюта, курс на дату, сумма в базовой.
final class _Pricing {
  final SettingsRepository settings;
  final ExchangeRateRepository rates;
  _Pricing(this.settings, this.rates);

  Future<({Decimal? rate, Money? amountBase})> of(
    Money amount,
    LocalDate date,
  ) async {
    final base = await settings.baseCurrency();
    if (base == null) throw StateError('Базовая валюта не задана');
    if (amount.currency == base) return toBase(amount, base, null);
    return toBase(amount, base, await rates.at(amount.currency, base, date));
  }
}

/// Сохранить новый или изменённый расход / доход (SH-01, SH-02, SCR-32).
final class RecordIncomeExpense {
  final UnitOfWork _uow;
  final TransactionRepository _transactions;
  final AccountRepository _accounts;
  final CategoryRepository _categories;
  final SettingsRepository _settings;
  final _Pricing _pricing;
  final Clock _clock;

  RecordIncomeExpense(
    this._uow,
    this._transactions,
    this._accounts,
    this._categories,
    this._settings,
    ExchangeRateRepository rates,
    this._clock,
  ) : _pricing = _Pricing(_settings, rates);

  /// [existingId] — изменить существующую операцию; иначе создаётся новая.
  Future<Result<FinTransaction>> call(
    IncomeExpenseInput input, {
    EntityId? existingId,
  }) async {
    if (input.kind != TransactionKind.expense &&
        input.kind != TransactionKind.income) {
      throw ArgumentError('Только расход или доход');
    }
    final amount = input.amount;
    if (amount == null) {
      return const Err(ValidationFailure('amount', ValidationReason.required));
    }
    if (!amount.isPositive) {
      return const Err(
        ValidationFailure('amount', ValidationReason.mustBePositive),
      );
    }
    final note = FinTransaction.validateNote(input.note);
    if (note case Err(:final failure)) return Err(failure);

    return _uow.run(() async {
      final account = await _accounts.get(input.accountId);
      if (account == null) return const Err(NotFoundFailure('account'));
      if (account.currency != amount.currency) {
        throw ArgumentError('Сумма должна быть в валюте счёта');
      }
      final categoryKind =
          input.kind == TransactionKind.expense || input.isRefund
          ? CategoryKind.expense
          : CategoryKind.income;
      final categoryId = input.categoryId ?? await _uncategorized(categoryKind);
      final category = await _categories.get(categoryId);
      if (category == null) return const Err(NotFoundFailure('category'));
      if (category.kind != categoryKind) {
        return const Err(
          ValidationFailure('category', ValidationReason.invalidFormat),
        );
      }

      final priced = await _pricing.of(amount, input.date);
      final now = _clock.now().toUtc();
      final FinTransaction t;
      if (existingId == null) {
        t = FinTransaction(
          id: EntityId.generate(),
          kind: input.kind,
          accountId: account.id,
          categoryId: categoryId,
          amount: amount,
          rateToBase: priced.rate,
          amountBase: priced.amountBase,
          reportEffect: reportEffectOf(input.kind),
          isRefund: input.isRefund,
          date: input.date,
          time: input.time,
          note: note.value,
          createdAt: now,
          updatedAt: now,
        );
        await _transactions.insert(t);
      } else {
        final old = await _transactions.get(existingId);
        if (old == null) return const Err(NotFoundFailure('transaction'));
        if (old.kind != input.kind) {
          throw ArgumentError('Тип операции при изменении не меняется');
        }
        // Курс пересчитывается, только если изменились сумма, счёт или дата:
        // иначе сохранённая сумма в базовой не трогается (I8).
        final repriced =
            old.amount != amount ||
            old.accountId != account.id ||
            old.date != input.date;
        t = FinTransaction(
          id: old.id,
          kind: old.kind,
          accountId: account.id,
          categoryId: categoryId,
          amount: amount,
          rateToBase: repriced ? priced.rate : old.rateToBase,
          amountBase: repriced ? priced.amountBase : old.amountBase,
          reportEffect: old.reportEffect,
          isRefund: input.isRefund,
          date: input.date,
          time: input.time,
          note: note.value,
          createdAt: old.createdAt,
          updatedAt: now,
        );
        await _transactions.update(t);
      }
      await _settings.setLastAccountId(account.id);
      return Ok(t);
    });
  }

  Future<EntityId> _uncategorized(CategoryKind kind) async {
    final key = kind == CategoryKind.expense
        ? uncategorizedExpenseKey
        : uncategorizedIncomeKey;
    final c = await _categories.byDefaultKey(key);
    if (c == null) throw StateError('Нет системной категории $key');
    return c.id;
  }
}

/// Данные перевода из формы (FR-FIN-07).
final class TransferInput {
  final EntityId fromAccountId;
  final EntityId toAccountId;
  final Money? debit;

  /// Сумма зачисления — только для счетов в разных валютах.
  final Money? credit;

  /// Категория — для перевода между «в бюджете» и «только отслеживать» (§6.4).
  final EntityId? categoryId;
  final LocalDate date;
  final String? note;

  const TransferInput({
    required this.fromAccountId,
    required this.toAccountId,
    required this.debit,
    required this.date,
    this.credit,
    this.categoryId,
    this.note,
  });
}

/// Сохранить перевод: две записи с общим `transfer_group_id` в одной транзакции (I1).
/// Изменение перевода меняет обе части сразу (FR-FIN-08).
final class RecordTransfer {
  final UnitOfWork _uow;
  final TransactionRepository _transactions;
  final AccountRepository _accounts;
  final CategoryRepository _categories;
  final _Pricing _pricing;
  final Clock _clock;

  RecordTransfer(
    this._uow,
    this._transactions,
    this._accounts,
    this._categories,
    SettingsRepository settings,
    ExchangeRateRepository rates,
    this._clock,
  ) : _pricing = _Pricing(settings, rates);

  /// [existingGroupId] — изменить существующий перевод.
  Future<Result<List<FinTransaction>>> call(
    TransferInput input, {
    EntityId? existingGroupId,
  }) async {
    final note = FinTransaction.validateNote(input.note);
    if (note case Err(:final failure)) return Err(failure);

    return _uow.run(() async {
      final from = await _accounts.get(input.fromAccountId);
      final to = await _accounts.get(input.toAccountId);
      if (from == null || to == null) {
        return const Err(NotFoundFailure('account'));
      }
      final checked = validateTransfer(
        from: from,
        to: to,
        debit: input.debit,
        credit: input.credit,
      );
      if (checked case Err(:final failure)) return Err(failure);
      final amounts = checked.value;

      final effects = transferEffects(from.budgetMode, to.budgetMode);
      final reported =
          effects.out != ReportEffect.none || effects.into != ReportEffect.none;
      EntityId? categoryId;
      if (reported) {
        // Перевод входит в отчёты как расход или доход — категория обязательна.
        if (input.categoryId == null) {
          return const Err(
            ValidationFailure('category', ValidationReason.required),
          );
        }
        final category = await _categories.get(input.categoryId!);
        final expected = effects.out == ReportEffect.expense
            ? CategoryKind.expense
            : CategoryKind.income;
        if (category == null || category.kind != expected) {
          return const Err(
            ValidationFailure('category', ValidationReason.invalidFormat),
          );
        }
        categoryId = category.id;
      }

      final now = _clock.now().toUtc();
      final outBase = await _pricing.of(amounts.debit, input.date);
      final inBase = await _pricing.of(amounts.credit, input.date);

      List<FinTransaction> old = const [];
      if (existingGroupId != null) {
        old = await _transactions.transferPair(existingGroupId);
        if (old.length != 2) return const Err(NotFoundFailure('transfer'));
      }
      final group = existingGroupId ?? EntityId.generate();
      FinTransaction? oldOf(TransactionKind k) =>
          old.where((t) => t.kind == k).firstOrNull;

      FinTransaction part(
        TransactionKind kind,
        Account account,
        Money amount,
        ({Decimal? rate, Money? amountBase}) base,
        ReportEffect effect,
      ) {
        final prev = oldOf(kind);
        return FinTransaction(
          id: prev?.id ?? EntityId.generate(),
          kind: kind,
          accountId: account.id,
          categoryId: effect == ReportEffect.none ? null : categoryId,
          amount: amount,
          rateToBase: base.rate,
          amountBase: base.amountBase,
          reportEffect: effect,
          date: input.date,
          note: note.value,
          transferGroupId: group,
          createdAt: prev?.createdAt ?? now,
          updatedAt: now,
        );
      }

      final pair = [
        part(
          TransactionKind.transferOut,
          from,
          amounts.debit,
          outBase,
          effects.out,
        ),
        part(
          TransactionKind.transferIn,
          to,
          amounts.credit,
          inBase,
          effects.into,
        ),
      ];
      for (final t in pair) {
        if (existingGroupId == null) {
          await _transactions.insert(t);
        } else {
          await _transactions.update(t);
        }
      }
      return Ok(pair);
    });
  }
}

/// Удалить операцию в корзину; перевод удаляется целиком (§5.4, FR-FIN-08).
final class DeleteTransaction {
  final UnitOfWork _uow;
  final TransactionRepository _transactions;
  final Clock _clock;
  DeleteTransaction(this._uow, this._transactions, this._clock);

  Future<Result<void>> call(EntityId id) => _uow.run(() async {
    final t = await _transactions.get(id);
    if (t == null) return const Err(NotFoundFailure('transaction'));
    final ids = t.transferGroupId == null
        ? [t.id]
        : (await _transactions.transferPair(t.transferGroupId!))
              .map((e) => e.id);
    await _transactions.softDelete(ids, _clock.now().toUtc());
    return const Ok(null);
  });
}
