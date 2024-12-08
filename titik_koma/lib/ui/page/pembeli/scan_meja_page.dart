import 'package:flutter/material.dart';
import 'package:titik_koma/shared/theme.dart';

// import 'package:qrscan/qrscan.dart' as scanner;

class ScanMejaPage extends StatefulWidget {
  const ScanMejaPage({super.key});

  @override
  State<ScanMejaPage> createState() => _ScanMejaPageState();
}

class _ScanMejaPageState extends State<ScanMejaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.bgMain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Hasil QR Code',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            Image.asset(
              AppTheme.assetQrCode,
              fit: BoxFit.cover,
              width: 300,
            ),
            SizedBox(
              width: AppTheme.percentageWidth(context, 0.8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  Navigator.pushNamed(context, '/scan-view');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppTheme.assetQrMini,
                      fit: BoxFit.cover,
                      width: 20,
                      height: 20,
                    ),
                    const Text(
                      'SCAN QR CODE NO MEJA ANDA',
                      selectionColor: Colors.white,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
