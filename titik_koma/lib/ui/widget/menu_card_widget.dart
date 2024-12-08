import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/services/order_menu_detail_service.dart';
import 'package:titik_koma/shared/theme.dart';

class MenuCard extends StatelessWidget {
  final int menuId;
  final String image;
  final String label;
  final String kategori;
  final int harga;

  const MenuCard({
    super.key,
    required this.menuId,
    required this.image,
    required this.label,
    required this.kategori,
    required this.harga,
  });

  // Fungsi untuk menangani aksi tambah
  Future<void> tambahMenu(BuildContext context, int menuId, int harga) async {
    // Menampilkan pop-up loading
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa dismiss dengan mengetuk di luar
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: AppTheme.bgMain,
          ),
        );
      },
    );

    try {
      // Panggil createOrderMenuDetail untuk mengirim data ke server
      ApiResponse response =
          await OrderMenuDetailService().createOrderMenuDetail(
        menuId: menuId,
        jumlah: 1,
        harga: harga,
      );

      // Menutup pop-up loading
      Navigator.of(context).pop();

      // Jika API berhasil, tampilkan toast sukses
      if (response.status) {
        Fluttertoast.showToast(
          msg: "Menu berhasil ditambahkan!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Jika response tidak berhasil, tampilkan pesan error
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Menutup pop-up loading jika terjadi error
      Navigator.of(context).pop();

      // Tampilkan pesan kesalahan jika terjadi error
      Fluttertoast.showToast(
        msg: 'Terjadi kesalahan: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/images/ice_late.png'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style:
                  AppTheme.titleTextStyle.copyWith(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              kategori,
              style: AppTheme.subtitleTextStyle
                  .copyWith(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp.$harga',
                    style: AppTheme.titleTextStyle
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  InkWell(
                    onTap: () {
                      tambahMenu(context, menuId, harga);
                    },
                    splashColor: Colors.black, // Warna efek splash
                    highlightColor: Colors.black, // Warna efek highlight
                    borderRadius: BorderRadius.circular(
                        5), // Membuat efek splash melingkar
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
