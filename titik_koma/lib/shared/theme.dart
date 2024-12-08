import 'package:flutter/material.dart';

class AppTheme {
  // Fungsi Utilitas Ukuran Layar
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double percentageWidth(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
  }

  static double percentageHeight(BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
  }

  // untuk size
  static double aboveBlank = 40;
  static double defaultMargin = 20;

  // untuk warna
  static Color bgMain = const Color(0xff40534C);
  static Color bgBottomBar = const Color(0xff677D6A);

  // untuk text style
  static TextStyle menuTextStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white);

  static TextStyle titleTextStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle subtitleTextStyle = const TextStyle(
      fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black);

  // location image
  static const String assetLogo = 'assets/images/logo.png';
  static const String assetLogoOpening = 'assets/images/logo_opening.png';
  static const String assetQrCode = 'assets/images/qr_code.png';
  static const String assetQrMini = 'assets/images/qr_mini.png';
  static const String assetIcSemua = 'assets/images/ic_semua.png';
  static const String assetIcMakanan = 'assets/images/ic_makanan.png';
  static const String assetIcMinuman = 'assets/images/ic_minuman.png';
  static const String assetIcCemilan = 'assets/images/ic_cemilan.png';
  static const String assetIcHome = 'assets/images/ic_home.png';
  static const String assetIcPackage = 'assets/images/ic_package.png';
  static const String assetIcClose = 'assets/images/ic_close.png';
  static const String assetIcPerson = 'assets/images/ic_person.png';
  static const String assetIcListOrder = 'assets/images/ic_list_order.png';
}
