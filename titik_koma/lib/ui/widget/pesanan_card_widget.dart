import 'package:flutter/material.dart';
import 'package:titik_koma/shared/theme.dart';

class PesananCard extends StatelessWidget {
  final String label;
  final int harga;
  final int jumlah;
  final VoidCallback onAddJumlah;
  final VoidCallback onRemoveJumlah;
  final VoidCallback onDelete;

  const PesananCard({
    super.key,
    required this.label,
    required this.harga,
    required this.jumlah,
    required this.onAddJumlah,
    required this.onRemoveJumlah,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/ice_late.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: AppTheme.titleTextStyle
                              .copyWith(fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          "Rp.$harga",
                          style: AppTheme.titleTextStyle
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: onRemoveJumlah,
                              child: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "$jumlah",
                                style: AppTheme.titleTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: onAddJumlah,
                              child: const Icon(
                                Icons.add_circle_outline_sharp,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 50,
                child: InkWell(
                  onTap: onDelete,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Image.asset(
                      AppTheme.assetIcClose,
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
