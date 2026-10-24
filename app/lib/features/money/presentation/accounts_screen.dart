import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/large_title_scaffold.dart';
import '../../../design_system/components/section_header.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routing/routes.dart';
import '../application/money_providers.dart';
import '../widgets/money_labels.dart';
import '../widgets/operation_list.dart';
import 'money_view_models.dart';

/// SCR-34 «Счета»: итог в базовой валюте и счета по группам типов.
/// Архивные — отдельным разделом внизу.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final active = ref.watch(activeAccountsProvider).value ?? const [];
    final archived = (ref.watch(allAccountsProvider).value ?? const <Account>[])
        .where((a) => a.isArchived)
        .toList();
    final total = ref.watch(totalBalanceProvider);

    return LargeTitleScaffold(
      title: l.accountsTitle,
      backLabel: l.tabMoney,
      actions: [
        IconButton(
          tooltip: l.addAccount,
          onPressed: () => context.push(AppRoutes.newAccount),
          icon: Icon(Icons.add, color: c.accent),
        ),
      ],
      children: [
        if (total != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              total.total.format(),
              style: AppTypography.amountL.copyWith(color: c.textPrimary),
            ),
          ),
        for (final group in AccountGroup.values)
          if (active.any((a) => accountGroupOf(a.account.type) == group)) ...[
            SectionHeader(accountGroupLabel(l, group)),
            for (final a in active)
              if (accountGroupOf(a.account.type) == group)
                AccountRow(
                  item: a,
                  subtitle: a.account.hidden ? l.accountHidden : null,
                  onTap: () => context.push(AppRoutes.account(a.account.id)),
                ),
          ],
        if (archived.isNotEmpty) ...[
          SectionHeader(l.accountArchivedSection),
          for (final a in archived)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                a.name,
                style: AppTypography.callout.copyWith(color: c.textSecondary),
              ),
              onTap: () => context.push(AppRoutes.account(a.id)),
            ),
        ],
      ],
    );
  }
}
