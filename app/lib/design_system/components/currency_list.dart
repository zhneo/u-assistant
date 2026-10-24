import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/currency_names.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Список валют с поиском по коду и названию (SCR-02, SCR-35).
/// Тенге закреплён сверху; выбранная валюта отмечена галочкой и озвучивается «выбрано».
class CurrencyList extends StatefulWidget {
  final Currency selected;
  final ValueChanged<Currency> onSelected;
  final String searchHint;

  /// Заголовок над списком — прокручивается вместе с ним (важно при крупном шрифте).
  final Widget? header;

  const CurrencyList({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.searchHint,
    this.header,
  });

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final q = normalizeForSearch(_query.trim());
    final all = [Currency.kzt, ...Currency.all.where((x) => x != Currency.kzt)];
    final items = q.isEmpty
        ? all
        : all
              .where(
                (x) =>
                    normalizeForSearch(x.code).contains(q) ||
                    normalizeForSearch(currencyName(x.code)).contains(q),
              )
              .toList();
    final search = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        style: AppTypography.body.copyWith(color: c.textPrimary),
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: AppTypography.body.copyWith(color: c.textSecondary),
          prefixIcon: Icon(Icons.search, color: c.textSecondary),
          filled: true,
          fillColor: c.fill,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
    // Шапка и поиск — первыми элементами списка: прокручиваются вместе с валютами.
    final lead = [?widget.header, search];
    return ListView.builder(
      itemCount: lead.length + items.length,
      itemBuilder: (context, index) {
        if (index < lead.length) return lead[index];
        final x = items[index - lead.length];
        final selected = x == widget.selected;
        return Semantics(
          selected: selected,
          button: true,
          child: InkWell(
            onTap: () => widget.onSelected(x),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        x.code,
                        style: AppTypography.headline.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        currencyName(x.code),
                        style: AppTypography.body.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                    if (selected) Icon(Icons.check, color: c.accent, size: 22),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
