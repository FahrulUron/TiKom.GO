import 'dart:convert';

import 'package:titik_koma/model/menu.dart';

class OrderMenuDetail {
  int id;
  int orderMenuId;
  int menuId;
  int jumlah;
  int harga;
  int totalSubtotal;
  DateTime createdAt;
  DateTime updatedAt;
  Menu menu;

  OrderMenuDetail({
    required this.id,
    required this.orderMenuId,
    required this.menuId,
    required this.jumlah,
    required this.harga,
    required this.totalSubtotal,
    required this.createdAt,
    required this.updatedAt,
    required this.menu,
  });

  factory OrderMenuDetail.fromRawJson(String str) =>
      OrderMenuDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderMenuDetail.fromJson(Map<String, dynamic> json) =>
      OrderMenuDetail(
        id: json["id"],
        orderMenuId: json["order_menu_id"],
        menuId: json["menu_id"],
        jumlah: json["jumlah"],
        harga: json["harga"],
        totalSubtotal: json["total_subtotal"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        menu: Menu.fromJson(json["menu"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_menu_id": orderMenuId,
        "menu_id": menuId,
        "jumlah": jumlah,
        "harga": harga,
        "total_subtotal": totalSubtotal,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "menu": menu.toJson(),
      };
}
