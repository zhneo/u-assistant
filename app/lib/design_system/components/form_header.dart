import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Шапка листа или формы (DESIGN_SYSTEM §8.1): «Отмена» слева, заголовок по центру,
/// «Готово» справа. «Готово» неактивна, пока не заполнено обязательное поле.
/// Как в навигационной панели iOS, текст здесь растёт не больше чем в 1,4 раза:
/// иначе при шрифте 200% кнопки не помещаются (найдено тестом шрифта).
class FormHeader extends StatelessWidget {
  final String title;
  final String cancelLabel;
  final String doneLabel;
  final VoidCallback onCancel;
  final VoidCallback? onDone;

  const FormHeader({
    super.key,
    required this.title,
    required this.cancelLabel,
    required this.doneLabel,
    required this.onCancel,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Row(
          children: [
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: Text(
                cancelLabel,
                style: AppTypography.body.copyWith(color: c.accent),
              ),
            ),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headline.copyWith(color: c.textPrimary),
                ),
              ),
            ),
            TextButton(
              onPressed: onDone,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: Text(
                doneLabel,
                style: AppTypography.headline.copyWith(
                  color: onDone == null ? c.textTertiary : c.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
