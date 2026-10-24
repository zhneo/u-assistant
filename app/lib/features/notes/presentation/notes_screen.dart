import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../l10n/app_localizations.dart';

/// SCR-50 «Заметки» — заглушка этапа 7. Полная версия — веха M5.
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LargeTitleScaffold(
      title: l.tabNotes,
      children: [
        EmptyState(title: l.notesEmptyTitle, message: l.notesEmptyMessage),
      ],
    );
  }
}
