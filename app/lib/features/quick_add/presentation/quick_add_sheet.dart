import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/routes.dart';

/// SH-01 «Добавить»: список типов строками (UI_SPECIFICATION SH-01).
/// Расход, доход и перевод — веха M1; задача — M2, заметка — M5, голос — M6.
Future<void> showQuickAddSheet(BuildContext context) {
  final l = AppLocalizations.of(context);
  final c = context.colors;
  final router = GoRouter.of(context);
  // Тип записи → адрес формы; null — тип появится в более поздней вехе.
  final items = <(IconData, String, Color, String, TransactionKind?)>[
    (
      Icons.south,
      l.addExpense,
      c.categoryColor(0),
      '',
      TransactionKind.expense,
    ),
    (Icons.north, l.addIncome, c.positive, '', TransactionKind.income),
    (
      Icons.swap_horiz,
      l.addTransfer,
      c.categoryColor(3),
      '',
      TransactionKind.transferOut,
    ),
    (Icons.check, l.addTask, c.accent, 'M2', null),
    (Icons.notes, l.addNote, c.categoryColor(4), 'M5', null),
    (Icons.mic_none, l.addVoice, c.categoryColor(1), 'M6', null),
  ];
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    // Список прокручивается, если не помещается (маленький экран, крупный шрифт).
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
    ),
    backgroundColor: c.surfaceGrouped,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.addSheetTitle,
                    style: AppTypography.headline.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l.close,
                    style: AppTypography.body.copyWith(color: c.accent),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final (icon, label, color, milestone, kind) in items)
                  ListTile(
                    minTileHeight: AppSpacing.rowMin,
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusIconSmall,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFFFFFFFF),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      label,
                      style: AppTypography.body.copyWith(color: c.textPrimary),
                    ),
                    subtitle: milestone.isEmpty
                        ? null
                        : Text(
                            l.comingInMilestone(milestone),
                            style: AppTypography.footnote.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                    onTap: () {
                      Navigator.pop(context);
                      if (kind != null) {
                        router.push(AppRoutes.newOperation(kind));
                      }
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
