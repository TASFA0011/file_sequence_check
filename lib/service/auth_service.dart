import 'dart:convert' show json;

import 'package:file_sequence_check/models/auth_data.dart';
import 'package:file_sequence_check/service/setup_locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static Future<void> registerAuthData(AuthData data) {
    locator.update(data);
    const storage = FlutterSecureStorage();
    return storage.write(
        key: 'auth_data_file_check', value: json.encode(data.toMap()));
  }

  /// Seulement utiliser au demarage
  /// `locator.get<AuthData>()` est utilise pour acceder au donnees d'authentification dans tous les autres cas
  static Future<AuthData?> getAuthData() async {
    const storage = FlutterSecureStorage();
    var value = await storage.read(key: 'auth_data_file_check');
    if (value == null) {
      return null;
    }
    return AuthData.fromJson(json.decode(value));
  }

  static Future<void> removeAuthData() {
    const storage = FlutterSecureStorage();
    return storage.delete(key: 'auth_data_file_check');
  }
}
