import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  static const String _baseUrl = 'https://dummyjson.com'; // Your real base URL

  ApiClient({required this.client});

  // Helper for GET requests
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  // Helper for POST requests
  Future<dynamic> post(String endpoint, {required dynamic body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  // You can add put() and delete() methods following the same pattern...

  // Centralized response handling
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException();
    }
  }
}
