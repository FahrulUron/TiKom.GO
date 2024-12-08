import 'package:flutter/material.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/shared/theme.dart';

class OpeningPage extends StatefulWidget {
  const OpeningPage({super.key});

  @override
  State<OpeningPage> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.bgMain,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppTheme.assetLogo,
                fit: BoxFit.cover,
                width: 300,
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: 260,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/kasir');
                  },
                  child: const Text(
                    'Kasir',
                    selectionColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 260,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () async {
                    String? pembeli = await SharePref().getNama();

                    // Periksa apakah data pembeli tersedia
                    if (pembeli.isNotEmpty) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } else {
                      Navigator.pushNamed(context, '/scan-meja');
                    }
                  },
                  child: const Text(
                    'Pembeli',
                    selectionColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
