import 'package:material_ui/material_ui.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// SH-01 «Добавить» — каркас этапа 7: список типов строками (UI_SPECIFICATION SH-01).
/// Формы появятся в вехах M1 (расход, доход, перевод), M2 (задача), M5 (заметка), M6 (голос).
Future<void> showQuickAddSheet(BuildContext context) {
  final l = AppLocalizations.of(context);
  final c = context.colors;
  final items = <(IconData, String, Color, String)>[
    (Icons.south, l.addExpense, c.categoryColor(0), 'M1'),
    (Icons.north, l.addIncome, c.positive, 'M1'),
    (Icons.swap_horiz, l.addTransfer, c.categoryColor(3), 'M1'),
    (Icons.check, l.addTask, c.accent, 'M2'),
    (Icons.notes, l.addNote, c.categoryColor(4), 'M5'),
    (Icons.mic_none, l.addVoice, c.categoryColor(1), 'M6'),
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
                for (final (icon, label, color, milestone) in items)
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
                    subtitle: Text(
                      l.comingInMilestone(milestone),
                      style: AppTypography.footnote.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
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
