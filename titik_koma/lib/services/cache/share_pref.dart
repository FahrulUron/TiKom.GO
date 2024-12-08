import 'package:shared_preferences/shared_preferences.dart';
import 'package:titik_koma/services/cache/key.dart';

class SharePref {
  SharedPreferences? _preferences;

  Future<bool> isLogin() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getBool(Keys.isLogin) ?? false;
  }

  Future<int> getId() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getInt(Keys.idUser) ?? 0;
  }

  Future<String> getNama() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.nama) ?? "";
  }

  Future<String> getEmail() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.email) ?? "";
  }

  Future<String> getNohp() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.noHP) ?? "";
  }

  Future<String> getNoMeja() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.noMeja) ?? "";
  }

  Future<String> getToken() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.token) ?? "";
  }

  Future<String> getOrderId() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString(Keys.orderId) ?? "";
  }

  Future clear() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.clear();
  }
}
