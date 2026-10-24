// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'U-Assistant';

  @override
  String get tabToday => 'Сегодня';

  @override
  String get tabTasks => 'Дела';

  @override
  String get tabAdd => 'Добавить';

  @override
  String get tabMoney => 'Деньги';

  @override
  String get tabNotes => 'Заметки';

  @override
  String get actionSearch => 'Поиск';

  @override
  String get actionSettings => 'Настройки';

  @override
  String get addSheetTitle => 'Добавить';

  @override
  String get addExpense => 'Расход';

  @override
  String get addIncome => 'Доход';

  @override
  String get addTransfer => 'Перевод';

  @override
  String get addTask => 'Задача';

  @override
  String get addNote => 'Заметка';

  @override
  String get addVoice => 'Голосом';

  @override
  String get close => 'Закрыть';

  @override
  String comingInMilestone(String milestone) {
    return 'Появится в вехе $milestone';
  }

  @override
  String get todayEmptyTitle => 'На сегодня ничего не запланировано';

  @override
  String get todayEmptyMessage => 'Задачи, привычки и платежи появятся здесь.';

  @override
  String get tasksEmptyTitle => 'Здесь будут задачи';

  @override
  String get tasksEmptyMessage =>
      'Задачи без даты и проекта попадают во «Входящие».';

  @override
  String get moneyEmptyTitle => 'Создайте первый счёт';

  @override
  String get moneyEmptyMessage =>
      'Например, «Наличные». После этого можно записывать расходы.';

  @override
  String get notesEmptyTitle => 'Здесь будут заметки';

  @override
  String get notesEmptyMessage =>
      'Например, конспект встречи или список покупок.';

  @override
  String get startupErrorTitle => 'Не удалось открыть данные';

  @override
  String get startupErrorMessage =>
      'Ваши резервные копии целы. Восстановление появится в вехе M3.';
}
