import 'dart:convert';

class JenisMenu {
  int id;
  String namaJenis;
  dynamic createdAt;
  dynamic updatedAt;

  JenisMenu({
    required this.id,
    required this.namaJenis,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JenisMenu.fromRawJson(String str) =>
      JenisMenu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JenisMenu.fromJson(Map<String, dynamic> json) => JenisMenu(
        id: json["id"],
        namaJenis: json["nama_jenis"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_jenis": namaJenis,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
