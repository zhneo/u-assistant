import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../design_system/components/app_tab_bar.dart';
import '../features/quick_add/presentation/quick_add_sheet.dart';
import '../l10n/app_localizations.dart';

/// Оболочка с нижней панелью. Каждая вкладка хранит свой стек (UI_SPECIFICATION §0.4).
class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: AppTabBar(
        currentIndex: shell.currentIndex,
        // Повторное нажатие на активную вкладку возвращает к её корню.
        onTabSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        addLabel: l.tabAdd,
        onAdd: () => showQuickAddSheet(context),
        tabs: [
          AppTabItem(
            label: l.tabToday,
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
          ),
          AppTabItem(
            label: l.tabTasks,
            icon: Icons.check_circle_outline,
            activeIcon: Icons.check_circle,
          ),
          AppTabItem(
            label: l.tabMoney,
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet,
          ),
          AppTabItem(
            label: l.tabNotes,
            icon: Icons.sticky_note_2_outlined,
            activeIcon: Icons.sticky_note_2,
          ),
        ],
      ),
    );
  }
}
