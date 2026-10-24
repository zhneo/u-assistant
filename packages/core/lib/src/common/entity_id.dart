import 'package:uuid/uuid.dart';

/// Идентификатор записи — UUID v7 (D-027, DATABASE §1).
///
/// Создаётся на устройстве, уникален глобально и упорядочен по времени создания.
extension type const EntityId(String value) {
  static const _uuid = Uuid();

  factory EntityId.generate() => EntityId(_uuid.v7());

  /// Проверка формата (36 символов, версия 7) — для данных из бэкапа и импорта.
  static bool isValid(String s) =>
      s.length == 36 && Uuid.isValidUUID(fromString: s) && s[14] == '7';
}
