import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/category_icon.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Листы выбора категории и счёта (SH-02 «Все», «Счёт»). Системный лист со свайпом вниз.

Future<T?> _sheet<T>(
  BuildContext context, {
  required String title,
  required List<Widget> Function(BuildContext) rows,
}) {
  final c = context.colors;
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: c.surfaceGrouped,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              8,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.headline.copyWith(color: c.textPrimary),
              ),
            ),
          ),
          Flexible(child: ListView(shrinkWrap: true, children: rows(context))),
        ],
      ),
    ),
  );
}

Widget _row(
  BuildContext context, {
  required Widget leading,
  required String title,
  String? trailing,
  bool selected = false,
  bool indent = false,
  required VoidCallback onTap,
}) {
  final c = context.colors;
  return Semantics(
    selected: selected,
    button: true,
    child: InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenH + (indent ? 28 : 0),
            6,
            AppSpacing.screenH,
            6,
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: c.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: AppTypography.subhead.copyWith(
                    color: c.textSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check, color: c.accent, size: 22),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

/// Категории типа [kind] деревом: верхний уровень и подкатегории с отступом.
Future<Category?> showCategoryPicker(
  BuildContext context, {
  required List<Category> categories,
  required CategoryKind kind,
  EntityId? selected,
}) {
  final l = AppLocalizations.of(context);
  final ofKind = categories.where((c) => c.kind == kind && !c.hidden).toList();
  final top = ofKind.where((c) => c.isTopLevel).toList();
  return _sheet<Category>(
    context,
    title: l.chooseCategory,
    rows: (context) => [
      for (final parent in top) ...[
        _row(
          context,
          leading: CategoryIcon(
            iconKey: parent.icon,
            colorIndex: parent.colorIndex,
          ),
          title: parent.name,
          selected: parent.id == selected,
          onTap: () => Navigator.pop(context, parent),
        ),
        for (final child in ofKind.where((c) => c.parentId == parent.id))
          _row(
            context,
            leading: CategoryIcon(
              iconKey: child.icon,
              colorIndex: child.colorIndex,
            ),
            title: child.name,
            indent: true,
            selected: child.id == selected,
            onTap: () => Navigator.pop(context, child),
          ),
      ],
    ],
  );
}

/// Счета с балансами (SH-02 «Счёт», SH-03 «Откуда / Куда»).
Future<Account?> showAccountPicker(
  BuildContext context, {
  required List<AccountWithBalance> accounts,
  EntityId? selected,
}) {
  final l = AppLocalizations.of(context);
  return _sheet<Account>(
    context,
    title: l.chooseAccount,
    rows: (context) => [
      for (final a in accounts)
        _row(
          context,
          leading: CategoryIcon(
            iconKey: a.account.icon,
            colorIndex: a.account.colorIndex,
          ),
          title: a.account.name,
          trailing: a.balance.format(),
          selected: a.account.id == selected,
          onTap: () => Navigator.pop(context, a.account),
        ),
    ],
  );
}
