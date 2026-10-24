import 'package:core/core.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

/// Даты «по-человечески» (DESIGN_SYSTEM §14): «Сегодня», «Вчера», «Пт, 23 октября»;
/// год — только если дата не в текущем году.
String dayLabel(AppLocalizations l, LocalDate date, LocalDate today) {
  if (date == today) return l.today;
  if (date == today.addDays(-1)) return l.yesterday;
  final pattern = date.year == today.year ? 'EEE, d MMMM' : 'EEE, d MMMM y';
  final s = DateFormat(pattern, 'ru').format(date.toDateTime());
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

/// «23 октября» или «23 октября 2025».
String shortDate(LocalDate date, LocalDate today) => DateFormat(
  date.year == today.year ? 'd MMMM' : 'd MMMM y',
  'ru',
).format(date.toDateTime());

/// Месяц в предложном падеже для «Расходы в октябре». В `intl` такого падежа нет.
String monthPrepositional(int month) => const [
  'январе',
  'феврале',
  'марте',
  'апреле',
  'мае',
  'июне',
  'июле',
  'августе',
  'сентябре',
  'октябре',
  'ноябре',
  'декабре',
][month - 1];
