import 'dart:convert';

import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/model/menu.dart';
import 'package:titik_koma/services/endpoint.dart';
import 'package:http/http.dart' as http;

class MenuService {
  //fungsi get aplikasi yang ada
  Future<List<Menu>> getMenu({int jenis = 0}) async {
    var url =
        Uri.parse(jenis == 0 ? Endpoint.getMenu : "${Endpoint.getMenu}/$jenis");

    var header = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List data = jsonResponse['data'];
      List<Menu> menu = [];

      for (var item in data) {
        menu.add(Menu.fromJson(item));
      }

      return menu;
    } else {
      throw Exception(response.body);
    }
  }

  Future<ApiResponse> createOrderMenu({
    required String nama,
    required String nohp,
    required String nomeja,
  }) async {
    var url = Uri.parse(Endpoint.getMenu);

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
}
