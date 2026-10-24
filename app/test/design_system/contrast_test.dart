import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:u_assistant/design_system/tokens/app_colors.dart';

/// Контраст по формуле WCAG 2.x (DESIGN_SYSTEM §2.1, TESTING_STRATEGY §3.8).
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) =>
        v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final l1 = lum(a), l2 = lum(b);
  return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);
}

void main() {
  for (final (name, c) in [
    ('светлая', AppColors.light),
    ('тёмная', AppColors.dark),
  ]) {
    group('Тема $name', () {
      final meaningful = {
        'textPrimary': c.textPrimary,
        'textSecondary': c.textSecondary,
        'accent': c.accent,
        'danger': c.danger,
        'positive': c.positive,
        'warning': c.warning,
      };
      meaningful.forEach((token, color) {
        test('$token ≥ 4,5:1 на bg и на surfaceGrouped', () {
          expect(contrast(color, c.bg), greaterThanOrEqualTo(4.5));
          expect(contrast(color, c.surfaceGrouped), greaterThanOrEqualTo(4.5));
        });
      });

      test('текст на заливке основной кнопки ≥ 4,5:1', () {
        expect(
          contrast(c.onAccentFill, c.accentFill),
          greaterThanOrEqualTo(4.5),
        );
      });

      test('заливка кнопки отличима от фона ≥ 3:1 (NFR-A11Y-01)', () {
        expect(contrast(c.accentFill, c.bg), greaterThanOrEqualTo(3.0));
      });

      test('в палитре 6 цветов категорий + «Другое»', () {
        expect(c.category, hasLength(7));
      });
    });
  }
}
