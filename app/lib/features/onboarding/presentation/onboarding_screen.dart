import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../design_system/components/amount_display.dart';
import '../../../design_system/components/amount_keypad.dart';
import '../../../design_system/components/currency_list.dart';
import '../../../design_system/components/primary_button.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/onboarding.dart';

/// SCR-02 Онбординг: 3 шага — валюта, наличные, приватность.
/// Без выбора валюты дальше пройти нельзя, остальное можно пропустить.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int? _step;
  var _currency = Currency.kzt;
  var _cash = const AmountExpression();
  var _busy = false;
  String? _error;

  OnboardingFlow get _flow => ref.read(onboardingFlowProvider);

  @override
  void initState() {
    super.initState();
    // Продолжаем с шага, на котором приложение закрыли (SCR-02 «Состояния»).
    _flow.currentStep().then((s) {
      if (mounted) setState(() => _step = s);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final step = _step;
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: step != OnboardingStep.cash,
        child: step == null
            ? const SizedBox.shrink()
            : switch (step) {
                OnboardingStep.currency => _currencyStep(context),
                OnboardingStep.cash => _cashStep(context),
                _ => _privacyStep(context),
              },
      ),
    );
  }

  Widget _dots(BuildContext context, int step) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      label: l.onboardingStepOf(step + 1, 3),
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == step ? c.accent : c.separator,
              ),
            ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, String title, String? hint) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTypography.largeTitle.copyWith(color: c.textPrimary),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            style: AppTypography.subhead.copyWith(color: c.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _currencyStep(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        16,
        AppSpacing.screenH,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CurrencyList(
              header: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _title(
                  context,
                  l.onboardingCurrencyTitle,
                  l.onboardingCurrencyHint,
                ),
              ),
              selected: _currency,
              searchHint: l.searchHint,
              onSelected: (x) => setState(() => _currency = x),
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.onboardingRestoreLater))),
            style: TextButton.styleFrom(
              foregroundColor: c.accent,
              minimumSize: const Size(48, 48),
              padding: EdgeInsets.zero,
            ),
            child: Text(l.onboardingRestore, style: AppTypography.body),
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            label: l.next,
            onPressed: _busy
                ? null
                : () => _run(() async {
                    await _flow.chooseCurrency(_currency);
                    if (mounted) setState(() => _step = OnboardingStep.cash);
                  }),
          ),
          const SizedBox(height: 12),
          _dots(context, OnboardingStep.currency),
        ],
      ),
    );
  }

  Widget _cashStep(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final amount = _cash.evaluate(_currency);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              16,
              AppSpacing.screenH,
              16,
            ),
            children: [
              _title(context, l.onboardingCashTitle, l.onboardingCashHint),
              const SizedBox(height: 24),
              AmountDisplay(
                expression: _cash.display(),
                symbol: _currency.symbol,
                isZero: amount == null || amount.isZero,
                semanticsLabel: (amount ?? Money.zero(_currency)).format(
                  withSymbol: true,
                ),
                totalLine: _cash.hasOperator && amount != null
                    ? l.amountTotal(amount.format())
                    : null,
              ),
              if (_error != null)
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppTypography.footnote.copyWith(color: c.danger),
                ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.onboardingCreateAccount,
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        final money = amount ?? Money.zero(_currency);
                        if (money.isNegative) {
                          setState(() => _error = l.amountInvalid);
                          return;
                        }
                        await _flow.createCashAccount(l.cashAccountName, money);
                        if (mounted) {
                          setState(() => _step = OnboardingStep.privacy);
                        }
                      }),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        await _flow.skipCashAccount();
                        if (mounted) {
                          setState(() => _step = OnboardingStep.privacy);
                        }
                      }),
                style: TextButton.styleFrom(
                  foregroundColor: c.accent,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(l.onboardingSkip, style: AppTypography.body),
              ),
              _dots(context, OnboardingStep.cash),
            ],
          ),
        ),
        AmountKeypad(
          labels: AmountKeypadLabels.of(l),
          allowComma: _currency.minorUnits > 0,
          onKey: (k) => setState(() => _cash = _cash.input(k, _currency)),
          onClear: () => setState(() => _cash = const AmountExpression()),
        ),
      ],
    );
  }

  Widget _privacyStep(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    Widget row(IconData icon, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Icon(icon, color: c.accent, size: 26)),
          const SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        16,
        AppSpacing.screenH,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                _title(context, l.onboardingPrivacyTitle, null),
                const SizedBox(height: 20),
                row(Icons.person_off_outlined, l.onboardingPrivacyNoSignup),
                row(Icons.save_alt_outlined, l.onboardingPrivacyBackup),
                row(Icons.phonelink_erase_outlined, l.onboardingPrivacyLoss),
              ],
            ),
          ),
          PrimaryButton(
            label: l.onboardingStart,
            onPressed: _busy ? null : () => _run(_flow.complete),
          ),
          const SizedBox(height: 12),
          _dots(context, OnboardingStep.privacy),
        ],
      ),
    );
  }
}
