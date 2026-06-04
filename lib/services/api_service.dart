import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // emulator এ

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
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return null; // success
    }
    return jsonDecode(res.body)['message'];
  }

  // Todos
  static Future<List> getTodos() async {
    final res = await http.get(
      Uri.parse('$baseUrl/todos'),
      headers: await _headers(auth: true),
    );
    return jsonDecode(res.body);
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
