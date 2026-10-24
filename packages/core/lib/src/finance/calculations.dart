import '../common/local_date.dart';
import '../money/currency.dart';
import '../money/exchange_rate.dart';
import '../money/money.dart';
import 'account.dart';
import 'transaction.dart';

/// Эталонные финансовые формулы REQUIREMENTS §6. Тесты финансовой логики пишутся по ним;
/// SQL-агрегаты в приложении сверяются с этими функциями (D-060).

/// Баланс счёта (§6.2): начальный баланс + фактические неудалённые операции счёта со знаком.
Money accountBalance(Account account, Iterable<FinTransaction> transactions) {
  var total = account.openingBalance;
  for (final t in transactions) {
    if (t.accountId != account.id) continue;
    if (t.status != TransactionStatus.posted || t.isDeleted) continue;
    total += t.signedAmount;
  }
  return total;
}

/// Общий баланс в базовой валюте (§6.3, AC-16, AC-17).
final class TotalBalance {
  final Money total;

  /// Валюты, для которых нет курса: их счета не учтены, итог неполный.
  final Set<Currency> missingRates;

  /// Самая ранняя дата курса среди использованных — показывается рядом с итогом.
  final LocalDate? oldestRateDate;

  const TotalBalance(this.total, this.missingRates, this.oldestRateDate);

  bool get isComplete => missingRates.isEmpty;
}

/// Сумма балансов счетов без флага «скрыть» и не в архиве, пересчитанная
/// по **последнему** курсу каждой валюты на [today]. Кредиты входят со своим
/// (отрицательным) балансом. Нет курса → валюта в [TotalBalance.missingRates],
/// счёт не превращается молча в ноль (FR-FIN-16).
TotalBalance totalBalance(
  Iterable<AccountWithBalance> accounts,
  Currency base,
  Iterable<ExchangeRate> rates,
  LocalDate today,
) {
  var total = Money.zero(base);
  final missing = <Currency>{};
  LocalDate? oldest;
  for (final a in accounts) {
    if (a.account.hidden || a.account.isArchived) continue;
    final balance = a.balance;
    if (balance.currency == base) {
      total += balance;
      continue;
    }
    final rate = rateOn(rates, balance.currency, base, today);
    if (rate == null) {
      missing.add(balance.currency);
      continue;
    }
    total += balance.convert(rate.rate, base);
    if (oldest == null || rate.validFrom.isBefore(oldest)) {
      oldest = rate.validFrom;
    }
  }
  return TotalBalance(total, missing, oldest);
}

/// Доходы и расходы за период (§6.4–6.5).
final class PeriodSummary {
  final Money income;
  final Money expense;

  /// Есть операции без суммы в базовой валюте (не было курса) — итог неполный.
  final bool isComplete;

  const PeriodSummary(this.income, this.expense, this.isComplete);

  /// Чистый поток = доходы − расходы (§6.5).
  Money get net => income - expense;

  @override
  bool operator ==(Object other) =>
      other is PeriodSummary &&
      other.income == income &&
      other.expense == expense &&
      other.isComplete == isComplete;

  @override
  int get hashCode => Object.hash(income, expense, isComplete);

  @override
  String toString() => 'PeriodSummary(complete: $isComplete)';
}

/// Итоги периода по `report_effect` и сумме в базовой валюте, зафиксированной при записи:
/// - переводы между счетами одного режима, корректировки, долги и плановые операции
///   не учитываются (их `report_effect = none` или статус `planned`);
/// - пересчёт — по курсу из операции, новый курс историю не меняет (AC-17);
/// - возврат уменьшает расход своей категории, но не ниже нуля;
///   остаток показывается как доход (§6.4, FR-FIN-10).
PeriodSummary periodSummary(
  Iterable<FinTransaction> transactions,
  DatePeriod period,
  Currency base,
) {
  var income = 0;
  var complete = true;
  final expenseByCategory = <Object?, int>{};
  final refundByCategory = <Object?, int>{};

  for (final t in transactions) {
    if (t.status != TransactionStatus.posted || t.isDeleted) continue;
    if (!period.contains(t.date)) continue;
    if (t.reportEffect == ReportEffect.none) continue;
    final amountBase = t.amountBase;
    if (amountBase == null) {
      complete = false;
      continue;
    }
    if (amountBase.currency != base) {
      throw ArgumentError('Сумма операции в другой базовой валюте');
    }
    final v = amountBase.amountMinor;
    if (t.reportEffect == ReportEffect.expense) {
      expenseByCategory.update(t.categoryId, (s) => s + v, ifAbsent: () => v);
    } else if (t.isRefund) {
      refundByCategory.update(t.categoryId, (s) => s + v, ifAbsent: () => v);
    } else {
      income += v;
    }
  }

  var expense = 0;
  final categories = {...expenseByCategory.keys, ...refundByCategory.keys};
  for (final c in categories) {
    final spent = expenseByCategory[c] ?? 0;
    final refunded = refundByCategory[c] ?? 0;
    if (refunded <= spent) {
      expense += spent - refunded;
    } else {
      income += refunded - spent;
    }
  }
  return PeriodSummary(Money(income, base), Money(expense, base), complete);
}
