/// Ожидаемые ошибки приложения (ARCHITECTURE §9).
///
/// Текст для пользователя строится из варианта в одном месте приложения
/// (`failure_messages.dart`), а не здесь: ядро не знает языка интерфейса.
/// В `toString()` никогда не попадают пользовательские данные (DATA_SECURITY §7).
sealed class AppFailure {
  const AppFailure();
}

/// Нарушено правило ввода: пустое название, сумма 0 и т.п.
final class ValidationFailure extends AppFailure {
  final String field;
  final ValidationReason reason;
  const ValidationFailure(this.field, this.reason);

  @override
  bool operator ==(Object other) =>
      other is ValidationFailure &&
      other.field == field &&
      other.reason == reason;

  @override
  int get hashCode => Object.hash(field, reason);

  @override
  String toString() => 'ValidationFailure($field, ${reason.name})';
}

enum ValidationReason {
  required,
  mustBePositive,
  tooLong,
  invalidFormat,
  sameValue,
  outOfRange,
}

final class NotFoundFailure extends AppFailure {
  final String entityType;
  const NotFoundFailure(this.entityType);

  @override
  bool operator ==(Object other) =>
      other is NotFoundFailure && other.entityType == entityType;

  @override
  int get hashCode => entityType.hashCode;

  @override
  String toString() => 'NotFoundFailure($entityType)';
}

/// Действие противоречит существующим данным (счёт с операциями нельзя удалить без переноса).
final class ConflictFailure extends AppFailure {
  final ConflictReason reason;
  const ConflictFailure(this.reason);

  @override
  bool operator ==(Object other) =>
      other is ConflictFailure && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'ConflictFailure(${reason.name})';
}

enum ConflictReason {
  hasDependents,
  currencyLocked,
  alreadySaved,
  alreadyExists,
}

/// Нет курса валюты к базовой (REQUIREMENTS FR-FIN-16).
final class MissingRateFailure extends AppFailure {
  final String currencyCode;
  const MissingRateFailure(this.currencyCode);

  @override
  bool operator ==(Object other) =>
      other is MissingRateFailure && other.currencyCode == currencyCode;

  @override
  int get hashCode => currencyCode.hashCode;

  @override
  String toString() => 'MissingRateFailure($currencyCode)';
}

final class StorageFailure extends AppFailure {
  final StorageReason reason;
  const StorageFailure(this.reason);

  @override
  bool operator ==(Object other) =>
      other is StorageFailure && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'StorageFailure(${reason.name})';
}

enum StorageReason { diskFull, writeFailed, corrupted, keyUnavailable }

final class PermissionFailure extends AppFailure {
  final PermissionKind kind;
  const PermissionFailure(this.kind);

  @override
  bool operator ==(Object other) =>
      other is PermissionFailure && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;

  @override
  String toString() => 'PermissionFailure(${kind.name})';
}

enum PermissionKind {
  notifications,
  exactAlarms,
  microphone,
  speech,
  calendar,
  biometrics,
}

final class BackupFailure extends AppFailure {
  final BackupFailureReason reason;
  const BackupFailure(this.reason);

  @override
  bool operator ==(Object other) =>
      other is BackupFailure && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'BackupFailure(${reason.name})';
}

enum BackupFailureReason {
  notBackupFile,
  corrupted,
  newerVersion,
  wrongPassword,
  migrationFailed,
}

final class RecognitionUnavailableFailure extends AppFailure {
  const RecognitionUnavailableFailure();

  @override
  bool operator ==(Object other) => other is RecognitionUnavailableFailure;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'RecognitionUnavailableFailure()';
}
