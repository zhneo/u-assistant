/// Проба P1: функция из чистого Dart, которую использует Flutter-приложение.
/// Заодно — нормализация для поиска из решения D-043.
library;

String normalizeForSearch(String input) =>
    input.replaceAll('ё', 'е').replaceAll('Ё', 'Е').toLowerCase();
