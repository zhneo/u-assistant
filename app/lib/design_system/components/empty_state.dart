import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Пустое состояние (DESIGN_SYSTEM §8.16): заголовок, одна строка пояснения,
/// одна текстовая кнопка. Слева по ширине текста, без иллюстраций.
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.title3.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: AppTypography.subhead.copyWith(color: c.textSecondary),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: c.accent,
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
              ),
              child: Text(actionLabel!, style: AppTypography.body),
            ),
        ],
      ),
    );
  }
}
