import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/auth_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  Future<AuthResponse?> login(String username, String password) async {
    try {
      final url = '${AppConfig.apiBaseUrl}/auth/login';
      print('[AuthService] Login URL: $url');
      print('[AuthService] Username: $username');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(AuthModel(
          username: username,
          password: password,
        ).toJson()),
      );

      print('[AuthService] Response status: ${response.statusCode}');
      print('[AuthService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        
        await _saveAuthData(authResponse);
        return authResponse;
      } else {
        print('[AuthService] Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[AuthService] Login error: $e');
      return null;
    }
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, authResponse.token);
    await prefs.setString(_usernameKey, authResponse.username);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }
}
