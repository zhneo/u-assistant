import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

void main() {
  for (final brightness in Brightness.values) {
    group('Оболочка, тема ${brightness.name}', () {
      testWidgets('открывается «Сегодня» с датой по фиксированным часам', (
        tester,
      ) async {
        await pumpApp(tester, brightness: brightness);
        expect(find.text('Сегодня'), findsWidgets);
        expect(find.text('Пятница, 23 октября'), findsOneWidget);
        expect(find.text('На сегодня ничего не запланировано'), findsOneWidget);
      });

      testWidgets('переключение вкладок и стек каждой вкладки', (tester) async {
        await pumpApp(tester, brightness: brightness);
        await tester.tap(find.bySemanticsLabel('Деньги'));
        await tester.pumpAndSettle();
        expect(find.text('Создайте первый счёт'), findsOneWidget);
        await tester.tap(find.bySemanticsLabel('Заметки'));
        await tester.pumpAndSettle();
        expect(find.text('Здесь будут заметки'), findsOneWidget);
        await tester.tap(find.bySemanticsLabel('Дела'));
        await tester.pumpAndSettle();
        expect(find.text('Здесь будут задачи'), findsOneWidget);
      });

      testWidgets('«Добавить» открывает лист с 6 типами записей', (
        tester,
      ) async {
        await pumpApp(tester, brightness: brightness);
        await tester.tap(find.bySemanticsLabel('Добавить'));
        await tester.pumpAndSettle();
        for (final t in [
          'Расход',
          'Доход',
          'Перевод',
          'Задача',
          'Заметка',
          'Голосом',
        ]) {
          expect(find.text(t), findsOneWidget, reason: t);
        }
      });
    });
  }

  testWidgets('крупный шрифт 200%: без переполнений', (tester) async {
    tester.view.physicalSize = const Size(750, 1334); // iPhone SE
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await pumpApp(tester, textScale: 2.0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('доступность: размеры зон нажатия и подписи', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
