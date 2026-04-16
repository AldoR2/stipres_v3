import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_lecturer/models/attendance/attendance_content_model.dart';

class KehadiranCard extends StatelessWidget {
  final Kehadiran jadwal;

  const KehadiranCard({Key? key, required this.jadwal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFCFE9FF), // background terang
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFC8C8C8),
          width: 0.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Box Semester
          Container(
            width: 70,
            height: 105,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Semester',
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white, fontSize: 12),
                ),
                Text(
                  jadwal.semester.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Konten Mata Kuliah & Persentase
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.matkul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Persentase Kehadiran (${jadwal.persentase.toStringAsFixed(0)}%)',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: Color.fromARGB(255, 21, 92, 151)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    KehadiranChip(
                      label: 'Hadir',
                      jumlah: _getJumlahKehadiran('Hadir'),
                      color: Colors.green,
                    ),
                    KehadiranChip(
                      label: 'Sakit',
                      jumlah: _getJumlahKehadiran('Sakit'),
                      color: Colors.yellow.shade700,
                    ),
                    KehadiranChip(
                      label: 'Izin',
                      jumlah: _getJumlahKehadiran('Izin'),
                      color: Colors.blue,
                    ),
                    KehadiranChip(
                      label: 'Alpa',
                      jumlah: _getJumlahKehadiran('Alpa'),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getJumlahKehadiran(String label) {
    final item = jadwal.kehadiran.firstWhere(
      (e) => e.label.toLowerCase() == label.toLowerCase(),
      orElse: () => KehadiranItem(label: label, jumlah: 0),
    );
    return item.jumlah;
  }
}

class KehadiranChip extends StatelessWidget {
  final String label;
  final int? jumlah;
  final Color color;

  const KehadiranChip({
    Key? key,
    required this.label,
    required this.jumlah,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Optional: width tetap untuk keseimbangan
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Vertikal center
        crossAxisAlignment: CrossAxisAlignment.center, // Horizontal center
        children: [
          Text(
            jumlah.toString(),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
