import 'package:flutter/material.dart';
import 'package:titik_koma/model/order_menu.dart';
import 'package:titik_koma/services/order_menu_service.dart';
import 'package:titik_koma/shared/theme.dart';
import 'package:titik_koma/ui/page/bottom_app_bar.dart';
import 'package:titik_koma/ui/page/kasir/proses_pesanan_page.dart';
import 'package:titik_koma/ui/widget/daftar_pesanan_card_widget.dart';

class DaftarPesananPage extends StatefulWidget {
  const DaftarPesananPage({super.key});

  @override
  State<DaftarPesananPage> createState() => _DaftarPesananPageState();
}

class _DaftarPesananPageState extends State<DaftarPesananPage> {
  Future<List<OrderMenu>> _orderMenuFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    setVariabel();
  }

  void setVariabel() async {
    _orderMenuFuture = OrderMenuService().getOrderMenu();
    setState(() {});
  }

  void _deleteOrderMenu(OrderMenu orderMenu) async {
    // Menampilkan dialog konfirmasi
    bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (isConfirmed ?? false) {
      try {
        await OrderMenuService().deleteOrderMenu(orderMenu.id);

        setState(() {
          _orderMenuFuture = _orderMenuFuture.then((value) {
            return value.where((item) => item.id != orderMenu.id).toList();
          });
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dihapus')),
        );
      } catch (e) {
        // Tangani error jika penghapusan gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus pesanan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Pesanan',
                  style: AppTheme.menuTextStyle,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile-kasir'),
                  child: Image.asset(
                    AppTheme.assetIcPerson,
                    width: 50,
                    height: 50,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget daftarPesanan() {
      return FutureBuilder<List<OrderMenu>>(
        future:
            _orderMenuFuture, // Pastikan _menuFuture sudah berisi data yang diambil dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu available.'));
          } else {
            List<OrderMenu> orderMenuList = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: orderMenuList.length,
              itemBuilder: (context, index) {
                OrderMenu orderMenu = orderMenuList[index];

                return DaftarPesananCard(
                  noMeja: orderMenu.mejaNo,
                  onLookDetail: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProsesPesananPage(
                        orderMenuId: orderMenu.id,
                        mejaNo: orderMenu.mejaNo,
                      );
                    }));
                  },
                  onDelete: () => _deleteOrderMenu(orderMenu),
                );
              },
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          margin: EdgeInsets.all(AppTheme.defaultMargin),
          child: Column(
            children: [
              SizedBox(height: AppTheme.aboveBlank),
              header(),
              daftarPesanan(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppbar(initialIndex: 2),
    );
  }
}
