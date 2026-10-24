import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Экран первого уровня вкладки (DESIGN_SYSTEM §8.1): кнопки справа сверху,
/// крупный заголовок, необязательная подпись и содержимое списком.
/// Сворачивание заголовка при прокрутке и Android Top App Bar — в M1 (UI_SPECIFICATION §0.4).
class LargeTitleScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;

  const LargeTitleScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            8,
            AppSpacing.screenH,
            120,
          ),
          children: [
            SizedBox(
              height: 48, // зона нажатия ≥ 48 dp (NFR-A11Y-03)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
            Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.largeTitle.copyWith(color: c.textPrimary),
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  subtitle!,
                  style: AppTypography.subhead.copyWith(color: c.textSecondary),
                ),
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}
