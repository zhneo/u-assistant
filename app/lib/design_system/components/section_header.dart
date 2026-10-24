import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Заголовок раздела в списке (DESIGN_SYSTEM §8.3): title3, слева; справа — необязательная
/// текстовая кнопка. Без счётчиков-«пилюль» и надписей заглавными (§15).
class SectionHeader extends StatelessWidget {
  final String title;
  final bool danger;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader(
    this.title, {
    super.key,
    this.danger = false,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sectionGap, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.title3.copyWith(
                  color: danger ? c.danger : c.textPrimary,
                ),
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: c.accent,
                minimumSize: const Size(44, 44),
              ),
              child: Text(actionLabel!, style: AppTypography.subhead),
            ),
        ],
      ),
    );
  }
}
