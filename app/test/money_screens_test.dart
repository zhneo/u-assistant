import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

/// Экраны вехи M1 шаг 3: онбординг, быстрый ввод, обзор денег, счета, операции.
/// Суммы в интерфейсе разделяют разряды неразрывным пробелом (как Money.format).
String nb(String s) => s.replaceAll(' ', '\u00A0');

void main() {
  Future<void> typeAmount(WidgetTester tester, String digits) async {
    for (final d in digits.split(' ')) {
      await tester.tap(find.text(d).last);
      await tester.pump();
    }
  }

  testWidgets(
    'SCR-02: онбординг из трёх шагов создаёт «Наличные» и ведёт на «Сегодня»',
    (tester) async {
      final data = await pumpApp(tester, onboarded: false);
      expect(find.text('Основная валюта'), findsOneWidget);
      await tapAndSettle(tester, find.text('Далее'));

      expect(find.text('Сколько у вас наличных?'), findsOneWidget);
      await typeAmount(tester, '5 000');
      expect(find.text(nb('5 000 ₸')), findsOneWidget);
      await tapAndSettle(tester, find.text('Создать счёт'));

      expect(
        find.text('Данные хранятся только на этом телефоне'),
        findsOneWidget,
      );
      await tapAndSettle(tester, find.text('Начать'));

      expect(find.text('Пятница, 23 октября'), findsOneWidget);
      final accounts = await tester.runAsync(() => data.accounts.all());
      expect(accounts!.single.name, 'Наличные');
      expect(accounts.single.openingBalance, Money(500000, Currency.kzt));
      expect(data.settings.cachedBase, Currency.kzt);
    },
  );

  testWidgets('S1: расход за 3 нажатия + ввод суммы, затем виден в «Деньгах»', (
    tester,
  ) async {
    final data = await pumpApp(
      tester,
      seed: (d) async => d.account('Карта', opening: 1000000),
    );
    await tapAndSettle(tester, find.bySemanticsLabel('Добавить')); // 1
    await tapAndSettle(tester, find.text('Расход').first); // 2
    expect(find.text('Новый расход'), findsOneWidget);
    await typeAmount(tester, '3 5 0 0');
    await tapAndSettle(tester, find.text('Готово')); // 3

    expect(find.text('Расход ${nb('3 500 ₸')} сохранён'), findsOneWidget);
    final list = await tester.runAsync(data.all);
    expect(list!.single.amount, Money(350000, Currency.kzt));
    expect(list.single.kind, TransactionKind.expense);

    await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
    expect(find.text(nb('6 500 ₸')), findsWidgets); // баланс карты и общий
    expect(find.text(nb('−3 500 ₸')), findsOneWidget); // последняя операция
  });

  testWidgets('«Готово» неактивна, пока сумма не введена (FR-FIN-05)', (
    tester,
  ) async {
    await pumpApp(tester, seed: (d) async => d.account('Карта'));
    await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
    await tapAndSettle(tester, find.text('Расход').first);
    final done = tester.widget<TextButton>(
      find.ancestor(of: find.text('Готово'), matching: find.byType(TextButton)),
    );
    expect(done.onPressed, isNull);
  });

  testWidgets('калькулятор на клавиатуре: 1 000 + 500 = 1 500 ₸', (
    tester,
  ) async {
    final data = await pumpApp(tester, seed: (d) async => d.account('Карта'));
    await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
    await tapAndSettle(tester, find.text('Расход').first);
    await typeAmount(tester, '1 000');
    await tapAndSettle(tester, find.bySemanticsLabel('Калькулятор'));
    await tapAndSettle(tester, find.bySemanticsLabel('плюс'));
    await typeAmount(tester, '5 0 0');
    expect(find.text('= ${nb('1 500 ₸')}'), findsOneWidget);
    await tapAndSettle(tester, find.text('Готово'));
    final list = await tester.runAsync(data.all);
    expect(list!.single.amount, Money(150000, Currency.kzt));
  });

  testWidgets('SH-03: перевод между счетами сохраняет две части (AC-01)', (
    tester,
  ) async {
    final data = await pumpApp(
      tester,
      seed: (d) async {
        await d.account('Карта', opening: 1000000);
        await d.account('Наличные', type: AccountType.cash);
      },
    );
    await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
    await tapAndSettle(tester, find.text('Перевод').first);
    expect(find.text('Новый перевод'), findsOneWidget);
    await typeAmount(tester, '2 000');
    await tapAndSettle(tester, find.text('Готово'));

    final list = await tester.runAsync(data.all);
    expect(list, hasLength(2));
    expect(list!.map((t) => t.kind).toSet(), {
      TransactionKind.transferOut,
      TransactionKind.transferIn,
    });
    expect(list.map((t) => t.reportEffect).toSet(), {ReportEffect.none});
  });

  testWidgets('SCR-30/31: обзор и операции по дням с итогом выборки', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (d) async {
        final card = await d.account('Карта', opening: 5000000);
        await d.expense(card, 120000, categoryKey: 'taxi');
        await d.expense(card, 80000, date: d.today.addDays(-1));
      },
    );
    await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
    expect(find.text('Общий баланс'), findsOneWidget);
    expect(find.text(nb('48 000 ₸')), findsWidgets);
    expect(find.text('Расходы в октябре'), findsOneWidget);
    expect(find.text(nb('2 000 ₸')), findsOneWidget);

    await tapAndSettle(tester, find.text('Операции'));
    expect(find.text('2 операции, ${nb('−2 000 ₸')}'), findsOneWidget);
    expect(find.text('Сегодня'), findsWidgets);
    expect(find.text('Вчера'), findsOneWidget);
    expect(find.text('Такси'), findsOneWidget);
  });

  testWidgets('SCR-32: операция открывается и удаляется', (tester) async {
    final data = await pumpApp(
      tester,
      seed: (d) async {
        final card = await d.account('Карта', opening: 100000);
        await d.expense(card, 50000, note: 'обед');
      },
    );
    await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
    await tapAndSettle(tester, find.textContaining('обед'));
    expect(find.text('Расход'), findsWidgets);
    expect(find.text(nb('−500 ₸')), findsOneWidget);
    await tapAndSettle(tester, find.text('Удалить'));
    await tapAndSettle(tester, find.text('Удалить').last);
    expect(find.text('Операция удалена'), findsOneWidget);
    expect(await tester.runAsync(data.all), isEmpty);
  });

  testWidgets('SCR-34/35: новый счёт через форму, затем экран счёта', (
    tester,
  ) async {
    final data = await pumpApp(tester);
    await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
    expect(find.text('Создайте первый счёт'), findsOneWidget);
    await tapAndSettle(tester, find.text('Добавить счёт'));
    expect(find.text('Новый счёт'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Kaspi Gold');
    await tester.enterText(find.byType(TextField).at(1), '25000');
    await tapAndSettle(tester, find.text('Сохранить'));

    final accounts = await tester.runAsync(() => data.accounts.all());
    expect(accounts!.single.name, 'Kaspi Gold');
    expect(accounts.single.openingBalance, Money(2500000, Currency.kzt));

    await tapAndSettle(tester, find.text('Kaspi Gold'));
    expect(find.text('Перевести'), findsOneWidget);
    expect(find.text('Изменить баланс'), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets(
      'форма расхода и обзор в теме ${brightness.name}: доступность',
      (tester) async {
        final handle = tester.ensureSemantics();
        await pumpApp(
          tester,
          brightness: brightness,
          seed: (d) async {
            final card = await d.account('Карта', opening: 100000);
            await d.expense(card, 50000);
          },
        );
        await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
        await tapAndSettle(tester, find.text('Расход').first);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
    );
  }

  testWidgets('крупный шрифт 200%: обзор, форма и онбординг без переполнений', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(750, 1334); // iPhone SE
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      textScale: 2.0,
      seed: (d) async {
        final card = await d.account('Карта', opening: 123456789);
        await d.expense(card, 350000, note: 'продукты на неделю');
      },
    );
    await tapAndSettle(tester, find.bySemanticsLabel('Деньги'));
    expect(tester.takeException(), isNull);
    await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
    await tapAndSettle(tester, find.text('Расход').first);
    expect(tester.takeException(), isNull);
  });

  testWidgets('крупный шрифт 200%: три шага онбординга и форма перевода', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(750, 1334); // iPhone SE
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await pumpApp(tester, textScale: 2.0, onboarded: false);
    expect(tester.takeException(), isNull);
    await tapAndSettle(tester, find.text('Далее'));
    expect(tester.takeException(), isNull);
    // При 200% кнопки шага ниже видимой части: их, как и пользователь, прокручиваем.
    await tester.scrollUntilVisible(
      find.text('Пропустить'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tapAndSettle(tester, find.text('Пропустить'));
    expect(tester.takeException(), isNull);
    await tapAndSettle(tester, find.text('Начать'));
    expect(tester.takeException(), isNull);

    await tapAndSettle(tester, find.bySemanticsLabel('Добавить'));
    await tapAndSettle(tester, find.text('Перевод').first);
    expect(find.text('Новый перевод'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
