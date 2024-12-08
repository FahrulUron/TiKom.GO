import 'package:flutter/material.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/shared/theme.dart';

class ProfileKasirPage extends StatefulWidget {
  const ProfileKasirPage({super.key});

  @override
  State<ProfileKasirPage> createState() => _ProfileKasirPageState();
}

class _ProfileKasirPageState extends State<ProfileKasirPage> {
  final _key = GlobalKey<FormState>();
  TextEditingController tecEmail = TextEditingController(text: '');
  TextEditingController tecNama = TextEditingController(text: '');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setVariabel();
  }

  void setVariabel() async {
    String email = await SharePref().getEmail();
    String nama = await SharePref().getNama();

    tecEmail.text = email;
    tecNama.text = nama;

    setState(() {});
  }

  logout() async {
    isLoading = true;
    setState(() {});

    await SharePref().clear();

    isLoading = false;
    setState(() {});
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/kasir', ModalRoute.withName('/opening'));
  }

  @override
  Widget build(BuildContext context) {
    Widget logo() {
      return Column(
        children: [
          Image.asset(
            AppTheme.assetIcPerson,
            fit: BoxFit.cover,
            width: 100,
          ),
          Text(
            'KASIR',
            style: AppTheme.menuTextStyle,
          ),
          const SizedBox(height: 30)
        ],
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
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: tecNama,
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
                    Icons.person,
                  ),
                  hintText: "Nama",
                  hintStyle: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? Container(
                        color: Colors.white,
                        width: double.infinity,
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
                        onPressed: () {
                          logout();
                        },
                        child: Text(
                          'Logout',
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
