# Результаты технических проб этапа 7

> Окружение: Windows 11 25H2, Flutter 3.47.7 (stable), Dart 3.13.5, Visual Studio Community 2022.
> Тестовое устройство iOS: iPhone, iOS 18.7.1 (пробы P4, P5 — позже, на устройстве).
> Дата: 23.10.2026.

## Сводка
| Проба | Вопрос | Результат | Статус |
|---|---|---|---|
| **P1** | Flutter-приложение + пакет `core` в Dart workspace | Workspace собирается; `dart test` в `core` и интеграционный тест приложения на эмуляторе Android 14 зелёные | ✅ Пройдена (Android); iOS — сборка в Codemagic |
| **P2** | Шифрование SQLite3MultipleCiphers через `sqlite3` 3.x | Работает на Windows и **на Android**: ChaCha20, файл не читается без ключа, FTS5 доступен | ✅ Пройдена (Windows, Android); iOS — сборка в Codemagic |
| **P3** | FTS5 и кириллица | FTS5 есть; регистр кириллицы не важен; **«ё» и «е» — разные буквы** | ✅ Пройдена с оговоркой |
| **B1** | `VACUUM INTO` для снимка | Снимок создаётся и зашифрован тем же ключом | ✅ |
| **B2** | Перешифровка снимка (в открытый вид и новым ключом) | `PRAGMA rekey = ''` → открытый файл; `PRAGMA rekey = 'новый'` → зашифрован новым ключом | ✅ |
| **P6** | Скорость Argon2id, PBKDF2, AES-GCM | См. ниже | ✅ Базовый замер на ПК; калибровка — на телефоне |
| P4 | Уведомления по расписанию | — | iPhone / эмулятор, позже |
| P5 | Распознавание русского офлайн | — | iPhone / эмулятор, позже |
| **I1** | Работа без разрешения `INTERNET` | В release-APK с `sqlite3`, `path_provider` и `core` разрешения `INTERNET` нет | ✅ Для базового стека; проверять при каждом новом плагине (скрипт CI) |

## P1 (+ P2 на Android) — `probes/p1_workspace`
- Структура: корневой `pubspec.yaml` с `workspace: [packages/core, app]`. Хук `sqlite3: source: sqlite3mc` объявлен **в корне workspace**. В `app` — `resolution: workspace` и зависимость `core: path: ../packages/core`.
- Команды и результат:
  - `flutter pub get` в корне — зависимости разрешены одним lock-файлом;
  - `dart test` в `packages/core` — `All tests passed!`;
  - `flutter analyze` в `app` — без замечаний (после замены устаревшего `dispose()` на `close()` в `sqlite3` 3.x);
  - `flutter test integration_test/probe_test.dart -d emulator-5554` (Android 14, x86_64):
    ```
    PROBE_RESULT {platform: android, sqlite: 3.54.0, cipher: chacha20, headerPlain: false, openedWithoutKey: false, ftsHit: 1}
    00:02 +1: All tests passed!
    ```
- Первая сборка Gradle заняла ~11,5 мин: скачивались Gradle, Android NDK r28c и платформа 35 (подтянуты автоматически). Следующие сборки быстрее.
- Эмулятор: `ua_api34` (Pixel 6, Android 14, google_apis x86_64), аппаратное ускорение WHPX, загрузка ~44 с.

## P2/P3 — `probes/p2_p3_sqlite3mc`
Команда: `dart run bin/probe.dart`. Фактический вывод:
```
sqlite version: 3.54.0
cipher: [chacha20]
FTS5 в compile_options: true
P2 заголовок файла открытый (плохо): false
P2 без ключа не открывается (хорошо): file is not a database
P2 с ключом строк: 2
P3 MATCH "преподавателю" -> 1
P3 MATCH "ПРЕПОДАВАТЕЛЮ" -> 1
P3 MATCH "препод*" -> 1
P3 MATCH "еще" -> 0      ← в тексте «Ещё»
P3 MATCH "елку" -> 0     ← в тексте «ёлку»
P3 MATCH "ёлку" -> 1
B1 VACUUM INTO выполнен; снимок открытый: false
B1 снимок с тем же ключом, строк: 2
B2 rekey в открытый вид: заголовок открытый=true, строк без ключа=2
B2 повторное шифрование новым ключом, строк: 2
```

**Выводы:**
- Схема DATABASE §4.26 с FTS5 подтверждена. Запасной вариант с `LIKE` не нужен.
- Токенизатор `unicode61 remove_diacritics 2` **не** приравнивает «ё» к «е». Решение: перед записью в индекс и перед поиском текст нормализуется функцией `normalizeForSearch` (`ё→е`, `Ё→Е`). Она общая для индекса и запроса, живёт в `core`.
- Цепочка бэкапа BACKUP_AND_RESTORE §3 подтверждена: `VACUUM INTO` → копия → `rekey` в открытый вид (экспорт без пароля) или шифрование паролем; восстановление → `rekey` ключом нового устройства.
- Нативная библиотека собирается build hooks пакета `sqlite3` без ручной настройки (на Windows используется установленный Visual Studio).

## P6 — `probes/p6_argon2id`
Команда: `dart compile exe bin/probe.dart -o out/probe.exe && out\probe.exe` (AOT, как на телефоне). Фактический вывод:
```
Argon2id memory=19 МиБ iterations=2: 103 мс
Argon2id memory=32 МиБ iterations=3: 264 мс
Argon2id memory=64 МиБ iterations=3: 578 мс
PBKDF2-SHA256 600 000 итераций: 4692 мс
AES-256-GCM 20 МБ: шифрование 1629 мс, шифрование+расшифровка 3250 мс
```

**Выводы:**
- Телефон среднего класса медленнее ПК обычно в 3–5 раз [Гипотеза]. Тогда:
  - 64 МиБ / 3 итерации ≈ 2–3 с — выше цели 0,5–1,5 с;
  - 32 МиБ / 3 итерации ≈ 0,8–1,3 с — в цели.
  **Предварительно: 32 МиБ, 3 итерации, 1 поток.** Окончательно — замером на эмуляторе и iPhone. Параметры пишутся в манифест, поэтому их можно менять, не ломая старые копии.
- PBKDF2 в чистом Dart слишком медленный и при этом слабее Argon2id → не используем.
- AES-GCM в чистом Dart: 20 МБ ≈ 1,6 с на ПК. На телефоне без ускорения это может быть 5–8 с. Поэтому `cryptography_flutter` (нативный AES на Android и iOS) **обязателен**. Замер с ним — на устройстве. Требование NFR-PERF-06 (≤ 10 с с паролем) выглядит выполнимым.

## I1 — разрешения release-сборки
Команда: `flutter build apk --release`, затем `aapt2 dump permissions app-release.apk`. Фактический вывод:
```
package: kz.uassistant.probe_app
permission: kz.uassistant.probe_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION
uses-permission: name='kz.uassistant.probe_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION'
```
- `INTERNET` в release нет; служебное разрешение `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` добавляет AndroidX — оно внутреннее и безопасное. В debug-сборках Flutter добавляет `INTERNET` сам (для горячей перезагрузки) — это нормально и в release не попадает.
- **Размер:** универсальный APK — 47,9 МБ (в нём машинный код для трёх архитектур процессора). Для пользователя важен размер одной архитектуры: при публикации через App Bundle или при `--split-per-abi` он будет примерно втрое меньше. Цель NFR-PERF-07 (≤ 40 МБ) проверяется по APK одной архитектуры — замерить на этапе подготовки к выпуску.
