import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  // Your backend's base URL
  final String _baseUrl = "http://192.168.29.217:3000/api";

  // This is the private helper function that does the magic
  Future<Map<String, String>> _getHeaders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    // 1. Store the token in a nullable String variable first.
    final String? token = await user.getIdToken();

    // 2. Check if the token is null. If so, you can't proceed.
    if (token == null) {
      throw Exception('Could not retrieve authentication token.');
    }

    // 3. If the check passes, Dart knows the token is not null here.
    return {
      'Content-Type': 'application/json; charset=UTF-8', // Corrected charset
      'Authorization': 'Bearer $token',
    };
  }

  // A central method for all GET requests
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders();
    return await http.get(url, headers: headers);
  }

  // A central method for all POST requests
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders();
    final body = json.encode(data);
    return await http.post(url, headers: headers, body: body);
  }
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders();
    final body = json.encode(data);
    return await http.put(url, headers: headers, body: body);
  }
}