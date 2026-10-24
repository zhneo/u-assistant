import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Защищённое хранилище секретов (Keychain / Keystore) за интерфейсом (ARCHITECTURE §1.3),
/// чтобы сценарии и тесты не зависели от платформы.
abstract interface class SecureKeyStore {
  Future<String?> read(String name);
  Future<void> write(String name, String value);
  Future<void> delete(String name);
}

/// iOS: доступ «после первой разблокировки, только это устройство» — ключ не уезжает
/// в облачный бэкап и доступен фоновым задачам (DATA_SECURITY §3, D-032).
class FlutterSecureKeyStore implements SecureKeyStore {
  final FlutterSecureStorage _storage;

  FlutterSecureKeyStore()
    : _storage = const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  @override
  Future<String?> read(String name) => _storage.read(key: name);

  @override
  Future<void> write(String name, String value) =>
      _storage.write(key: name, value: value);

  @override
  Future<void> delete(String name) => _storage.delete(key: name);
}

/// Для тестов.
class InMemoryKeyStore implements SecureKeyStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String name) async => values[name];

  @override
  Future<void> write(String name, String value) async => values[name] = value;

  @override
  Future<void> delete(String name) async => values.remove(name);
}
