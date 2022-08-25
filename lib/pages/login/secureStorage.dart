import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  late final FlutterSecureStorage _storage;

  SecureStorage() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> saveUserData({
    required String name,
    required String email,
    required String imageURL,
  }) async {
    await _storage.write(
      key: 'user',
      value: jsonEncode({
        'name': name,
        'email': email,
        'imageURL': imageURL,
      }),
    );
  }

  Future<Map<String, String>?> getUserData() async {
    String? data = await _storage.read(key: 'user');
    if (data == null) return null;

    return Map<String, String>.from(jsonDecode(data));
  }

  Future<void> deleteUserData() async {
    await _storage.deleteAll();
  }
}