import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Пункт нижней панели.
class AppTabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const AppTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

/// Нижняя панель (DESIGN_SYSTEM §8.2, D-015): 4 вкладки и центральное действие «Добавить».
/// Фон с размытием и разделителем сверху. Платформенная версия Android (M3 Navigation Bar) — в M1.
class AppTabBar extends StatelessWidget {
  final List<AppTabItem> tabs; // ровно 4: Сегодня, Дела, Деньги, Заметки
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final String addLabel;
  final VoidCallback onAdd;

  const AppTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.addLabel,
    required this.onAdd,
  }) : assert(tabs.length == 4);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget tab(int i) {
      final t = tabs[i];
      final active = i == currentIndex;
      // Неактивные — textSecondary: системный серый #8E8E93 даёт 3,1:1 и не проходит NFR-A11Y-01.
      final color = active ? c.accent : c.textSecondary;
      return Expanded(
        child: Semantics(
          selected: active,
          button: true,
          label: t.label,
          excludeSemantics: true,
          child: InkResponse(
            onTap: () => onTabSelected(i),
            child: _TabCell(
              icon: Icon(
                active ? t.activeIcon : t.icon,
                color: color,
                size: 26,
              ),
              label: t.label,
              color: color,
            ),
          ),
        ),
      );
    }

    // Подписи панели растут с системным шрифтом не больше чем в 1,2 раза — как в iOS:
    // иначе фиксированная по высоте панель ломается (найдено тестом шрифта 200%).
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.2,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: c.barBackground,
              border: Border(top: BorderSide(color: c.separator, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  tab(0),
                  tab(1),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: addLabel,
                      excludeSemantics: true,
                      child: InkResponse(
                        onTap: onAdd,
                        child: _TabCell(
                          icon: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c.accentFill,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: c.onAccentFill,
                              size: 22,
                            ),
                          ),
                          label: addLabel,
                          color: c.accent,
                        ),
                      ),
                    ),
                  ),
                  tab(2),
                  tab(3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ячейка панели: значок и подпись в одну строку. Высота не фиксируется жёстко
/// (минимум 50), чтобы подпись не обрезалась при увеличенном шрифте.
class _TabCell extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color color;
  const _TabCell({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
