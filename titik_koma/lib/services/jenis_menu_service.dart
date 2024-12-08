import 'dart:convert';

import 'package:titik_koma/model/jenis_menu.dart';
import 'package:titik_koma/services/endpoint.dart';
import 'package:http/http.dart' as http;

class JenisMenuService {
  //fungsi get aplikasi yang ada
  Future<List<JenisMenu>> getJenisMenu() async {
    var url = Uri.parse(Endpoint.getJenisMenu);

    var header = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List data = jsonResponse['data'];

      List<JenisMenu> menu = [];
      for (var item in data) {
        menu.add(
            JenisMenu.fromJson(item)); // Menggunakan fromJson untuk parsing
      }

      return menu;
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }
}
