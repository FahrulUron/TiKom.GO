import 'dart:convert';

import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/services/endpoint.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse(Endpoint.login);

    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({'email': email, 'password': password});

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<ApiResponse> resetPassword({
    required String email,
  }) async {
    var url = Uri.parse(Endpoint.resetPassword);

    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({'email': email});

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }
}
