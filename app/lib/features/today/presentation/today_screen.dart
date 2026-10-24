import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/clock_provider.dart';

/// SCR-10 «Сегодня» — заглушка этапа 7. Полная версия — веха M2 (UI_SPECIFICATION SCR-10).
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = ref.watch(clockProvider).now();
    final date = toBeginningOfSentenceCase(
      DateFormat('EEEE, d MMMM', 'ru').format(now),
    );
    return LargeTitleScaffold(
      title: l.tabToday,
      subtitle: date,
      actions: [
        IconButton(
          onPressed: () {},
          tooltip: l.actionSearch,
          icon: Icon(Icons.search, color: context.colors.accent),
        ),
        IconButton(
          onPressed: () {},
          tooltip: l.actionSettings,
          icon: Icon(Icons.more_horiz, color: context.colors.accent),
        ),
      ],
      children: [
        EmptyState(title: l.todayEmptyTitle, message: l.todayEmptyMessage),
      ],
    );
  }
}
