import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../l10n/app_localizations.dart';

/// SCR-20 «Дела» — заглушка этапа 7. Полная версия — веха M2.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LargeTitleScaffold(
      title: l.tabTasks,
      children: [
        EmptyState(title: l.tasksEmptyTitle, message: l.tasksEmptyMessage),
      ],
    );
  }
}
