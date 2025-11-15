import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';

class AuthService {
  // Cambia esta URL por la de tu backend cuando esté listo
  final String baseUrl = 'http://10.0.2.2:8080/api/auth'; // 10.0.2.2 para emulador android
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String> login(LoginRequest req) async {
    // ====== USUARIOS DUMMY TEMPORALES ======
    final dummyUsers = {
      "admin": "123456",
      "samir": "samir123",
      "paqueteria": "envios2025"
    };

    // Validar si el usuario existe
    if (!dummyUsers.containsKey(req.username)) {
      throw Exception("El usuario no existe");
    }

    // Validar contraseña
    if (dummyUsers[req.username] != req.password) {
      throw Exception("Contraseña incorrecta");
    }

    // Simular token
    final token = "dummy-token-${req.username}";

    await saveToken(token);

    return token;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }
}
