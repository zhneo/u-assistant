import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Крупная сумма при вводе (DESIGN_SYSTEM §8.11): `amountXL` по центру, пока ноль —
/// `textTertiary`. При калькуляции под ней строка «= итог». Длинная сумма уменьшается,
/// а не обрезается.
class AmountDisplay extends StatelessWidget {
  /// Набранное выражение: «3 500», «1 000 + 500».
  final String expression;
  final String symbol;
  final bool isZero;

  /// «= 1 500 ₸» — только если в выражении есть действие калькулятора.
  final String? totalLine;

  /// Подпись для диктора: «3 500 тенге».
  final String semanticsLabel;
  final bool active;
  final VoidCallback? onTap;

  const AmountDisplay({
    super.key,
    required this.expression,
    required this.symbol,
    required this.isZero,
    required this.semanticsLabel,
    this.totalLine,
    this.active = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticsLabel,
      selected: active,
      button: onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$expression $symbol',
                  maxLines: 1,
                  style: AppTypography.amountXL.copyWith(
                    color: isZero || !active ? c.textTertiary : c.textPrimary,
                  ),
                ),
              ),
              if (totalLine != null)
                Text(
                  totalLine!,
                  style: AppTypography.subhead.copyWith(
                    color: c.textSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
