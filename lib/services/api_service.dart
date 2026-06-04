import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.106:8000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Auth
  static Future<String?> login(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: await _headers(),
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10)); // timeout add করো

      print('Login status: ${res.statusCode}');
      print('Login body: ${res.body}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return null;
      }
      return jsonDecode(res.body)['message'];
    } catch (e) {
      print('Login error: $e'); // এটা দেখো console এ
      return 'Connection error: $e';
    }
  }

  static Future<String?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: await _headers(),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Register status: ${res.statusCode}');
      print('Register body: ${res.body}');

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return null;
      }
      return jsonDecode(res.body)['message'];
    } catch (e) {
      print('Register error: $e');
      return 'Connection error: $e';
    }
  }

  // Todos
  static Future<List> getTodos() async {
    final token = await getToken();
    print('Token: $token');
    final res = await http.get(
      Uri.parse('$baseUrl/todos'),
      headers: await _headers(auth: true),
    );
    print("Status: ${res.statusCode}, Body: ${res.body}");
    return jsonDecode(res.body);
  }

  static Future<void> logout() async {
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: await _headers(auth: true),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> addTodo(String title) async {
    await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: await _headers(auth: true),
      body: jsonEncode({'title': title}),
    );
  }

  static Future<void> toggleTodo(int id, bool isDone) async {
    await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: await _headers(auth: true),
      body: jsonEncode({'is_done': isDone}),
    );
  }

  static Future<void> deleteTodo(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: await _headers(auth: true),
    );
  }
}
