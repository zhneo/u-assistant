import 'package:material_ui/material_ui.dart';

import '../icons/app_icons.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Группа строк формы (DESIGN_SYSTEM §8.10): `surfaceGrouped`, радиус 12,
/// внутренние разделители начинаются от текста. Без теней.
class FormGroup extends StatelessWidget {
  final List<Widget> children;
  final String? footer;
  final bool footerIsError;

  const FormGroup({
    super.key,
    required this.children,
    this.footer,
    this.footerIsError = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Divider(color: c.separator),
          ),
        );
      }
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusGroup),
          child: ColoredBox(
            color: c.surfaceGrouped,
            child: Column(children: rows),
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Text(
              footer!,
              style: AppTypography.footnote.copyWith(
                color: footerIsError ? c.danger : c.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Строка формы (DESIGN_SYSTEM §8.4): название слева, значение справа серым и шеврон.
class FormRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? labelColor;

  const FormRow({
    super.key,
    required this.label,
    this.value,
    this.leading,
    this.trailing,
    this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: onTap != null,
      label: value == null ? label : '$label, $value',
      excludeSemantics: trailing == null,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.rowGap),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.body.copyWith(
                      color: labelColor ?? c.textPrimary,
                    ),
                  ),
                ),
                if (value != null)
                  Flexible(
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      style: AppTypography.body.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ?trailing,
                if (onTap != null && trailing == null)
                  Icon(AppIcons.chevron, color: c.textTertiary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
