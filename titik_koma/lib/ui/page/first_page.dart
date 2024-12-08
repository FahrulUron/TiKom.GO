import 'dart:async';

import 'package:flutter/material.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/shared/theme.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();

    cekLogin();
  }

  void cekLogin() async {
    bool isLogin = await SharePref().isLogin();
    Timer(
      const Duration(seconds: 3),
      () => (isLogin)
          ? Navigator.pushReplacementNamed(context, '/home')
          : Navigator.pushReplacementNamed(context, '/opening'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.bgMain,
        child: Center(
          child: SizedBox(
            child: Image.asset(
              AppTheme.assetLogoOpening,
              fit: BoxFit.cover,
              width: 150,
            ),
          ),
        ),
      ),
    );
  }
}
