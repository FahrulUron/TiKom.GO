import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/services/cache/key.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/services/order_menu_service.dart';
import 'package:titik_koma/services/user_service.dart';
import 'package:titik_koma/shared/theme.dart';

class LoginKasirPage extends StatefulWidget {
  const LoginKasirPage({super.key});

  @override
  State<LoginKasirPage> createState() => _LoginKasirPageState();
}

class _LoginKasirPageState extends State<LoginKasirPage> {
  bool isObscure = true;
  bool isLoading = false;

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  final _key = GlobalKey<FormState>();
  TextEditingController tecEmail = TextEditingController(text: '');
  TextEditingController tecPassword = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    handleLogin() async {
      setState(() {
        isLoading = true;
      });

      if (_key.currentState!.validate()) {
        _key.currentState!.save();
        SharedPreferences? sharedPreferences = await _preferences;

        try {
          // Simpan data pembeli ke SharedPreferences

          // Panggil fungsi tambahOrderMenu untuk menyimpan order
          ApiResponse response = await UserService()
              .login(email: tecEmail.text, password: tecPassword.text);

          // Periksa apakah data berhasil dibuat
          if (response.status) {
            print(response.data);
            if (response.data != null &&
                response.data is Map<String, dynamic>) {
              String token = response.data['acces_token'].toString();

              sharedPreferences.setBool(Keys.isLogin, true);
              sharedPreferences.setString(Keys.token, token);
              sharedPreferences.setString(
                  Keys.email, response.data['email'].toString());
              sharedPreferences.setString(
                  Keys.nama, response.data['name'].toString());
              String userId = response.data['id'].toString();
              sharedPreferences.setString(Keys.idUser, userId);
            }

            ApiResponse responseOrder =
                await OrderMenuService().createOrderMenu(
              nama: await SharePref().getNama(),
              nohp: '',
              nomeja: await SharePref().getNama(),
            );

            if (responseOrder.status) {
              if (responseOrder.data != null &&
                  responseOrder.data is Map<String, dynamic>) {
                String orderId = responseOrder.data['id'].toString();
                sharedPreferences.setString(Keys.orderId, orderId);
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: response.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
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
              SizedBox(
                width: AppTheme.percentageWidth(context, 0.8),
                child: TextFormField(
                  controller: tecEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Masukkan Email",
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: AppTheme.percentageWidth(context, 0.8),
                child: TextFormField(
                  controller: tecPassword,
                  style: const TextStyle(color: Colors.black),
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isObscure = !isObscure;
                        setState(() {});
                      },
                      child: Icon(
                        isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye,
                      ),
                    ),
                    hintText: "Masukkan Password",
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: AppTheme.percentageWidth(context, 0.8),
                child: isLoading
                    ? Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 14),
                        child: Row(
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
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () => handleLogin(),
                        child: Text(
                          'Login',
                          selectionColor: Colors.white,
                          style: AppTheme.titleTextStyle
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
              const SizedBox(height: 7),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/reset-password'),
                child: Text(
                  'Reset Password ?',
                  style: AppTheme.menuTextStyle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
