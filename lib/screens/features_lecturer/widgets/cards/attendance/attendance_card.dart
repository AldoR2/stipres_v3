import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/models/lecturers/attendance_model.dart';

class MahasiswaCard extends StatelessWidget {
  final DataMahasiswa mahasiswa;

  const MahasiswaCard({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    String iconPath = mahasiswa.jenisKelamin.toLowerCase() == "p"
        ? 'assets/icons/ic_mahasiswi.png'
        : 'assets/icons/ic_mahasiswa.png';

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 3), // Tambah jarak bawah antar card
      child: Material(
        color: const Color(0xFFCFE9FF),
        elevation: 3,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          splashColor: Colors.blue.withOpacity(0.3),
          highlightColor: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(7),
          onTap: () {
            Get.toNamed("/student/attendance-screen", arguments: mahasiswa.nim);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  iconPath,
                  height: 70,
                  width: 70,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mahasiswa.nim,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mahasiswa.nama,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: Color(0xFF7F7F7F),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              mahasiswa.email,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF7F7F7F),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
