import 'dart:convert';

class Menu {
  int id;
  String nama;
  int jenisId;
  int harga;
  dynamic foto;
  DateTime createdAt;
  DateTime updatedAt;
  Jenis? jenis;

  Menu({
    required this.id,
    required this.nama,
    required this.jenisId,
    required this.harga,
    required this.foto,
    required this.createdAt,
    required this.updatedAt,
    required this.jenis,
  });

  factory Menu.fromRawJson(String str) => Menu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        nama: json["nama"],
        jenisId: json["jenis_id"],
        harga: json["harga"],
        foto: json["foto"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        jenis: json["jenis"] != null ? Jenis.fromJson(json["jenis"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "jenis_id": jenisId,
        "harga": harga,
        "foto": foto,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "jenis": jenis?.toJson(),
      };
}

class Jenis {
  int id;
  String namaJenis;
  dynamic createdAt;
  dynamic updatedAt;

  Jenis({
    required this.id,
    required this.namaJenis,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Jenis.fromRawJson(String str) => Jenis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Jenis.fromJson(Map<String, dynamic> json) => Jenis(
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
