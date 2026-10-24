import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/category_icon.dart';
import '../../../design_system/icons/app_icons.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../design_system/tokens/text_scale.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/date_labels.dart';
import '../../../routing/routes.dart';
import '../../../services/clock_provider.dart';
import '../presentation/money_view_models.dart';
import 'money_labels.dart';

/// Элемент списка операций: заголовок дня или строка.
sealed class OperationListItem {
  const OperationListItem();
}

final class DayHeader extends OperationListItem {
  final LocalDate date;

  /// Итог дня в базовой валюте: доходы − расходы по правилам §6.4.
  final Money? net;
  const DayHeader(this.date, this.net);
}

final class OperationItem extends OperationListItem {
  final FinTransaction transaction;

  /// Вторая часть перевода, если она есть в том же списке.
  final FinTransaction? partner;
  const OperationItem(this.transaction, this.partner);
}

/// Список по дням (UI_SPECIFICATION SCR-31): перевод показывается одной строкой
/// «Карта → Наличные» — по части-списанию; вторая часть пропускается.
/// [relativeTo] — экран счёта: перевод показывается со знаком для этого счёта.
List<OperationListItem> groupByDay(
  List<FinTransaction> list,
  Currency base, {
  EntityId? relativeTo,
}) {
  final byGroup = <EntityId, List<FinTransaction>>{};
  for (final t in list) {
    final g = t.transferGroupId;
    if (g != null) (byGroup[g] ??= []).add(t);
  }
  final rows = <OperationItem>[];
  for (final t in list) {
    // На экране счёта вторые части переводов нужны только как подпись «Откуда → Куда».
    if (relativeTo != null && t.accountId != relativeTo) continue;
    final g = t.transferGroupId;
    if (g == null) {
      rows.add(OperationItem(t, null));
      continue;
    }
    final pair = byGroup[g]!;
    final partner = pair.where((p) => p.id != t.id).firstOrNull;
    // В общем списке перевод — одна строка по части-списанию.
    if (relativeTo == null &&
        partner != null &&
        t.kind == TransactionKind.transferIn) {
      continue;
    }
    rows.add(OperationItem(t, partner));
  }

  final items = <OperationListItem>[];
  LocalDate? day;
  var dayStart = 0;
  void closeDay() {
    if (day == null) return;
    final dayRows = items.sublist(dayStart + 1).cast<OperationItem>();
    final summary = periodSummary(
      [
        for (final r in dayRows) ...[r.transaction, ?r.partner],
      ],
      DatePeriod(day, day),
      base,
    );
    items[dayStart] = DayHeader(day, summary.net.isZero ? null : summary.net);
  }

  for (final r in rows) {
    if (r.transaction.date != day) {
      closeDay();
      day = r.transaction.date;
      dayStart = items.length;
      items.add(DayHeader(r.transaction.date, null));
    }
    items.add(r);
  }
  closeDay();
  return items;
}

/// Ленивый список операций по дням для [CustomScrollView].
class OperationSliverList extends ConsumerWidget {
  final List<OperationListItem> items;
  final EntityId? relativeTo;

  const OperationSliverList({super.key, required this.items, this.relativeTo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final l = AppLocalizations.of(context);
    final c = context.colors;
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => switch (items[i]) {
        DayHeader(:final date, :final net) => Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    dayLabel(l, date, today),
                    style: AppTypography.footnote.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
              ),
              if (net != null)
                Text(
                  net.isNegative ? net.format() : '+${net.format()}',
                  style: AppTypography.footnote.copyWith(
                    color: c.textSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
        ),
        OperationItem(:final transaction, :final partner) => OperationRow(
          transaction: transaction,
          partner: partner,
          relativeTo: relativeTo,
        ),
      },
    );
  }
}

/// Строка операции (DESIGN_SYSTEM §8.4): иконка категории 30, название и подпись,
/// сумма справа табличными цифрами. Нажатие → SCR-32.
class OperationRow extends ConsumerWidget {
  final FinTransaction transaction;
  final FinTransaction? partner;
  final EntityId? relativeTo;

