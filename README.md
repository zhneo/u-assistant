# U-Assistant

Личное мобильное приложение для задач, целей, привычек, денег и заметок. Данные хранятся только на устройстве. Голосовой ввод: несколько записей за одну фразу, сохранение только после проверки.

**Статус:** этап 7 — каркас приложения: четыре вкладки, шифрованная база, дизайн-система, CI. Функций для данных пока нет.

## Документация
Вся проектная документация — в [`docs/`](docs/). Начните с:
- [REQUIREMENTS.md](docs/REQUIREMENTS.md) — что делает приложение;
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — как устроен код;
- [ROADMAP.md](docs/ROADMAP.md) — план и текущая веха;
- [DECISIONS.md](docs/DECISIONS.md) — журнал решений.

Правила для ИИ-инструментов — [CLAUDE.md](CLAUDE.md).

## Структура
```
u-assistant/
├── docs/            проектная документация
├── probes/          технические пробы этапа 7 (временные эксперименты)
├── packages/core/   чистый Dart: Money, Currency, Result, Clock, идентификаторы
├── app/             Flutter-приложение
│   ├── lib/design_system/  токены и компоненты
│   ├── lib/features/       экраны по разделам
│   ├── lib/data/           база drift (шифрование sqlite3mc)
│   ├── lib/platform/       обёртки над ОС (хранилище ключей)
│   └── drift_schemas/      снимки схемы БД
├── tool/            служебные скрипты (проверка архитектуры)
└── .github/workflows/ CI
```

Команды сборки и проверок — в [CLAUDE.md](CLAUDE.md#команды).

## Требования к окружению
- Flutter (stable) — проверка: `flutter doctor`.
- Android SDK и эмулятор.
- Для iOS: сборка в Codemagic, установка на iPhone через Sideloadly (`docs/TECH_RESEARCH.md` §6).
