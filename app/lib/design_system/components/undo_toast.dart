import 'package:material_ui/material_ui.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Всплывающее сообщение «Отменить» (DESIGN_SYSTEM §8.14): тёмная капсула над нижней
/// панелью, живёт 5 с, не забирает фокус. [messenger] берётся до закрытия формы,
/// чтобы сообщение показалось уже на экране под ней.
void showUndoToast(
  ScaffoldMessengerState messenger,
  AppColors colors, {
  required String message,
  String? undoLabel,
  VoidCallback? onUndo,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        backgroundColor: colors.toastBackground,
        shape: const StadiumBorder(),
        content: Text(
          message,
          style: AppTypography.subhead.copyWith(color: colors.onToast),
        ),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: undoLabel!,
                textColor: colors.onToast,
                onPressed: onUndo,
              ),
      ),
    );
}
