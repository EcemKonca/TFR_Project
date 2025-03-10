import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // .env dosyasını dahil et
import '../models/order_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['BASE_URL'] ?? "https://default-url.com"; // .env

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "$baseUrl/token/",
        data: {"username": username, "password": password},
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data.containsKey('access')) {
          String token = response.data['access']; // 'access' token'ı al
          await _saveToken(token);
          return token;
        } else {
          throw Exception("'access' not found in response: ${response.data}");
        }
      } else {
        throw Exception("Login is invalid: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not found, please log in.");
      }

      final response = await _dio.get(
        "$baseUrl/order-drivers/",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
          List<dynamic> orderList = response.data['results'];
          return orderList.map((order) => OrderModel.fromJson(order)).toList();
        } else {
          throw Exception("Unexpected data format: ${response.data}");
        }
      } else {
        throw Exception("An error occurred while loading orders: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }
}
