import 'package:go_router/go_router.dart';

import '../features/money/presentation/money_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/today/presentation/today_screen.dart';
import 'app_shell.dart';

/// Маршруты (ARCHITECTURE §4, D-024). Адреса читаемые — по ним будут открываться
/// экраны из уведомлений. Охранник блокировки и онбординга добавится в M1/M3.
abstract final class AppRoutes {
  static const today = '/today';
  static const tasks = '/tasks';
  static const money = '/money';
  static const notes = '/notes';
}

GoRouter buildRouter() => GoRouter(
  initialLocation: AppRoutes.today,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.today,
              builder: (_, _) => const TodayScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.tasks,
              builder: (_, _) => const TasksScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.money,
              builder: (_, _) => const MoneyScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notes,
              builder: (_, _) => const NotesScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
