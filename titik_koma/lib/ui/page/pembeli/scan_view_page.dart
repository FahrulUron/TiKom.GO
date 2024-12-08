import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titik_koma/shared/theme.dart';
import 'package:titik_koma/services/cache/key.dart';

class ScanViewPage extends StatefulWidget {
  const ScanViewPage({super.key});

  @override
  State<ScanViewPage> createState() => _ScanViewPageState();
}

class _ScanViewPageState extends State<ScanViewPage> {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        Text(
                            'Berhasil mendapatkan meja nomor : ${result!.code}'),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 260,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.bgMain,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () async {
                              SharedPreferences? sharedPreferences =
                                  await _preferences;

                              sharedPreferences.setString(
                                  Keys.noMeja, "${result!.code}");
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/biodata',
                                  ModalRoute.withName('/scan-meja'));
                            },
                            child: const Text(
                              'Lanjut pesan makanan',
                              selectionColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }
}
