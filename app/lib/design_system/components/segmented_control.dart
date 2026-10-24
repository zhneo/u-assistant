import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Сегментированный переключатель (DESIGN_SYSTEM §8.8): дорожка `fill`,
/// выбранный сегмент — фон экрана с лёгкой тенью и полужирный текст. 2–4 сегмента.
class SegmentedControl<T> extends StatelessWidget {
  final List<(T, String)> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          for (final (value, label) in segments)
            Expanded(
              child: Semantics(
                button: true,
                selected: value == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(value),
                  // Капсула 44 + отступы по 2 = зона нажатия 48 dp (NFR-A11Y-03).
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    margin: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: value == selected
                        ? BoxDecoration(
                            // В тёмной теме выбранный сегмент — #636366 (§8.8).
                            color: dark ? c.textTertiary : c.bg,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: dark
                                ? null
                                : const [
                                    BoxShadow(
                                      color: Color(0x1F000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                          )
                        : null,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.footnote.copyWith(
                        color: c.textPrimary,
                        fontWeight: value == selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
