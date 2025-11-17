import '../services/secure_storage_service.dart';

class ApiKeyManager {
  static const _chemKey = 'CHEMISTRY_API_KEY';
  final SecureStorageService _storage;

  ApiKeyManager(this._storage);

  Future<void> saveChemistryKey(String key) async => await _storage.write(_chemKey, key);
  Future<String?> readChemistryKey() async => await _storage.read(_chemKey);
  Future<void> deleteChemistryKey() async => await _storage.delete(_chemKey);
}