  const OperationRow({
    super.key,
    required this.transaction,
    this.partner,
    this.relativeTo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final t = transaction;
    final accounts = ref.watch(accountsByIdProvider);
    final categories = ref.watch(categoriesByIdProvider);
    String accountName(EntityId? id) => accounts[id]?.name ?? l.archivedAccount;

    final category = categories[t.categoryId];
    final Widget icon;
    final String title;
    final String subtitle;
    if (t.kind.isTransfer) {
      final out = t.kind == TransactionKind.transferOut ? t : partner;
      final into = t.kind == TransactionKind.transferIn ? t : partner;
      icon = const CategoryIcon.neutral(iconKey: 'transfer');
      title = out != null && into != null
          ? '${accountName(out.accountId)} → ${accountName(into.accountId)}'
          : l.transfer;
      subtitle = [?category?.name, ?t.note].join(', ');
    } else if (t.kind == TransactionKind.adjustment) {
      icon = const CategoryIcon.neutral(iconKey: 'adjustment');
      title = l.adjustment;
      subtitle = accountName(t.accountId);
    } else {
      icon = CategoryIcon(
        iconKey: category?.icon ?? 'dots',
        colorIndex: category?.colorIndex ?? 6,
      );
      title = category?.name ?? '';
      subtitle = [accountName(t.accountId), ?t.note].join(', ');
    }
    final amount = signedAmount(t, relativeTo: relativeTo);
    final isIncome =
        t.kind == TransactionKind.income ||
        (relativeTo == null && t.reportEffect == ReportEffect.income);
    final amountColor =
        t.kind.isTransfer || t.kind == TransactionKind.adjustment
        ? c.textSecondary
        : isIncome
        ? c.positive
        : c.textPrimary;

    return Semantics(
      button: true,
      label: [title, subtitle, amount].where((s) => s.isNotEmpty).join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => context.push(AppRoutes.operation(t.id)),
        child: _AmountRow(
          minHeight: AppSpacing.rowTwoLine,
          icon: icon,
          title: title,
          subtitle: subtitle.isEmpty ? null : subtitle,
          amount: amount,
          amountColor: amountColor,
        ),
      ),
    );
  }
}

/// Строка «иконка — название и подпись — сумма справа». При крупном шрифте (≥ 150%)
/// сумма уходит отдельной строкой под название: суммы не обрезаются (§0.2).
class _AmountRow extends StatelessWidget {
  final double minHeight;
  final Widget icon;
  final String title;
  final String? subtitle;
  final String amount;
  final Color amountColor;
  final bool chevron;

  const _AmountRow({
    required this.minHeight,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    this.chevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final large = isLargeText(context);
    final amountText = Text(
      amount,
      style: AppTypography.callout.copyWith(
        color: amountColor,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            icon,
            const SizedBox(width: AppSpacing.rowGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.callout.copyWith(color: c.textPrimary),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.footnote.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  if (large) amountText,
                ],
              ),
            ),
            if (!large) ...[const SizedBox(width: 8), amountText],
            if (chevron)
              Icon(AppIcons.chevron, color: c.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Строка счёта: иконка цвета счёта, название, баланс в своей валюте.
class AccountRow extends StatelessWidget {
  final AccountWithBalance item;
  final VoidCallback? onTap;
  final String? subtitle;

  const AccountRow({super.key, required this.item, this.onTap, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = item.account;
    final balance = item.balance.format();
    return Semantics(
      button: onTap != null,
      label: '${a.name}, $balance',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: _AmountRow(
          minHeight: 52,
          icon: CategoryIcon(iconKey: a.icon, colorIndex: a.colorIndex),
          title: a.name,
          subtitle: subtitle,
          amount: balance,
          amountColor: c.textPrimary,
          chevron: onTap != null,
        ),
      ),
    );
  }
}
