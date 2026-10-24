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
  String get notesEmptyTitle => 'Здесь будут заметки';

  @override
  String get notesEmptyMessage =>
      'Например, конспект встречи или список покупок.';

  @override
  String get startupErrorTitle => 'Не удалось открыть данные';

  @override
  String get startupErrorMessage =>
      'Ваши резервные копии целы. Восстановление появится в вехе M3.';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get next => 'Далее';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get undo => 'Отменить';

  @override
  String get searchHint => 'Поиск';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get onboardingCurrencyTitle => 'Основная валюта';

  @override
  String get onboardingCurrencyHint =>
      'В ней считаются общие итоги. Можно изменить позже.';

  @override
  String get onboardingRestore => 'Восстановить из бэкапа';

  @override
  String get onboardingRestoreLater =>
      'Восстановление из бэкапа появится в вехе M3';

  @override
  String get onboardingCashTitle => 'Сколько у вас наличных?';

  @override
  String get onboardingCashHint =>
      'Создадим счёт «Наличные». Сумма может быть нулевой.';

  @override
  String get onboardingCreateAccount => 'Создать счёт';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingPrivacyTitle =>
      'Данные хранятся только на этом телефоне';

  @override
  String get onboardingPrivacyNoSignup => 'Без регистрации';

  @override
  String get onboardingPrivacyBackup =>
      'Делайте резервную копию — файл можно сохранить куда угодно';

  @override
  String get onboardingPrivacyLoss =>
      'Если телефон потеряется, данные восстановятся только из копии';

  @override
  String get onboardingStart => 'Начать';

  @override
  String onboardingStepOf(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String get cashAccountName => 'Наличные';

  @override
  String get expense => 'Расход';

  @override
  String get income => 'Доход';

  @override
  String get transfer => 'Перевод';

  @override
  String get adjustment => 'Корректировка баланса';

  @override
  String get newExpense => 'Новый расход';

  @override
  String get newIncome => 'Новый доход';

  @override
  String get newTransfer => 'Новый перевод';

  @override
  String get editOperation => 'Изменить операцию';

  @override
  String get fieldCategory => 'Категория';

  @override
  String get fieldAccount => 'Счёт';

  @override
  String get fieldDate => 'Дата';

  @override
  String get fieldNote => 'Комментарий';

  @override
  String get fieldNoteHint => 'Необязательно';

  @override
  String get fieldFrom => 'Откуда';

  @override
  String get fieldTo => 'Куда';

  @override
  String get fieldCredited => 'Зачислено';

  @override
  String get fieldRefund => 'Это возврат';

  @override
  String get allCategories => 'Все';

  @override
  String get swapAccounts => 'Поменять счета местами';

  @override
  String get keypadBackspace => 'Стереть';

  @override
  String get keypadCalculator => 'Калькулятор';

  @override
  String get keypadPlus => 'плюс';

  @override
  String get keypadMinus => 'минус';

  @override
  String get keypadTimes => 'умножить';

  @override
  String get keypadDivide => 'разделить';

  @override
  String get keypadComma => 'запятая';

  @override
  String amountTotal(String amount) {
    return '= $amount';
  }

  @override
  String rateLine(String from, String rate, String to) {
    return 'Курс: 1 $from = $rate $to';
  }

  @override
  String noRateWarning(String currency) {
    return 'Нет курса $currency — в общих итогах не учтётся';
  }

  @override
  String get transferAsExpense => 'Такой перевод учитывается как расход';

  @override
  String get transferAsIncome => 'Такой перевод учитывается как доход';

  @override
  String get chooseDifferentAccounts => 'Выберите разные счета';

  @override
  String get createCashAccount => 'Создать «Наличные»';

  @override
  String get discardTitle => 'Отменить ввод?';

  @override
  String get discardMessage => 'Введённая сумма не сохранится.';

  @override
  String get discardConfirm => 'Не сохранять';

  @override
  String get keepEditing => 'Продолжить';

  @override
  String get saveFailed =>
      'Не удалось сохранить. Данные в форме, попробуйте ещё раз.';

  @override
  String savedExpense(String amount) {
    return 'Расход $amount сохранён';
  }

  @override
  String savedIncome(String amount) {
    return 'Доход $amount сохранён';
  }

  @override
  String savedTransfer(String amount) {
    return 'Перевод $amount сохранён';
  }

  @override
  String get deletedOperation => 'Операция удалена';

  @override
  String get chooseCategory => 'Категория';

  @override
  String get chooseAccount => 'Счёт';

  @override
  String get moneyOverview => 'Обзор';

  @override
  String get moneyOperations => 'Операции';

  @override
  String get totalBalance => 'Общий баланс';

  @override
  String totalByRate(String currency, String rate, String date) {
    return 'по курсу $currency $rate от $date';
  }

  @override
  String totalIncomplete(String currencies) {
    return 'неполный: нет курса $currencies';
  }

  @override
  String expensesIn(String month) {
    return 'Расходы в $month';
  }

  @override
  String incomeIn(String month) {
    return 'Доходы в $month';
  }

  @override
  String get accounts => 'Счета';

  @override
  String get addAccount => 'Добавить счёт';

  @override
  String get recentOperations => 'Последние операции';

  @override
  String get allOperations => 'Все операции';

  @override
  String get operationsEmptyTitle => 'Здесь будут операции';

  @override
  String get operationsEmptyMessage =>
      'Нажмите «Добавить», чтобы записать первый расход.';

  @override
  String operationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count операции',
      many: '$count операций',
      few: '$count операции',
      one: '$count операция',
    );
    return '$_temp0';
  }

  @override
  String get accountsTitle => 'Счета';

  @override
  String get accountNew => 'Новый счёт';

  @override
  String get accountEdit => 'Счёт';

  @override
  String get accountName => 'Название';

  @override
  String get accountNameHint => 'Например, Kaspi Gold';

  @override
  String get accountType => 'Тип';

  @override
  String get accountCurrency => 'Валюта';

  @override
  String get accountOpening => 'Начальный баланс';

  @override
  String get accountOnBudget => 'Учитывать в бюджете';

  @override
  String get accountOnBudgetHint =>
      'Выключите для кредитов и вкладов: переводы на такой счёт станут расходом';

  @override
  String get accountHidden => 'Скрыть из общего баланса';

  @override
  String get accountCurrencyLocked =>
      'Валюту нельзя изменить: у счёта есть операции';

  @override
  String get accountTransfer => 'Перевести';

  @override
  String get accountAdjust => 'Изменить баланс';

  @override
  String get accountAdjustTitle => 'Фактический остаток';

  @override
  String get accountAdjustHint =>
      'Разница запишется корректировкой — не доходом и не расходом';

  @override
  String get accountArchive => 'В архив';

  @override
  String get accountUnarchive => 'Вернуть из архива';

  @override
  String get accountArchived => 'В архиве';

  @override
  String get accountCreditHint => 'долг по кредиту';

  @override
  String get accountTypeCash => 'Наличные';

  @override
  String get accountTypeCard => 'Карта';

  @override
  String get accountTypeBank => 'Банковский счёт';

  @override
  String get accountTypeDeposit => 'Вклад';

  @override
  String get accountTypeCredit => 'Кредит';

  @override
  String get accountTypeOther => 'Другое';

  @override
  String get accountGroupCash => 'Наличные';

  @override
  String get accountGroupCards => 'Карты';

  @override
  String get accountGroupBank => 'Счета и вклады';

  @override
  String get accountGroupCredit => 'Кредиты';

  @override
  String get accountGroupOther => 'Другое';

  @override
  String get accountArchivedSection => 'Архив';

  @override
  String get amountInvalid => 'Проверьте сумму';

  @override
  String get nameRequired => 'Введите название';

  @override
  String get nameTooLong => 'Слишком длинное название';

  @override
  String get operationTitle => 'Операция';

  @override
  String get operationDeleteTitle => 'Удалить операцию?';

  @override
  String get operationDeleteTransferTitle => 'Удалить перевод?';

  @override
  String get operationDeleteMessage => 'Операция попадёт в корзину.';

  @override
  String get debited => 'Списано';

  @override
  String get credited => 'Зачислено';

  @override
  String get rate => 'Курс';

  @override
  String get archivedAccount => 'Счёт удалён';

  @override
  String get moneyEmptyTitle => 'Создайте первый счёт';

  @override
  String get moneyEmptyMessage =>
      'Например, «Наличные». После этого можно записывать расходы.';

  @override
  String get categoryRequired => 'Выберите категорию';

  @override
  String get creditRequired => 'Введите сумму зачисления';

  @override
  String get budgetModeLocked =>
      'Режим можно сменить, пока у счёта нет операций';

  @override
  String get notFound => 'Запись не найдена — возможно, её уже удалили';

  @override
  String get rateInvalid => 'Проверьте курс';
}
