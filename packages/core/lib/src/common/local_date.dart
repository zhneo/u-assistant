/// Календарная дата без времени и часового пояса (REQUIREMENTS §6.10, DATABASE §1).
///
/// «Расход 23 октября» остаётся 23 октября при любой смене пояса.
/// В базе хранится строкой `YYYY-MM-DD`.
final class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;

  LocalDate(this.year, this.month, this.day) {
    final d = DateTime.utc(year, month, day);
    if (d.year != year || d.month != month || d.day != day) {
      throw ArgumentError('Несуществующая дата: $year-$month-$day');
    }
  }

  factory LocalDate.fromDateTime(DateTime d) =>
      LocalDate(d.year, d.month, d.day);

  static final _iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  static LocalDate? tryParse(String s) {
    final m = _iso.firstMatch(s);
    if (m == null) return null;
    try {
      return LocalDate(
        int.parse(m.group(1)!),
        int.parse(m.group(2)!),
        int.parse(m.group(3)!),
      );
    } on ArgumentError {
      return null;
    }
  }

  static LocalDate parse(String s) =>
      tryParse(s) ?? (throw FormatException('Ожидалась дата YYYY-MM-DD', s));

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// Полночь этой даты в локальном времени — для форматирования в интерфейсе.
  DateTime toDateTime() => DateTime(year, month, day);

  LocalDate addDays(int days) =>
      LocalDate.fromDateTime(DateTime.utc(year, month, day + days));

  LocalDate get firstDayOfMonth => LocalDate(year, month, 1);
  LocalDate get lastDayOfMonth =>
      LocalDate.fromDateTime(DateTime.utc(year, month + 1, 0));

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  @override
  int compareTo(LocalDate other) => year != other.year
      ? year.compareTo(other.year)
      : month != other.month
      ? month.compareTo(other.month)
      : day.compareTo(other.day);

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}

/// Период из дат, обе границы включительно.
final class DatePeriod {
  final LocalDate start;
  final LocalDate end;

  DatePeriod(this.start, this.end) {
    if (end.isBefore(start)) {
      throw ArgumentError('Конец периода раньше начала: $start – $end');
    }
  }

  /// Календарный месяц, в который попадает [date].
  factory DatePeriod.monthOf(LocalDate date) =>
      DatePeriod(date.firstDayOfMonth, date.lastDayOfMonth);

  /// Такой же по типу предыдущий месяц (для сравнения «к прошлому месяцу», FR-FIN-29).
  DatePeriod previousMonth() => DatePeriod.monthOf(start.addDays(-1));

  bool contains(LocalDate d) => !d.isBefore(start) && !d.isAfter(end);

  @override
  bool operator ==(Object other) =>
      other is DatePeriod && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start..$end';
}
