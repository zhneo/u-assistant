import 'package:material_ui/material_ui.dart';

/// Крупный системный шрифт (≥ 150%): сводки и строки с суммой справа перестраиваются
/// в одну колонку, чтобы суммы не обрезались (UI_SPECIFICATION §0.2, NFR-A11Y-02).
bool isLargeText(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(10) >= 15;
