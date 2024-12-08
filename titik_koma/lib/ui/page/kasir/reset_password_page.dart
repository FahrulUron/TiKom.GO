import 'package:flutter/material.dart';
import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/services/user_service.dart';
import 'package:titik_koma/shared/theme.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _key = GlobalKey<FormState>();
  TextEditingController tecEmail = TextEditingController(text: '');
  TextEditingController tecPassword = TextEditingController(text: '');
  bool isLoading = false;

  Future<void> handleResetPassword() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Simulasikan panggilan API untuk reset password
        // Ganti dengan implementasi API Anda
        ApiResponse response =
            await UserService().resetPassword(email: tecEmail.text);

        if (response.status) {
          // Tampilkan dialog berhasil

          tecEmail.text = '';

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Success',
                      style: AppTheme.titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Reset password email has been sent!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Tampilkan dialog gagal
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed',
                      style: AppTheme.titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Failed to send reset password email.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Tampilkan dialog error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: AppTheme.titleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'An error occurred: $e',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                controller: tecEmail,
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: "Masukkan Email",
                  hintStyle: const TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: AppTheme.defaultMargin * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    elevation: 3,
                  ),
                  onPressed: isLoading ? null : handleResetPassword,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Send Reset Password',
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
