import 'package:core/core.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:u_assistant/app.dart';
import 'package:u_assistant/data/database/app_database.dart'
    hide Account, Category, ExchangeRate, FinTransaction;
import 'package:u_assistant/data/database/database_provider.dart';
import 'package:u_assistant/data/finance/finance_repositories.dart';
import 'package:u_assistant/data/providers.dart';
import 'package:u_assistant/data/settings/drift_settings_repository.dart';
import 'package:u_assistant/services/clock_provider.dart';
import 'package:u_assistant/services/finance_seed.dart';
import 'package:u_assistant/services/onboarding.dart';

/// Приложение с базой в памяти и фиксированными часами (TESTING_STRATEGY §6–§7).
///
/// [onboarded] — онбординг пройден: базовая валюта KZT и стандартные категории.
/// [seed] — подготовить данные до запуска (счета, операции) настоящими репозиториями.
Future<TestData> pumpApp(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
  bool onboarded = true,
  Future<void> Function(TestData data)? seed,
}) async {
  await initializeDateFormatting('ru');
  // Потоки drift закрываются сразу, иначе тест падает на «Timer is still pending».
  final db = AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  addTearDown(db.close);
  final clock = FixedClock();
  final settings = DriftSettingsRepository(db, clock);
  final data = TestData(db, clock, settings);
  // Запись в базу — вне фальшивого времени виджет-теста.
  await tester.runAsync(() async {
    if (onboarded) await data.onboard();
    if (seed != null) await seed(data);
    await settings.load();
  });
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(clock),
        driftSettingsProvider.overrideWithValue(settings),
      ],
      child: const UAssistantApp(),
    ),
  );
  await settle(tester);
  return data;
}

/// pumpAndSettle с паузами для запросов drift: они выполняются вне фальшивого времени.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pumpAndSettle();
  }
}

/// Нажать и дождаться, пока экран обновится после записи в базу.
/// Элемент прокручивается к середине экрана: у края его закрывает нижняя панель.
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  final element = tester.element(finder);
  if (Scrollable.maybeOf(element) != null) {
    final scrolled = Scrollable.ensureVisible(element, alignment: 0.5);
    await tester.pumpAndSettle();
    await scrolled;
  }
  await tester.tap(finder);
  await settle(tester);
}

/// Подготовка данных для виджет-тестов настоящими репозиториями.
class TestData {
  final AppDatabase db;
  final FixedClock clock;
  final DriftSettingsRepository settings;
  TestData(this.db, this.clock, this.settings);

  late final accounts = DriftAccountRepository(db, clock);
  late final categories = DriftCategoryRepository(db, clock);
  late final transactions = DriftTransactionRepository(
    db,
    () => settings.cachedBase,
  );
  late final flow = OnboardingFlow(
    DriftUnitOfWork(db),
    settings,
    accounts,
    EnsureDefaultCategories(categories),
  );

  LocalDate get today => LocalDate.fromDateTime(clock.now());

  Future<void> onboard() async {
    await flow.chooseCurrency(Currency.kzt);
    await flow.complete();
  }

  Future<Account> account(
    String name, {
    Currency currency = Currency.kzt,
    int opening = 0,
    AccountType type = AccountType.card,
    BudgetMode mode = BudgetMode.onBudget,
  }) async {
    final all = await accounts.all();
    final a = Account(
      id: EntityId.generate(),
      name: name,
      type: type,
      currency: currency,
      openingBalance: Money(opening, currency),
      budgetMode: mode,
      icon: type.defaultIcon,
      sortOrder: all.length,
    );
    await accounts.save(a);
    return a;
  }

  /// Расход в базовой валюте с категорией по ключу стандартного набора.
  Future<FinTransaction> expense(
    Account account,
    int minor, {
    String categoryKey = 'food',
    LocalDate? date,
    String? note,
  }) async {
    final category = await categories.byDefaultKey(categoryKey);
    final now = clock.now().toUtc();
    final amount = Money(minor, account.currency);
    final t = FinTransaction(
      id: EntityId.generate(),
      kind: TransactionKind.expense,
      accountId: account.id,
      categoryId: category!.id,
      amount: amount,
      amountBase: amount,
      reportEffect: ReportEffect.expense,
      date: date ?? today,
      note: note,
      createdAt: now,
      updatedAt: now,
    );
    await transactions.insert(t);
    return t;
  }

  Future<List<FinTransaction>> all() =>
      transactions.watch(const TransactionFilter()).first;
}
