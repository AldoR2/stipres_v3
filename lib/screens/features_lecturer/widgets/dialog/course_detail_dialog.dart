import 'package:flutter/material.dart';
import 'package:stipres/screens/features_student/widgets/cards/course_detail_card.dart';

class CourseDetailDialog extends StatelessWidget {
  final String namaMatkul;
  final String idMatkul;
  final String tanggal;
  final String jam;
  final String dosen;

  const CourseDetailDialog({
    super.key,
    required this.namaMatkul,
    required this.idMatkul,
    required this.tanggal,
    required this.jam,
    required this.dosen,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Detail Mata Kuliah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B73C1),
              ),
            ),
            const SizedBox(height: 16),
            CourseDetailCard(
              namaMatkul: namaMatkul,
              idMatkul: idMatkul,
              tanggal: tanggal,
              jam: jam,
              dosen: dosen,
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
