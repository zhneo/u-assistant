import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'U-Assistant'**
  String get appTitle;

  /// No description provided for @tabToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get tabToday;

  /// No description provided for @tabTasks.
  ///
  /// In ru, this message translates to:
  /// **'Дела'**
  String get tabTasks;

  /// No description provided for @tabAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get tabAdd;

  /// No description provided for @tabMoney.
  ///
  /// In ru, this message translates to:
  /// **'Деньги'**
  String get tabMoney;

  /// No description provided for @tabNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get tabNotes;

  /// No description provided for @actionSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get actionSearch;

  /// No description provided for @actionSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get actionSettings;

  /// No description provided for @addSheetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get addSheetTitle;

  /// No description provided for @addExpense.
  ///
  /// In ru, this message translates to:
  /// **'Расход'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доход'**
  String get addIncome;

  /// No description provided for @addTransfer.
  ///
  /// In ru, this message translates to:
  /// **'Перевод'**
  String get addTransfer;

  /// No description provided for @addTask.
  ///
  /// In ru, this message translates to:
  /// **'Задача'**
  String get addTask;

  /// No description provided for @addNote.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get addNote;

  /// No description provided for @addVoice.
  ///
  /// In ru, this message translates to:
  /// **'Голосом'**
  String get addVoice;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @comingInMilestone.
  ///
  /// In ru, this message translates to:
  /// **'Появится в вехе {milestone}'**
  String comingInMilestone(String milestone);

  /// No description provided for @todayEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'На сегодня ничего не запланировано'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Задачи, привычки и платежи появятся здесь.'**
  String get todayEmptyMessage;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут задачи'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Задачи без даты и проекта попадают во «Входящие».'**
  String get tasksEmptyMessage;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут заметки'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Например, конспект встречи или список покупок.'**
  String get notesEmptyMessage;

  /// No description provided for @startupErrorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть данные'**
  String get startupErrorTitle;

  /// No description provided for @startupErrorMessage.
  ///
  /// In ru, this message translates to:
  /// **'Ваши резервные копии целы. Восстановление появится в вехе M3.'**
  String get startupErrorMessage;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get done;

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get next;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get edit;

  /// No description provided for @undo.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get undo;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get searchHint;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get yesterday;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Основная валюта'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencyHint.
  ///
  /// In ru, this message translates to:
  /// **'В ней считаются общие итоги. Можно изменить позже.'**
  String get onboardingCurrencyHint;

  /// No description provided for @onboardingRestore.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить из бэкапа'**
  String get onboardingRestore;

  /// No description provided for @onboardingRestoreLater.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление из бэкапа появится в вехе M3'**
  String get onboardingRestoreLater;

  /// No description provided for @onboardingCashTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сколько у вас наличных?'**
  String get onboardingCashTitle;

  /// No description provided for @onboardingCashHint.
  ///
  /// In ru, this message translates to:
  /// **'Создадим счёт «Наличные». Сумма может быть нулевой.'**
  String get onboardingCashHint;

  /// No description provided for @onboardingCreateAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создать счёт'**
  String get onboardingCreateAccount;

  /// No description provided for @onboardingSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get onboardingSkip;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Данные хранятся только на этом телефоне'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyNoSignup.
  ///
  /// In ru, this message translates to:
  /// **'Без регистрации'**
  String get onboardingPrivacyNoSignup;

  /// No description provided for @onboardingPrivacyBackup.
  ///
  /// In ru, this message translates to:
  /// **'Делайте резервную копию — файл можно сохранить куда угодно'**
  String get onboardingPrivacyBackup;

  /// No description provided for @onboardingPrivacyLoss.
  ///
  /// In ru, this message translates to:
  /// **'Если телефон потеряется, данные восстановятся только из копии'**
  String get onboardingPrivacyLoss;

  /// No description provided for @onboardingStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get onboardingStart;

  /// No description provided for @onboardingStepOf.
  ///
  /// In ru, this message translates to:
  /// **'Шаг {step} из {total}'**
  String onboardingStepOf(int step, int total);

  /// No description provided for @cashAccountName.
  ///
  /// In ru, this message translates to:
  /// **'Наличные'**
  String get cashAccountName;

  /// No description provided for @expense.
  ///
  /// In ru, this message translates to:
  /// **'Расход'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In ru, this message translates to:
  /// **'Доход'**
  String get income;

  /// No description provided for @transfer.
  ///
  /// In ru, this message translates to:
  /// **'Перевод'**
  String get transfer;

  /// No description provided for @adjustment.
  ///
  /// In ru, this message translates to:
  /// **'Корректировка баланса'**
  String get adjustment;

  /// No description provided for @newExpense.
  ///
  /// In ru, this message translates to:
  /// **'Новый расход'**
  String get newExpense;

  /// No description provided for @newIncome.
  ///
  /// In ru, this message translates to:
  /// **'Новый доход'**
  String get newIncome;

  /// No description provided for @newTransfer.
  ///
  /// In ru, this message translates to:
  /// **'Новый перевод'**
  String get newTransfer;

  /// No description provided for @editOperation.
  ///
  /// In ru, this message translates to:
  /// **'Изменить операцию'**
  String get editOperation;

  /// No description provided for @fieldCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get fieldCategory;

  /// No description provided for @fieldAccount.
  ///
  /// In ru, this message translates to:
  /// **'Счёт'**
  String get fieldAccount;

  /// No description provided for @fieldDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get fieldDate;

  /// No description provided for @fieldNote.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий'**
  String get fieldNote;

  /// No description provided for @fieldNoteHint.
  ///
  /// In ru, this message translates to:
  /// **'Необязательно'**
  String get fieldNoteHint;

  /// No description provided for @fieldFrom.
  ///
  /// In ru, this message translates to:
  /// **'Откуда'**
  String get fieldFrom;

  /// No description provided for @fieldTo.
  ///
  /// In ru, this message translates to:
  /// **'Куда'**
  String get fieldTo;

  /// No description provided for @fieldCredited.
  ///
  /// In ru, this message translates to:
  /// **'Зачислено'**
  String get fieldCredited;

  /// No description provided for @fieldRefund.
  ///
  /// In ru, this message translates to:
  /// **'Это возврат'**
  String get fieldRefund;

  /// No description provided for @allCategories.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get allCategories;

  /// No description provided for @swapAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Поменять счета местами'**
  String get swapAccounts;

  /// No description provided for @keypadBackspace.
  ///
  /// In ru, this message translates to:
  /// **'Стереть'**
  String get keypadBackspace;

  /// No description provided for @keypadCalculator.
  ///
  /// In ru, this message translates to:
  /// **'Калькулятор'**
  String get keypadCalculator;

  /// No description provided for @keypadPlus.
  ///
  /// In ru, this message translates to:
  /// **'плюс'**
  String get keypadPlus;

  /// No description provided for @keypadMinus.
  ///
  /// In ru, this message translates to:
  /// **'минус'**
  String get keypadMinus;

  /// No description provided for @keypadTimes.
  ///
  /// In ru, this message translates to:
  /// **'умножить'**
  String get keypadTimes;

  /// No description provided for @keypadDivide.
  ///
  /// In ru, this message translates to:
  /// **'разделить'**
  String get keypadDivide;

  /// No description provided for @keypadComma.
  ///
  /// In ru, this message translates to:
  /// **'запятая'**
  String get keypadComma;

  /// No description provided for @amountTotal.
  ///
  /// In ru, this message translates to:
  /// **'= {amount}'**
  String amountTotal(String amount);

  /// No description provided for @rateLine.
  ///
  /// In ru, this message translates to:
  /// **'Курс: 1 {from} = {rate} {to}'**
  String rateLine(String from, String rate, String to);

  /// No description provided for @noRateWarning.
  ///
  /// In ru, this message translates to:
  /// **'Нет курса {currency} — в общих итогах не учтётся'**
  String noRateWarning(String currency);

  /// No description provided for @transferAsExpense.
  ///
  /// In ru, this message translates to:
  /// **'Такой перевод учитывается как расход'**
  String get transferAsExpense;

  /// No description provided for @transferAsIncome.
  ///
  /// In ru, this message translates to:
  /// **'Такой перевод учитывается как доход'**
  String get transferAsIncome;

  /// No description provided for @chooseDifferentAccounts.
  ///
  /// In ru, this message translates to:
  /// **'Выберите разные счета'**
  String get chooseDifferentAccounts;

  /// No description provided for @createCashAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создать «Наличные»'**
  String get createCashAccount;

  /// No description provided for @discardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отменить ввод?'**
  String get discardTitle;

  /// No description provided for @discardMessage.
  ///
  /// In ru, this message translates to:
  /// **'Введённая сумма не сохранится.'**
  String get discardMessage;

  /// No description provided for @discardConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Не сохранять'**
  String get discardConfirm;

  /// No description provided for @keepEditing.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get keepEditing;

  /// No description provided for @saveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Данные в форме, попробуйте ещё раз.'**
  String get saveFailed;

  /// No description provided for @savedExpense.
  ///
  /// In ru, this message translates to:
  /// **'Расход {amount} сохранён'**
  String savedExpense(String amount);

  /// No description provided for @savedIncome.
  ///
  /// In ru, this message translates to:
  /// **'Доход {amount} сохранён'**
  String savedIncome(String amount);

  /// No description provided for @savedTransfer.
  ///
  /// In ru, this message translates to:
  /// **'Перевод {amount} сохранён'**
  String savedTransfer(String amount);

  /// No description provided for @deletedOperation.
  ///
  /// In ru, this message translates to:
  /// **'Операция удалена'**
  String get deletedOperation;

  /// No description provided for @chooseCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get chooseCategory;

  /// No description provided for @chooseAccount.
  ///
  /// In ru, this message translates to:
  /// **'Счёт'**
  String get chooseAccount;

  /// No description provided for @moneyOverview.
  ///
  /// In ru, this message translates to:
  /// **'Обзор'**
  String get moneyOverview;

  /// No description provided for @moneyOperations.
  ///
  /// In ru, this message translates to:
  /// **'Операции'**
  String get moneyOperations;

  /// No description provided for @totalBalance.
  ///
  /// In ru, this message translates to:
  /// **'Общий баланс'**
  String get totalBalance;

  /// No description provided for @totalByRate.
  ///
  /// In ru, this message translates to:
  /// **'по курсу {currency} {rate} от {date}'**
  String totalByRate(String currency, String rate, String date);

  /// No description provided for @totalIncomplete.
  ///
  /// In ru, this message translates to:
  /// **'неполный: нет курса {currencies}'**
  String totalIncomplete(String currencies);

  /// No description provided for @expensesIn.
  ///
  /// In ru, this message translates to:
  /// **'Расходы в {month}'**
  String expensesIn(String month);

  /// No description provided for @incomeIn.
  ///
  /// In ru, this message translates to:
  /// **'Доходы в {month}'**
  String incomeIn(String month);

  /// No description provided for @accounts.
  ///
  /// In ru, this message translates to:
  /// **'Счета'**
  String get accounts;

  /// No description provided for @addAccount.
  ///
  /// In ru, this message translates to:
  /// **'Добавить счёт'**
  String get addAccount;

  /// No description provided for @recentOperations.
  ///
  /// In ru, this message translates to:
  /// **'Последние операции'**
  String get recentOperations;

  /// No description provided for @allOperations.
  ///
  /// In ru, this message translates to:
  /// **'Все операции'**
  String get allOperations;

  /// No description provided for @operationsEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут операции'**
  String get operationsEmptyTitle;

  /// No description provided for @operationsEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите «Добавить», чтобы записать первый расход.'**
  String get operationsEmptyMessage;

  /// No description provided for @operationsCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} операция} few{{count} операции} many{{count} операций} other{{count} операции}}'**
  String operationsCount(int count);

  /// No description provided for @accountsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Счета'**
  String get accountsTitle;

  /// No description provided for @accountNew.
  ///
  /// In ru, this message translates to:
  /// **'Новый счёт'**
  String get accountNew;

  /// No description provided for @accountEdit.
  ///
  /// In ru, this message translates to:
  /// **'Счёт'**
  String get accountEdit;

  /// No description provided for @accountName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get accountName;

  /// No description provided for @accountNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например, Kaspi Gold'**
  String get accountNameHint;

  /// No description provided for @accountType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get accountType;

  /// No description provided for @accountCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Валюта'**
  String get accountCurrency;

  /// No description provided for @accountOpening.
  ///
  /// In ru, this message translates to:
  /// **'Начальный баланс'**
  String get accountOpening;

  /// No description provided for @accountOnBudget.
  ///
  /// In ru, this message translates to:
  /// **'Учитывать в бюджете'**
  String get accountOnBudget;

  /// No description provided for @accountOnBudgetHint.
  ///
  /// In ru, this message translates to:
  /// **'Выключите для кредитов и вкладов: переводы на такой счёт станут расходом'**
  String get accountOnBudgetHint;

  /// No description provided for @accountHidden.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть из общего баланса'**
  String get accountHidden;

  /// No description provided for @accountCurrencyLocked.
  ///
  /// In ru, this message translates to:
  /// **'Валюту нельзя изменить: у счёта есть операции'**
  String get accountCurrencyLocked;

  /// No description provided for @accountTransfer.
  ///
  /// In ru, this message translates to:
  /// **'Перевести'**
  String get accountTransfer;

  /// No description provided for @accountAdjust.
  ///
  /// In ru, this message translates to:
  /// **'Изменить баланс'**
  String get accountAdjust;

  /// No description provided for @accountAdjustTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фактический остаток'**
  String get accountAdjustTitle;

  /// No description provided for @accountAdjustHint.
  ///
  /// In ru, this message translates to:
  /// **'Разница запишется корректировкой — не доходом и не расходом'**
  String get accountAdjustHint;

  /// No description provided for @accountArchive.
  ///
  /// In ru, this message translates to:
  /// **'В архив'**
  String get accountArchive;

  /// No description provided for @accountUnarchive.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть из архива'**
  String get accountUnarchive;

  /// No description provided for @accountArchived.
  ///
  /// In ru, this message translates to:
  /// **'В архиве'**
  String get accountArchived;

  /// No description provided for @accountCreditHint.
  ///
  /// In ru, this message translates to:
  /// **'долг по кредиту'**
  String get accountCreditHint;

  /// No description provided for @accountTypeCash.
  ///
  /// In ru, this message translates to:
  /// **'Наличные'**
  String get accountTypeCash;

  /// No description provided for @accountTypeCard.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get accountTypeCard;

  /// No description provided for @accountTypeBank.
  ///
  /// In ru, this message translates to:
  /// **'Банковский счёт'**
  String get accountTypeBank;

  /// No description provided for @accountTypeDeposit.
  ///
  /// In ru, this message translates to:
  /// **'Вклад'**
  String get accountTypeDeposit;

  /// No description provided for @accountTypeCredit.
  ///
  /// In ru, this message translates to:
  /// **'Кредит'**
  String get accountTypeCredit;

  /// No description provided for @accountTypeOther.
  ///
  /// In ru, this message translates to:
  /// **'Другое'**
  String get accountTypeOther;

  /// No description provided for @accountGroupCash.
  ///
  /// In ru, this message translates to:
  /// **'Наличные'**
  String get accountGroupCash;

  /// No description provided for @accountGroupCards.
  ///
  /// In ru, this message translates to:
  /// **'Карты'**
  String get accountGroupCards;

  /// No description provided for @accountGroupBank.
  ///
  /// In ru, this message translates to:
  /// **'Счета и вклады'**
  String get accountGroupBank;

  /// No description provided for @accountGroupCredit.
  ///
  /// In ru, this message translates to:
  /// **'Кредиты'**
  String get accountGroupCredit;

  /// No description provided for @accountGroupOther.
  ///
  /// In ru, this message translates to:
  /// **'Другое'**
  String get accountGroupOther;

  /// No description provided for @accountArchivedSection.
  ///
  /// In ru, this message translates to:
  /// **'Архив'**
  String get accountArchivedSection;

  /// No description provided for @amountInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте сумму'**
  String get amountInvalid;

  /// No description provided for @nameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get nameRequired;

  /// No description provided for @nameTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Слишком длинное название'**
  String get nameTooLong;

  /// No description provided for @operationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Операция'**
  String get operationTitle;

  /// No description provided for @operationDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить операцию?'**
  String get operationDeleteTitle;

  /// No description provided for @operationDeleteTransferTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить перевод?'**
  String get operationDeleteTransferTitle;

  /// No description provided for @operationDeleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'Операция попадёт в корзину.'**
  String get operationDeleteMessage;

  /// No description provided for @debited.
  ///
  /// In ru, this message translates to:
  /// **'Списано'**
  String get debited;

  /// No description provided for @credited.
  ///
  /// In ru, this message translates to:
  /// **'Зачислено'**
  String get credited;

  /// No description provided for @rate.
  ///
  /// In ru, this message translates to:
  /// **'Курс'**
  String get rate;

  /// No description provided for @archivedAccount.
  ///
  /// In ru, this message translates to:
  /// **'Счёт удалён'**
  String get archivedAccount;

  /// No description provided for @moneyEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Создайте первый счёт'**
  String get moneyEmptyTitle;

  /// No description provided for @moneyEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Например, «Наличные». После этого можно записывать расходы.'**
  String get moneyEmptyMessage;

  /// No description provided for @categoryRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите категорию'**
  String get categoryRequired;

  /// No description provided for @creditRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму зачисления'**
  String get creditRequired;

  /// No description provided for @budgetModeLocked.
  ///
  /// In ru, this message translates to:
  /// **'Режим можно сменить, пока у счёта нет операций'**
  String get budgetModeLocked;

  /// No description provided for @notFound.
  ///
  /// In ru, this message translates to:
  /// **'Запись не найдена — возможно, её уже удалили'**
  String get notFound;

  /// No description provided for @rateInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте курс'**
  String get rateInvalid;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
