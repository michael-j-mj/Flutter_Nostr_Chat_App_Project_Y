import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_secure_storage_model.dart';

class SecureStorageService implements ISecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorageService({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> read(String key) async {
    return (await _storage.read(key: key));
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
