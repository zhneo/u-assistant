import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/money/presentation/account_form_screen.dart';
import '../features/money/presentation/account_screen.dart';
import '../features/money/presentation/accounts_screen.dart';
import '../features/money/presentation/money_screen.dart';
import '../features/money/presentation/operation_screen.dart';
import '../features/money/presentation/transaction_form_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/today/presentation/today_screen.dart';
import 'app_shell.dart';
import 'routes.dart';

export 'routes.dart';

Page<void> _form(Widget child) =>
    MaterialPage<void>(fullscreenDialog: true, child: child);

/// Маршруты (ARCHITECTURE §4, D-024). [onboardingDone] читается при каждом переходе;
/// [refresh] сообщает, что значение изменилось. Охранник: пока онбординг не пройден,
/// любой адрес ведёт на SCR-02.
GoRouter buildRouter({
  required bool Function() onboardingDone,
  Listenable? refresh,
}) => GoRouter(
  initialLocation: AppRoutes.today,
  refreshListenable: refresh,
  redirect: (context, state) {
    final done = onboardingDone();
    final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
    if (!done && !atOnboarding) return AppRoutes.onboarding;
    if (done && atOnboarding) return AppRoutes.today;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.newAccount,
      pageBuilder: (_, _) => _form(const AccountFormScreen()),
    ),
    GoRoute(
      path: '/new/:kind',
      pageBuilder: (_, state) {
        final from = state.uri.queryParameters['from'];
        return _form(
          TransactionFormScreen(
            initialKind: TransactionKind.fromDb(state.pathParameters['kind']!),
            fromAccountId: from == null ? null : EntityId(from),
          ),
        );
      },
    ),
    GoRoute(
      path: '/edit/operation/:id',
      pageBuilder: (_, state) => _form(
        TransactionFormScreen.edit(EntityId(state.pathParameters['id']!)),
      ),
    ),
    GoRoute(
      path: '/edit/account/:id',
      pageBuilder: (_, state) => _form(
        AccountFormScreen(editId: EntityId(state.pathParameters['id']!)),
      ),
    ),
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
              routes: [
                GoRoute(
                  path: 'accounts',
                  builder: (_, _) => const AccountsScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) => AccountScreen(
                        accountId: EntityId(state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'operations/:id',
                  builder: (_, state) => OperationScreen(
                    operationId: EntityId(state.pathParameters['id']!),
                  ),
                ),
              ],
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
