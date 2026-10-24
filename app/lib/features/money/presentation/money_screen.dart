import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/large_title_scaffold.dart';
import '../../../l10n/app_localizations.dart';

/// SCR-30 «Деньги» — заглушка этапа 7. Полная версия — веха M1.
class MoneyScreen extends StatelessWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LargeTitleScaffold(
      title: l.tabMoney,
      children: [
        EmptyState(title: l.moneyEmptyTitle, message: l.moneyEmptyMessage),
      ],
    );
  }
}
