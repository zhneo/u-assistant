import 'package:material_ui/material_ui.dart';

import '../icons/app_icons.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Иконка категории или счёта (DESIGN_SYSTEM §7): белая пиктограмма на квадрате цвета.
/// В строке — 30 pt (радиус 8, пиктограмма 18), в выборе — 44 pt (радиус 12, пиктограмма 22).
/// Скрыта от диктора: рядом всегда есть название (§0.2).
class CategoryIcon extends StatelessWidget {
  final String iconKey;
  final int colorIndex;
  final double size;

  /// Невыбранная категория в выборе — цветная пиктограмма на светлом фоне с рамкой.
  final bool outlined;

  const CategoryIcon({
    super.key,
    required this.iconKey,
    required this.colorIndex,
    this.size = 30,
    this.outlined = false,
  });

  /// Серая иконка для служебных операций (перевод, корректировка).
  const CategoryIcon.neutral({super.key, required this.iconKey, this.size = 30})
    : colorIndex = 6,
      outlined = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = c.categoryColor(colorIndex);
    final large = size >= 44;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: outlined ? c.surfaceGrouped : color,
          borderRadius: BorderRadius.circular(
            large ? AppSpacing.radiusIconLarge : AppSpacing.radiusIconSmall,
          ),
          border: outlined ? Border.all(color: c.separator) : null,
        ),
        child: Icon(
          AppIcons.of(iconKey),
          size: large ? 22 : 18,
          color: outlined ? color : c.onAccentFill,
        ),
      ),
    );
  }
}
