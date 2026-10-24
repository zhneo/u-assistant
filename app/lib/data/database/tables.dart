import 'package:drift/drift.dart';

/// `app_setting` (DATABASE §4.1): настройки «ключ — значение» в JSON.
/// Таблицы модуля «Деньги» — в `finance.drift` (D-058).
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  @override
  String get tableName => 'app_setting';

  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {key};
}
