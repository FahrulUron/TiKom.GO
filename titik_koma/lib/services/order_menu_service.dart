import 'dart:convert';

import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/model/order_menu.dart';
import 'package:titik_koma/services/endpoint.dart';
import 'package:http/http.dart' as http;

class OrderMenuService {
  Future<List<OrderMenu>> getOrderMenu() async {
    var url = Uri.parse(Endpoint.getOrderMenu);

    var header = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List data = jsonResponse['data'];

      List<OrderMenu> orderMenuDetail = [];

      for (var item in data) {
        orderMenuDetail.add(OrderMenu.fromJson(item));
      }

      return orderMenuDetail;
    } else {
      throw Exception(response.body);
    }
  }

  Future<ApiResponse> createOrderMenu({
    required String nama,
    required String nohp,
    required String nomeja,
  }) async {
    var url = Uri.parse(Endpoint.getOrderMenu);

    // Header untuk pengiriman data dalam format JSON
    var headers = {'Content-Type': 'application/json'};

    // Body data yang dikirim
    var body = jsonEncode({
      'nama_pembeli': nama,
      'no_hp': nohp,
      'meja_no': nomeja,
    });

    // Kirim permintaan POST ke server
    var response = await http.post(url, headers: headers, body: body);

    // Periksa status respons
    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      // Gagal, tampilkan pesan kesalahan
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<ApiResponse> deleteOrderMenu(int orderMenuId) async {
    var url = Uri.parse('${Endpoint.getOrderMenu}/$orderMenuId');

    var headers = {'Content-Type': 'application/json'};

    var response = await http.delete(url, headers: headers);
    // Periksa status respons
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      // Gagal, tampilkan pesan kesalahan
      throw Exception('Failed to delete order: ${response.body}');
    }
  }

  Future<ApiResponse> processOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse(Endpoint.getProsesPesanan);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData), // Konversi data ke JSON
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ApiResponse.fromJson(responseBody);
      } else {
        throw Exception('Failed to proses pesanan order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to proses pesanan order: $e');
    }
  }

  Future<ApiResponse> selesaikanOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse(Endpoint.getSelesaikanPesanan);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData), // Konversi data ke JSON
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ApiResponse.fromJson(responseBody);
      } else {
        throw Exception('Failed to proses pesanan order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to proses pesanan order: $e');
    }
  }
}
