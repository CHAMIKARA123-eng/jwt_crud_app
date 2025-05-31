import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:3000/api/users'; // Android emulator
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  // Save token after login
  void _saveToken(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }

  //  Register user
Future<bool> register(String username, String password) async {
  try {
    final url = Uri.parse('$baseUrl/register');
    print('Sending registration to: $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');

    return response.statusCode == 201;
  } catch (e) {
    print('Register error: $e');
    return false;
  }
}

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login status: ${response.statusCode}');
      print('Login body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _saveToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Get all users
  Future<List<User>> getUsers() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      print('Get users status: ${response.statusCode}');
      print('Get users body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Get one user
  Future<User> getUser(String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Update user
  Future<bool> updateUser(String id, String username) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username': username}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}
