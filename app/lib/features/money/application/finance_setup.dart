import 'package:core/core.dart';

/// Создаёт недостающие стандартные категории (FR-FIN-12). Повторный вызов ничего
/// не дублирует — так же работает «Восстановить стандартные».
final class EnsureDefaultCategories {
  final CategoryRepository _categories;
  EnsureDefaultCategories(this._categories);

  /// Возвращает число добавленных категорий.
  Future<int> call() async {
    var added = 0;
    var order = 0;
    for (final d in defaultCategoriesRu) {
      var parent = await _categories.byDefaultKey(d.key);
      if (parent == null) {
        parent = await _insert(d, null, order);
        added++;
      }
      order++;
      var childOrder = 0;
      for (final c in d.children) {
        if (await _categories.byDefaultKey(c.key) == null) {
          await _insert(c, parent.id, childOrder);
          added++;
        }
        childOrder++;
      }
    }
    return added;
  }

  Future<Category> _insert(
    DefaultCategory d,
    EntityId? parent,
    int order,
  ) async {
    final c = Category(
      id: EntityId.generate(),
      kind: d.kind,
      parentId: parent,
      name: d.name,
      icon: d.icon,
      colorIndex: d.colorIndex,
      sortOrder: order,
      defaultKey: d.key,
    );
    await _categories.save(c);
    return c;
  }
}

/// Онбординг финансов (SCR-02, FR-FIN-14): базовая валюта, стандартные категории
/// и первый счёт — одной транзакцией.
final class SetUpFinance {
  final UnitOfWork _uow;
  final SettingsRepository _settings;
  final AccountRepository _accounts;
  final EnsureDefaultCategories _ensureCategories;

  SetUpFinance(
    this._uow,
    this._settings,
    this._accounts,
    this._ensureCategories,
  );

  Future<Result<Account>> call({
    required Currency baseCurrency,
    required String accountName,
    AccountType type = AccountType.card,
    Money? openingBalance,
  }) async {
    final name = Account.validateName(accountName);
    if (name case Err(:final failure)) return Err(failure);
    final opening = openingBalance ?? Money.zero(baseCurrency);
    if (opening.currency != baseCurrency) {
      throw ArgumentError('Первый счёт создаётся в базовой валюте');
    }
    final account = Account(
      id: EntityId.generate(),
      name: name.value,
      type: type,
      currency: baseCurrency,
      openingBalance: opening,
      icon: accountIconFor(type),
    );
    await _uow.run(() async {
      await _settings.setBaseCurrency(baseCurrency);
      await _ensureCategories();
      await _accounts.save(account);
      await _settings.setLastAccountId(account.id);
    });
    return Ok(account);
  }
}

/// Иконка счёта по умолчанию для типа.
String accountIconFor(AccountType type) => switch (type) {
  AccountType.cash => 'cash',
  AccountType.card => 'card',
  AccountType.bank => 'bank',
  AccountType.deposit => 'savings',
  AccountType.credit => 'credit',
  AccountType.other => 'wallet',
};
