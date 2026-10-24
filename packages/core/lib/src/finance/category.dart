import '../common/app_failure.dart';
import '../common/entity_id.dart';
import '../common/result.dart';

enum CategoryKind {
  expense('expense'),
  income('income');

  final String dbValue;
  const CategoryKind(this.dbValue);

  static CategoryKind fromDb(String v) => values.firstWhere(
    (e) => e.dbValue == v,
    orElse: () => throw ArgumentError.value(v, 'CategoryKind'),
  );
}

/// Категория операций (FR-FIN-12, DATABASE §4.3). Не глубже двух уровней (I10).
final class Category {
  static const maxNameLength = 40;

  final EntityId id;
  final CategoryKind kind;
  final EntityId? parentId;
  final String name;
  final String icon;
  final int colorIndex;
  final int sortOrder;

  /// Ключ стандартной категории (`food`) — для «Восстановить стандартные»; у своих — null.
  final String? defaultKey;
  final bool hidden;

  const Category({
    required this.id,
    required this.kind,
    required this.name,
    this.parentId,
    this.icon = 'dots',
    this.colorIndex = 6,
    this.sortOrder = 0,
    this.defaultKey,
    this.hidden = false,
  });

  bool get isTopLevel => parentId == null;

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

  Category copyWith({
    String? name,
    String? icon,
    int? colorIndex,
    int? sortOrder,
    bool? hidden,
  }) => Category(
    id: id,
    kind: kind,
    parentId: parentId,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorIndex: colorIndex ?? this.colorIndex,
    sortOrder: sortOrder ?? this.sortOrder,
    defaultKey: defaultKey,
    hidden: hidden ?? this.hidden,
  );

  @override
  bool operator ==(Object other) =>
      other is Category &&
      other.id == id &&
      other.kind == kind &&
      other.parentId == parentId &&
      other.name == name &&
      other.icon == icon &&
      other.colorIndex == colorIndex &&
      other.sortOrder == sortOrder &&
      other.defaultKey == defaultKey &&
      other.hidden == hidden;

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    parentId,
    name,
    icon,
    colorIndex,
    sortOrder,
    defaultKey,
    hidden,
  );

  @override
  String toString() =>
      'Category($id, ${kind.dbValue}, ${defaultKey ?? 'custom'})';
}

/// Описание стандартной категории для начального набора.
final class DefaultCategory {
  final String key;
  final CategoryKind kind;
  final String name;
  final String icon;
  final int colorIndex;
  final List<DefaultCategory> children;

  const DefaultCategory(
    this.key,
    this.kind,
    this.name,
    this.icon,
    this.colorIndex, [
    this.children = const [],
  ]);
}

/// Системная категория «Без категории» (FR-FIN-05): операция без выбранной категории
/// попадает сюда, а не остаётся с пустым полем.
const uncategorizedExpenseKey = 'uncategorized_expense';
const uncategorizedIncomeKey = 'uncategorized_income';

/// Стандартный набор на русском (FR-FIN-12, D-061). Названия — данные, которые
/// записываются в базу один раз; пользователь может их переименовать.
/// Цвета — индексы палитры DESIGN_SYSTEM §2.2 (6 — серый «Другое»).
const defaultCategoriesRu = <DefaultCategory>[
  DefaultCategory('food', CategoryKind.expense, 'Продукты', 'cart', 1),
  DefaultCategory('cafe', CategoryKind.expense, 'Кафе и рестораны', 'cafe', 0),
  DefaultCategory('transport', CategoryKind.expense, 'Транспорт', 'bus', 3, [
    DefaultCategory('taxi', CategoryKind.expense, 'Такси', 'taxi', 3),
    DefaultCategory('fuel', CategoryKind.expense, 'Топливо', 'fuel', 3),
    DefaultCategory(
      'public_transport',
      CategoryKind.expense,
      'Общественный транспорт',
      'bus',
      3,
    ),
  ]),
  DefaultCategory('home', CategoryKind.expense, 'Жильё', 'home', 5, [
    DefaultCategory('rent', CategoryKind.expense, 'Аренда', 'home', 5),
    DefaultCategory(
      'utilities',
      CategoryKind.expense,
      'Коммунальные услуги',
      'bolt',
      5,
    ),
  ]),
  DefaultCategory(
    'communication',
    CategoryKind.expense,
    'Связь и интернет',
    'phone',
    3,
  ),
  DefaultCategory('health', CategoryKind.expense, 'Здоровье', 'health', 2),
  DefaultCategory(
    'clothes',
    CategoryKind.expense,
    'Одежда и обувь',
    'shirt',
    2,
  ),
  DefaultCategory(
    'education',
    CategoryKind.expense,
    'Образование',
    'school',
    4,
  ),
  DefaultCategory(
    'entertainment',
    CategoryKind.expense,
    'Развлечения',
    'film',
    1,
  ),
  DefaultCategory(
    'subscriptions',
    CategoryKind.expense,
    'Подписки',
    'repeat',
    5,
  ),
  DefaultCategory('gifts', CategoryKind.expense, 'Подарки', 'gift', 2),
  DefaultCategory('loans', CategoryKind.expense, 'Кредиты', 'bank', 4),
  DefaultCategory('other_expense', CategoryKind.expense, 'Другое', 'dots', 6),
  DefaultCategory(
    uncategorizedExpenseKey,
    CategoryKind.expense,
    'Без категории',
    'question',
    6,
  ),
  DefaultCategory('salary', CategoryKind.income, 'Зарплата', 'work', 5),
  DefaultCategory('side_job', CategoryKind.income, 'Подработка', 'work', 3),
  DefaultCategory('gifts_income', CategoryKind.income, 'Подарки', 'gift', 2),
  DefaultCategory(
    'interest',
    CategoryKind.income,
    'Проценты и кешбэк',
    'percent',
    4,
  ),
  DefaultCategory('other_income', CategoryKind.income, 'Другое', 'dots', 6),
  DefaultCategory(
    uncategorizedIncomeKey,
    CategoryKind.income,
    'Без категории',
    'question',
    6,
  ),
];
