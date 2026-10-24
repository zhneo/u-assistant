import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'design_system/components/empty_state.dart';
import 'design_system/theme.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'services/onboarding.dart';

/// Маршрутизатор создаётся один раз; охранник читает актуальное значение онбординга,
/// а [ValueNotifier] заставляет его перепроверить адрес, когда значение меняется.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<bool>(
    ref.read(onboardingDoneProvider).value ?? false,
  );
  ref.listen(onboardingDoneProvider, (_, next) {
    if (next.hasValue) refresh.value = next.value!;
  });
  ref.onDispose(refresh.dispose);
  return buildRouter(onboardingDone: () => refresh.value, refresh: refresh);
});

/// Делегаты локализации. Переводы встроенных компонентов берутся из material_ui:
/// сгенерированный список `AppLocalizations.localizationsDelegates` ссылается на
/// flutter_localizations, с которым компоненты material_ui несовместимы (миграция Flutter 3.47).
const _delegates = <LocalizationsDelegate<Object?>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// Корневой виджет. Тема — как в системе (FR-SET-01; ручной выбор появится в настройках, M1).
class UAssistantApp extends ConsumerWidget {
  final bool startupFailed;
  const UAssistantApp({super.key, this.startupFailed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (startupFailed) {
      return MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: _delegates,
        home: const _StartupErrorScreen(),
      );
    }
    // Пока не известно, пройден ли онбординг, показываем пустой фон, а не мигающий экран.
    final onboarding = ref.watch(onboardingDoneProvider);
    if (!onboarding.hasValue) {
      return MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const Scaffold(body: SizedBox.shrink()),
      );
    }
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: _delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// Заглушка SCR-03 (восстановление после сбоя) — полная версия в вехе M3.
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: EmptyState(
            title: l.startupErrorTitle,
            message: l.startupErrorMessage,
          ),
        ),
      ),
    );
  }
}
