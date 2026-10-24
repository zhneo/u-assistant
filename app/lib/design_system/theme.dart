import 'package:material_ui/material_ui.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_typography.dart';

/// Темы приложения (DESIGN_SYSTEM §2, §12). Тёмная тема — отдельные значения, а не инверсия.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: const Color(0xFFFFFFFF),
      secondary: c.accent,
      onSecondary: const Color(0xFFFFFFFF),
      error: c.danger,
      onError: const Color(0xFFFFFFFF),
      surface: c.bg,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      outline: c.separator,
      outlineVariant: c.separator,
      surfaceContainerHighest: c.fill,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      splashFactory: NoSplash.splashFactory,
      highlightColor: c.pressed,
      dividerTheme: DividerThemeData(
        color: c.separator,
        thickness: AppSpacing.hairline,
        space: AppSpacing.hairline,
      ),
      textTheme: TextTheme(
        displaySmall: AppTypography.largeTitle,
        headlineSmall: AppTypography.title2,
        titleLarge: AppTypography.title3,
        titleMedium: AppTypography.headline,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.subhead,
        bodySmall: AppTypography.footnote,
        labelSmall: AppTypography.caption,
      ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary),
      extensions: [c],
    );
  }
}
