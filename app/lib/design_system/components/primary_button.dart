import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Основная кнопка (DESIGN_SYSTEM §8.9): заливка `accentFill`, текст `onAccentFill`,
/// высота 50, радиус 12. Только когда на экране одно главное действие.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: c.accentFill,
          foregroundColor: c.onAccentFill,
          disabledBackgroundColor: c.fill,
          disabledForegroundColor: c.textSecondary,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: AppTypography.headline),
      ),
    );
  }
}
