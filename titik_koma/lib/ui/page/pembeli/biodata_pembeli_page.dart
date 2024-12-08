import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/services/order_menu_service.dart';
import 'package:titik_koma/shared/theme.dart';
import 'package:titik_koma/services/cache/key.dart';

class BiodataPembeliPage extends StatefulWidget {
  const BiodataPembeliPage({super.key});

  @override
  State<BiodataPembeliPage> createState() => _BiodataPembeliPageState();
}

class _BiodataPembeliPageState extends State<BiodataPembeliPage> {
  bool isLoading = false;

  final _key = GlobalKey<FormState>();
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();
  TextEditingController tecNama = TextEditingController(text: '');
  TextEditingController tecNoHp = TextEditingController(text: '');

  handleLogin() async {
    setState(() {
      isLoading = true;
    });

    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      SharedPreferences? sharedPreferences = await _preferences;

      try {
        // Simpan data pembeli ke SharedPreferences
        sharedPreferences.setBool(Keys.isLogin, false);
        sharedPreferences.setString(Keys.nama, tecNama.text);
        sharedPreferences.setString(Keys.noHP, tecNoHp.text);

        // Panggil fungsi tambahOrderMenu untuk menyimpan order
        ApiResponse response = await OrderMenuService().createOrderMenu(
            nama: tecNama.text,
            nohp: tecNoHp.text,
            nomeja: await SharePref().getNoMeja());

        // Periksa apakah data berhasil dibuat
        if (response.status) {
          if (response.data != null && response.data is Map<String, dynamic>) {
            String orderId = response.data['id'].toString();
            sharedPreferences.setString(Keys.orderId, orderId);
          }

          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          Fluttertoast.showToast(
            msg: response.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Terjadi kesalahan: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget logo() {
      return Image.asset(
        AppTheme.assetLogo,
        fit: BoxFit.cover,
        width: 300,
      );
    }

    Widget formLogin() {
      return Form(
        key: _key,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: AppTheme.defaultMargin),
          child: Column(
            children: [
              TextFormField(
                controller: tecNama,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: "Masukkan Nama",
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harap diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: tecNoHp,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(
                    Icons.mobile_friendly,
                  ),
                  hintText: "Masukkan No Hp",
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No hp harap diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 3,
                  ),
                  onPressed: handleLogin,
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(AppTheme.bgMain),
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Loading...',
                              style: AppTheme.titleTextStyle
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      : Text(
                          'Mulai memesan',
                          selectionColor: Colors.white,
                          style: AppTheme.titleTextStyle
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              SizedBox(height: AppTheme.defaultMargin),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.bgMain,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppTheme.aboveBlank * 2),
              logo(),
              const SizedBox(height: 70),
              formLogin(),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
