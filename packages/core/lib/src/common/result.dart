import 'app_failure.dart';

/// Результат операции, которая может завершиться ожидаемой ошибкой (ARCHITECTURE §9).
///
/// Ожидаемые ошибки (пустая сумма, нет курса) — это значения, а не исключения.
/// Исключения остаются для настоящих аварий и ловятся на границе приложения.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;

  /// Значение или исключение [StateError], если результат — ошибка.
  /// Использовать только там, где ошибка уже проверена.
  T get value => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>(:final failure) => throw StateError('Result is Err: $failure'),
  };

  R fold<R>(R Function(T value) onOk, R Function(AppFailure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };
}

final class Ok<T> extends Result<T> {
  @override
  final T value;
  const Ok(this.value);

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

final class Err<T> extends Result<T> {
  final AppFailure failure;
  const Err(this.failure);

  @override
  bool operator ==(Object other) => other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}
