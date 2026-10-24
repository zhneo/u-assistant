import 'package:core/core.dart';

/// Создаёт недостающие стандартные категории (FR-FIN-12). Повторный вызов ничего
/// не дублирует — так же работает «Восстановить стандартные».
/// Лежит в `services`: нужен и онбордингу, и модулю «Деньги» (ARCHITECTURE §1.3).
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
