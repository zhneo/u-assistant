/// Одна транзакция базы для многошагового изменения (ARCHITECTURE §5, NFR-REL-01).
///
/// Сценарий оборачивает все записи в [run]: при любом исключении изменения откатываются
/// целиком — перевод не может сохраниться «наполовину».
abstract interface class UnitOfWork {
  Future<T> run<T>(Future<T> Function() action);
}
