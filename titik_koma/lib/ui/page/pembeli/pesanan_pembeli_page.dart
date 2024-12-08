import 'package:flutter/material.dart';
import 'package:titik_koma/model/api_response.dart';
import 'package:titik_koma/model/order_menu_detail.dart';
import 'package:titik_koma/services/cache/share_pref.dart';
import 'package:titik_koma/services/order_menu_detail_service.dart';
import 'package:titik_koma/services/order_menu_service.dart';
import 'package:titik_koma/shared/theme.dart';
import 'package:titik_koma/ui/page/bottom_app_bar.dart';
import 'package:titik_koma/ui/widget/pesanan_card_widget.dart';

class PesananPembeliPage extends StatefulWidget {
  const PesananPembeliPage({super.key});

  @override
  State<PesananPembeliPage> createState() => _PesananPembeliPageState();
}

class _PesananPembeliPageState extends State<PesananPembeliPage> {
  Future<List<OrderMenuDetail>> _orderMenuDetailFuture = Future.value([]);
  bool isLoading = false;
  bool isLogin = false;
  String? noMeja = '';

  @override
  void initState() {
    super.initState();
    setVariabel();
  }

  void setVariabel() async {
    isLogin = await SharePref().isLogin();
    noMeja = await SharePref().getNoMeja();

    _orderMenuDetailFuture = OrderMenuDetailService().getOrderMenuDetail();
    setState(() {});
  }

  void _deleteOrderMenuDetail(OrderMenuDetail orderMenuDetail) async {
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
        await OrderMenuDetailService()
            .deleteOrderMenuDetail(orderMenuDetail.id);

        setState(() {
          _orderMenuDetailFuture = _orderMenuDetailFuture.then((value) {
            return value
                .where((item) => item.id != orderMenuDetail.id)
                .toList();
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

  void _prosesPemesanan() async {
    isLoading = true;
    setState(() {});

    // Mengambil data order_menu_detail dari Future
    List<OrderMenuDetail> orderMenuDetails = await _orderMenuDetailFuture;

    if (orderMenuDetails.isEmpty) {
      // Tampilkan pesan jika tidak ada pesanan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada pesanan untuk diproses')),
      );
      return;
    }

    // Membuat struktur data JSON sesuai format yang dibutuhkan
    List<Map<String, dynamic>> orderDetails =
        orderMenuDetails.map((orderMenuDetail) {
      return {
        'id': orderMenuDetail.id,
        'jumlah': orderMenuDetail.jumlah,
      };
    }).toList();

    Map<String, dynamic> orderData = {
      'order_menu_id': await SharePref().getOrderId(),
      'order_menu_detail': orderDetails,
    };

    try {
      // Kirimkan data pesanan ke server atau API untuk diproses
      ApiResponse response = await OrderMenuService().processOrder(orderData);

      if (response.status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Berhasil'),
              content: const Text('Pemesanan berhasil diproses'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    isLoading = false;
                    setState(() {});
                    await SharePref().clear();
                    Navigator.pop(context);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/scan-meja', ModalRoute.withName('/opening'));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Reset data setelah dialog ditutup
        setState(() {
          _orderMenuDetailFuture = Future.value([]);
        });
      } else {
        // Jika ada error dalam proses pemesanan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses pemesanan')),
        );
      }
    } catch (e) {
      // Tangani error jika terjadi kesalahan saat mengirim data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Terjadi kesalahan dalam proses pemesanan')),
      );
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
                  'Pesanan Saya',
                  style: AppTheme.menuTextStyle,
                ),
                !isLogin
                    ? Text(
                        'Meja No. $noMeja',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.menuTextStyle,
                      )
                    : Image.asset(
                        AppTheme.assetIcPerson,
                        width: 50,
                        height: 50,
                      )
              ],
            ),
            SizedBox(height: AppTheme.aboveBlank),
          ],
        ),
      );
    }

    Widget listPesanan() {
      return FutureBuilder<List<OrderMenuDetail>>(
        future: _orderMenuDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: AppTheme.bgMain));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Tidak ada pesanan'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan'));
          } else {
            List<OrderMenuDetail> orderMenuDetails = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: orderMenuDetails.length,
              itemBuilder: (context, index) {
                OrderMenuDetail orderMenuDetail = orderMenuDetails[index];
                var totalHarga = orderMenuDetail.harga * orderMenuDetail.jumlah;

                return PesananCard(
                  label: orderMenuDetail.menu.nama,
                  harga: totalHarga,
                  jumlah: orderMenuDetail.jumlah,
                  onAddJumlah: () => setState(() {
                    orderMenuDetail.jumlah++;
                  }),
                  onRemoveJumlah: () => setState(() {
                    if (orderMenuDetail.jumlah > 0) {
                      orderMenuDetail.jumlah--;
                    }
                  }),
                  onDelete: () => _deleteOrderMenuDetail(orderMenuDetail),
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
              listPesanan(),
            ],
          ),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomAppbar(initialIndex: isLogin ? 3 : 2),
      floatingActionButton: Container(
        width: double.infinity, // Sepanjang layar
        margin:
            const EdgeInsets.symmetric(horizontal: 16), // Padding kiri & kanan
        height: 55, // Tinggi tombol
        child: ElevatedButton(
          onPressed: () {
            // Aksi tombol
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            backgroundColor: Colors.white, // Warna tombol
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5), // Membuat tombol melengkung
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppTheme.bgMain),
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<List<OrderMenuDetail>>(
                      future: _orderMenuDetailFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Rp.0');
                        } else if (snapshot.hasData) {
                          // Menghitung total harga setelah data tersedia
                          List<OrderMenuDetail> orderMenuDetails =
                              snapshot.data!;
                          var totalHarga =
                              orderMenuDetails.fold(0, (sum, orderMenuDetail) {
                            return sum +
                                (orderMenuDetail.harga *
                                    orderMenuDetail.jumlah);
                          });
                          return Text(
                            'Rp.$totalHarga',
                            style: AppTheme.titleTextStyle
                                .copyWith(fontStyle: FontStyle.italic),
                          );
                        } else {
                          return const Text('Rp.0');
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        _prosesPemesanan();
                      },
                      child: Text(
                        'Pesan >>',
                        style: AppTheme.titleTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
