import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Экран первого уровня вкладки (DESIGN_SYSTEM §8.1): кнопки справа сверху,
/// крупный заголовок, необязательная подпись и содержимое.
///
/// [children] строятся сразу; длинный список (операции) передаётся в [sliver] и строится
/// лениво по мере прокрутки (NFR-PERF-03). Сворачивание заголовка при прокрутке
/// и Android Top App Bar — позже (UI_SPECIFICATION §0.4).
class LargeTitleScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;
  final Widget? sliver;

  /// Слева сверху — «‹ Назад» для экранов второго уровня (DESIGN_SYSTEM §8.1).
  final String? backLabel;
  final Color? background;

  const LargeTitleScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.children = const [],
    this.sliver,
    this.backLabel,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const h = EdgeInsets.symmetric(horizontal: AppSpacing.screenH);
    return Scaffold(
      backgroundColor: background ?? c.bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                8,
                AppSpacing.screenH,
                0,
              ),
              sliver: SliverList.list(
                children: [
                  SizedBox(
                    height: 48, // зона нажатия ≥ 48 dp (NFR-A11Y-03)
                    child: Row(
                      children: [
                        if (backLabel != null) _BackButton(label: backLabel!),
                        const Spacer(),
                        ...actions,
                      ],
                    ),
                  ),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: AppTypography.largeTitle.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: AppTypography.subhead.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  ...children,
                ],
              ),
            ),
            if (sliver != null) SliverPadding(padding: h, sliver: sliver),
            // Место под нижней панелью: содержимое не прячется за ней.
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final String label;
  const _BackButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextButton.icon(
      onPressed: () => Navigator.of(context).maybePop(),
      style: TextButton.styleFrom(
        foregroundColor: c.accent,
        padding: const EdgeInsets.only(right: 8),
        minimumSize: const Size(48, 48),
      ),
      icon: const Icon(Icons.chevron_left, size: 28),
      label: Text(label, style: AppTypography.body),
    );
  }
}
