import 'package:flutter/material.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/shared/theme.dart';

class BottomAppbar extends StatefulWidget {
  final int initialIndex; // Menambahkan parameter untuk menentukan index awal

  const BottomAppbar({
    required this.initialIndex,
    super.key,
  });

  @override
  State<BottomAppbar> createState() => _BottomAppbarState();
}

class _BottomAppbarState extends State<BottomAppbar> {
  int? indexActive;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    setVariabel();
    indexActive = widget.initialIndex;
  }

  void setVariabel() async {
    indexActive = widget.initialIndex;

    isLogin = await SharePref().isLogin();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: AppTheme.bgBottomBar,
      child: SizedBox(
        height: 71,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      },
                      minWidth: 30,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppTheme.assetIcHome,
                            width: 50,
                            height: 50,
                          ),
                          indexActive == 1
                              ? Container(
                                  width: 25,
                                  height: 2,
                                  color: AppTheme.bgMain,
                                )
                              : const SizedBox(height: 2),
                        ],
                      ),
                    ),
                    isLogin
                        ? MaterialButton(
                            onPressed: () async {
                              bool isLogin = await SharePref().isLogin();

                              if (!isLogin) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/pesanan-pembeli', (route) => false);
                              } else {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/daftar-pesanan', (route) => false);
                              }
                            },
                            minWidth: 30,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AppTheme.assetIcPackage,
                                  width: 50,
                                  height: 50,
                                ),
                                indexActive == 2
                                    ? Container(
                                        width: 25,
                                        height: 2,
                                        color: AppTheme.bgMain,
                                      )
                                    : const SizedBox(height: 2),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/pesanan-kasir', (route) => false);
                      },
                      minWidth: 30,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppTheme.assetIcListOrder,
                            width: 50,
                            height: 50,
                          ),
                          indexActive == 3
                              ? Container(
                                  width: 25,
                                  height: 2,
                                  color: AppTheme.bgMain,
                                )
                              : const SizedBox(height: 2),
                        ],
                      ),
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
