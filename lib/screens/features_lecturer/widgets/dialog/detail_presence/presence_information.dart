import 'package:flutter/material.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/detail_presence/presence_information.dart';

class PresenceDetailDialog extends StatelessWidget {
  final String waktuPresensi;
  final String keterangan;
  final String alasan;

  const PresenceDetailDialog({
    super.key,
    required this.waktuPresensi,
    required this.keterangan,
    required this.alasan,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Presensi Mata Kuliah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B73C1),
              ),
            ),
            const SizedBox(height: 16),
            PresenceInformationCard(
              waktuPresensi: waktuPresensi,
              keterangan: keterangan,
              alasan: alasan,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}
