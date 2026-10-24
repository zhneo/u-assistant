import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Подписи клавиш для экранного диктора (строки — из локализации).
class AmountKeypadLabels {
  final String backspace;
  final String calculator;
  final String plus;
  final String minus;
  final String times;
  final String divide;
  final String comma;

  const AmountKeypadLabels({
    required this.backspace,
    required this.calculator,
    required this.plus,
    required this.minus,
    required this.times,
    required this.divide,
    required this.comma,
  });

  factory AmountKeypadLabels.of(AppLocalizations l) => AmountKeypadLabels(
    backspace: l.keypadBackspace,
    calculator: l.keypadCalculator,
    plus: l.keypadPlus,
    minus: l.keypadMinus,
    times: l.keypadTimes,
    divide: l.keypadDivide,
    comma: l.keypadComma,
  );
}

/// Своя цифровая клавиатура ввода суммы (DESIGN_SYSTEM §8.11, UI_SPECIFICATION SH-02).
///
/// Отдаёт нажатия строками-ключами `AmountExpression`: цифры, `000`, `,`, `⌫`, `+ - * /`.
/// Долгое нажатие на «⌫» стирает всё ([onClear]). Кнопка «±×÷» показывает ряд действий
/// калькулятора (FR-FIN-06).
class AmountKeypad extends StatefulWidget {
  final ValueChanged<String> onKey;
  final VoidCallback onClear;
  final AmountKeypadLabels labels;

  /// Есть ли у валюты дробная часть — иначе клавиши «,» нет.
  final bool allowComma;

  const AmountKeypad({
    super.key,
    required this.onKey,
    required this.onClear,
    required this.labels,
    this.allowComma = true,
  });

  @override
  State<AmountKeypad> createState() => _AmountKeypadState();
}

class _AmountKeypadState extends State<AmountKeypad> {
  var _operators = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = widget.labels;

    Widget key(
      String label, {
      String? value,
      String? semantics,
      bool plain = false,
      int flex = 1,
      VoidCallback? onTap,
      VoidCallback? onLongPress,
    }) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Semantics(
          button: true,
          label: semantics ?? label,
          excludeSemantics: true,
          child: Material(
            color: plain ? Colors.transparent : c.keypadKey,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap:
                  onTap ??
                  () {
                    HapticFeedback.selectionClick();
                    widget.onKey(value ?? label);
                  },
              onLongPress: onLongPress,
              child: SizedBox(
                height: 46,
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.title2.copyWith(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return ColoredBox(
      color: c.keypadBackground,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 5, 3, 3),
          // Клавиши не растут с системным шрифтом: иначе клавиатура не поместится.
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_operators)
                  Row(
                    children: [
                      key('+', value: '+', semantics: l.plus),
                      key('−', value: '-', semantics: l.minus),
                      key('×', value: '*', semantics: l.times),
                      key('÷', value: '/', semantics: l.divide),
                    ],
                  ),
                Row(
                  children: [
                    key('1'),
                    key('2'),
                    key('3'),
                    key(
                      '⌫',
                      semantics: l.backspace,
                      plain: true,
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                        widget.onClear();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    key('4'),
                    key('5'),
                    key('6'),
                    key(
                      '±×÷',
                      semantics: l.calculator,
                      plain: true,
                      onTap: () => setState(() => _operators = !_operators),
                    ),
                  ],
                ),
                Row(
                  children: [
                    key('7'),
                    key('8'),
                    key('9'),
                    key('000', plain: true),
                  ],
                ),
                Row(
                  children: [
                    if (widget.allowComma)
                      key(',', semantics: l.comma, plain: true)
                    else
                      const Expanded(child: SizedBox()),
                    key('0', flex: 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
