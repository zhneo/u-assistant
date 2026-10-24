import 'package:material_ui/material_ui.dart';

/// Семантические цвета (DESIGN_SYSTEM §2.1). Компоненты используют только эти токены,
/// никогда сырые hex-значения. Значения и контраст проверены (DESIGN_SYSTEM §2.1, D-018).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color bgGrouped;
  final Color surfaceGrouped;
  final Color fill;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color separator;
  final Color accent;

  /// Заливка основных кнопок и значка «Добавить». Отдельно от [accent]: в тёмной теме
  /// светлый акцент #4A8BF5 даёт с белым текстом лишь 3,3:1 (найдено тестом контраста).
  final Color accentFill;
  final Color onAccentFill;
  final Color danger;
  final Color positive;
  final Color warning;
  final Color pressed;
  final Color barBackground;

  /// Своя цифровая клавиатура ввода суммы (UI_SPECIFICATION SH-02, DESIGN_SYSTEM §8.11).
  final Color keypadBackground;
  final Color keypadKey;

  /// Всплывающее сообщение «Отменить» — тёмная капсула в обеих темах (DESIGN_SYSTEM §8.14).
  final Color toastBackground;
  final Color onToast;

  /// Цвета категорий и проектов в порядке палитры (DESIGN_SYSTEM §2.2):
  /// оранжевый, фиолетовый, розовый, синий, жёлтый, бирюзовый; индекс 6 — «Другое».
  final List<Color> category;

  const AppColors({
    required this.bg,
    required this.bgGrouped,
    required this.surfaceGrouped,
    required this.fill,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.separator,
    required this.accent,
    required this.accentFill,
    required this.onAccentFill,
    required this.danger,
    required this.positive,
    required this.warning,
    required this.pressed,
    required this.barBackground,
    required this.keypadBackground,
    required this.keypadKey,
    required this.toastBackground,
    required this.onToast,
    required this.category,
  });

  static const light = AppColors(
    bg: Color(0xFFFFFFFF),
    bgGrouped: Color(0xFFF2F2F7),
    surfaceGrouped: Color(0xFFFFFFFF),
    fill: Color(0xFFEEEEF0),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF6C6C70),
    textTertiary: Color(0xFFAEAEB2),
    separator: Color(0xFFD1D1D6),
    accent: Color(0xFF2563D9),
    accentFill: Color(0xFF2563D9),
    onAccentFill: Color(0xFFFFFFFF),
    danger: Color(0xFFD70015),
    positive: Color(0xFF1A7F37),
    warning: Color(0xFF9A6200),
    pressed: Color(0xFFE5E5EA),
    barBackground: Color(0xF0F9F9F9),
    keypadBackground: Color(0xFFD1D3D9),
    keypadKey: Color(0xFFFFFFFF),
    toastBackground: Color(0xFF1C1C1E),
    onToast: Color(0xFFFFFFFF),
    category: [
      Color(0xFFF07B1D),
      Color(0xFF9B51E0),
      Color(0xFFE9457A),
      Color(0xFF2F7DE1),
      Color(0xFFE5A800),
      Color(0xFF14A3A8),
      Color(0xFF8E8E93),
    ],
  );

  static const dark = AppColors(
    bg: Color(0xFF000000),
    bgGrouped: Color(0xFF000000),
    surfaceGrouped: Color(0xFF1C1C1E),
    fill: Color(0xFF1C1C1E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAEAEB2),
    textTertiary: Color(0xFF636366),
    separator: Color(0xFF38383A),
    accent: Color(0xFF4A8BF5),
    accentFill: Color(0xFF2563D9),
    onAccentFill: Color(0xFFFFFFFF),
    danger: Color(0xFFFF5257),
    positive: Color(0xFF3DD068),
    warning: Color(0xFFFFB340),
    pressed: Color(0xFF2C2C2E),
    barBackground: Color(0xF0161618),
    keypadBackground: Color(0xFF2B2B2D),
    keypadKey: Color(0xFF5A5A5E),
    toastBackground: Color(0xFF3A3A3C),
    onToast: Color(0xFFFFFFFF),
    category: [
      Color(0xFFD9690F),
      Color(0xFF9B5DE5),
      Color(0xFFE0487A),
      Color(0xFF3B82E6),
      Color(0xFFB08400),
      Color(0xFF159DA2),
      Color(0xFF636366),
    ],
  );

  /// Цвет категории по индексу палитры (DATABASE: `color_index` 0–6).
  Color categoryColor(int index) =>
      category[index.clamp(0, category.length - 1)];

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) =>
      t < 0.5 ? this : (other ?? this);
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
