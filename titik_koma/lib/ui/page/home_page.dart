import 'package:flutter/material.dart';
import 'package:titik_koma/model/menu.dart';
import 'package:titik_koma/services/menu_service.dart';
import 'package:titik_koma/shared/theme.dart';
import 'package:titik_koma/ui/page/bottom_app_bar.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/ui/widget/category_button_widget.dart';
import 'package:titik_koma/ui/widget/menu_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? noMeja = '';
  bool isLogin = false;

  Future<List<Menu>> _menuFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    setVariabel();
  }

  void setVariabel() async {
    noMeja = await SharePref().getNoMeja();
    isLogin = await SharePref().isLogin();

    _menuFuture = MenuService().getMenu();

    setState(() {});
  }

  Future<void> _onRefresh() async {
    setState(() {
      setVariabel();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget headerDanFilter() {
      return SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu Titik Koma Cafe',
                  style: AppTheme.menuTextStyle,
                ),
                !isLogin
                    ? Text(
                        'Meja No. $noMeja',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.menuTextStyle,
                      )
                    : GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/profile-kasir'),
                        child: Image.asset(
                          AppTheme.assetIcPerson,
                          width: 50,
                          height: 50,
                        ),
                      )
              ],
            ),
            SizedBox(height: AppTheme.aboveBlank),
            !isLogin
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(context, '/scan-meja');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppTheme.assetQrMini,
                              fit: BoxFit.cover,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Scan ulang meja',
                              selectionColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryButton(
                      iconImage: AppTheme.assetIcSemua,
                      label: 'Semua',
                      onPressed: () {
                        _menuFuture = MenuService().getMenu();
                        setState(() {});
                      }),
                  CategoryButton(
                      iconImage: AppTheme.assetIcMinuman,
                      label: 'Minuman',
                      onPressed: () {
                        _menuFuture = MenuService().getMenu(jenis: 2);
                        setState(() {});
                      }),
                  CategoryButton(
                      iconImage: AppTheme.assetIcMakanan,
                      label: 'Makanan',
                      onPressed: () {
                        _menuFuture = MenuService().getMenu(jenis: 1);
                        setState(() {});
                      }),
                  CategoryButton(
                      iconImage: AppTheme.assetIcCemilan,
                      label: 'Cemilan',
                      onPressed: () {
                        _menuFuture = MenuService().getMenu(jenis: 3);
                        setState(() {});
                      })
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    Widget gridMenu() {
      return FutureBuilder<List<Menu>>(
        future:
            _menuFuture, // Pastikan _menuFuture sudah berisi data yang diambil dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu available.'));
          } else {
            List<Menu> menuList = snapshot.data!;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 200,
              ),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                Menu menu = menuList[index];
                return MenuCard(
                  menuId: menu.id,
                  image: menu.foto ??
                      'default_image_url', // Ganti dengan foto dari API
                  label: menu.nama,
                  harga: menu.harga,
                  kategori: menu.jenis!.namaJenis, // Jenis dari menu
                );
              },
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            margin: EdgeInsets.all(AppTheme.defaultMargin),
            child: Column(
              children: [
                SizedBox(height: AppTheme.aboveBlank),
                headerDanFilter(),
                gridMenu(),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const BottomAppbar(initialIndex: 1),
    );
  }
}
