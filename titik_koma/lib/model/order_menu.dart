import 'dart:convert';

class OrderMenu {
  String mejaNo;
  String namaPembeli;
  String noHp;
  String status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  OrderMenu({
    required this.mejaNo,
    required this.namaPembeli,
    required this.noHp,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OrderMenu.fromRawJson(String str) =>
      OrderMenu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderMenu.fromJson(Map<String, dynamic> json) => OrderMenu(
        mejaNo: json["meja_no"],
        namaPembeli: json["nama_pembeli"],
        noHp: json["no_hp"] ?? '',
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "meja_no": mejaNo,
        "nama_pembeli": namaPembeli,
        "no_hp": noHp,
        "status": status,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
