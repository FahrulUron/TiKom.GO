import 'dart:convert';

import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/model/order_menu_detail.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/services/endpoint.dart';
import 'package:http/http.dart' as http;

class OrderMenuDetailService {
  Future<List<OrderMenuDetail>> getOrderMenuDetail(
      {String orderMenusId = ''}) async {
    print(orderMenusId);
    String? orderMenuId;
    if (orderMenusId != '') {
      orderMenuId = orderMenusId;
    } else {
      orderMenuId = await SharePref().getOrderId();
    }

    var url = Uri.parse("${Endpoint.getOrderMenuDetail}/$orderMenuId");

    var header = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List data = jsonResponse['data'];

      List<OrderMenuDetail> orderMenuDetail = [];

      for (var item in data) {
        orderMenuDetail.add(OrderMenuDetail.fromJson(item));
      }

      print(orderMenuDetail);

      return orderMenuDetail;
    } else {
      throw Exception(response.body);
    }
  }

  Future<ApiResponse> createOrderMenuDetail({
    required int menuId,
    required int jumlah,
    required int harga,
  }) async {
    var url = Uri.parse(Endpoint.getOrderMenuDetail);

    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      'order_menu_id': await SharePref().getOrderId(),
      'menu_id': menuId,
      'jumlah': jumlah,
      'harga': harga
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<ApiResponse> deleteOrderMenuDetail(int orderMenuDetailId) async {
    var url = Uri.parse(
        '${Endpoint.getOrderMenuDetail}/$orderMenuDetailId'); // Menambahkan ID pada URL

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
}
