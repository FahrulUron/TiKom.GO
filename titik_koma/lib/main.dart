import 'package:flutter/material.dart';
import 'package:titik_koma/ui/page/first_page.dart';
import 'package:titik_koma/ui/page/home_page.dart';
import 'package:titik_koma/ui/page/kasir/pesanan_kasir_page.dart';
import 'package:titik_koma/ui/page/kasir/profile_kasir_page.dart';
import 'package:titik_koma/ui/page/kasir/daftar_pesanan_page.dart';
import 'package:titik_koma/ui/page/kasir/login_kasir_page.dart';
import 'package:titik_koma/ui/page/kasir/reset_password_page.dart';
import 'package:titik_koma/ui/page/opening_page.dart';
import 'package:titik_koma/ui/page/pembeli/biodata_pembeli_page.dart';
import 'package:titik_koma/ui/page/pembeli/pesanan_pembeli_page.dart';
import 'package:titik_koma/ui/page/pembeli/scan_meja_page.dart';
import 'package:titik_koma/ui/page/pembeli/scan_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Titik Koma Cafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const FirstPage(),
        '/opening': (context) => const OpeningPage(),
        '/kasir': (context) => const LoginKasirPage(),
        '/scan-meja': (context) => const ScanMejaPage(),
        '/scan-view': (context) => const ScanViewPage(),
        '/biodata': (context) => const BiodataPembeliPage(),
        '/home': (context) => const HomePage(),
        '/pesanan-pembeli': (context) => const PesananPembeliPage(),
        '/daftar-pesanan': (context) => const DaftarPesananPage(),
        '/pesanan-kasir': (context) => const PesananKasirPage(),
        '/profile-kasir': (context) => const ProfileKasirPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
