import 'package:material_ui/material_ui.dart';

/// Шкала шрифтов (DESIGN_SYSTEM §3.2). Шрифт системный: SF Pro на iOS, Roboto на Android
/// (D-019), поэтому `fontFamily` не задаётся. Системное увеличение шрифта работает само.
abstract final class AppTypography {
  static const _tabular = [FontFeature.tabularFigures()];

  static const largeTitle = TextStyle(
    fontSize: 34,
    height: 41 / 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.68,
  );
  static const title2 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
  );
  static const title3 = TextStyle(
    fontSize: 20,
    height: 25 / 20,
    fontWeight: FontWeight.w700,
  );
  static const headline = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
  );
  static const callout = TextStyle(
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w400,
  );
  static const subhead = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
  );
  static const footnote = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );
  static const caption = TextStyle(
    fontSize: 11,
    height: 13 / 11,
    fontWeight: FontWeight.w500,
  );

  /// Суммы — табличные цифры, чтобы не «прыгали» при изменении (DESIGN_SYSTEM §3.2).
  static const amountXL = TextStyle(
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.96,
    fontFeatures: _tabular,
  );
  static const amountL = TextStyle(
    fontSize: 30,
    height: 36 / 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    fontFeatures: _tabular,
  );
  static const amountM = TextStyle(
    fontSize: 24,
    height: 29 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.24,
    fontFeatures: _tabular,
  );
}

/// Отступы и размеры (DESIGN_SYSTEM §4–§5). Шаг — 4 pt.
abstract final class AppSpacing {
  static const screenH = 20.0;
  static const sectionGap = 24.0;
  static const rowMin = 44.0;
  static const rowTwoLine = 56.0;
  static const rowGap = 12.0;
  static const groupGap = 16.0;
  static const iconTextGap = 10.0;

  static const radiusIconSmall = 8.0;
  static const radiusIconLarge = 12.0;
  static const radiusGroup = 12.0;
  static const hairline = 0.5;
}
