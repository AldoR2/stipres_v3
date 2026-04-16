import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/models/lecturers/all_schedule_model.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AllScheduleCard extends StatelessWidget {
  final LecturerAllScheduleModel jadwal;

  const AllScheduleCard({Key? key, required this.jadwal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/ic_clock.png',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 6),
            Text(
              "${jadwal.durasiPerkuliahan!} - Selesai",
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: styles.getTextColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Mulai Stack
        Stack(
          children: [
            // Kartu utama dengan margin kiri agar tidak tertabrak icon
            Container(
              padding: const EdgeInsets.only(
                  top: 12, left: 80, right: 12, bottom: 12),
              margin: const EdgeInsets.only(left: 0, bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10), // spasi dari sisi kiri container
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jadwal.kodeMatkul!,
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                        SizedBox(height: 6),
                        Text(
                          jadwal.namaMatkul!,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/ic_semester.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Text("Semester ${jadwal.semester.toString()}",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/ic_location.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(jadwal.namaRuangan!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/ic_jumlahSKS.png',
                              height: 16,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Text("${jadwal.durasi!} SKS",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Icon yang diposisikan di sisi kiri
            Positioned(
              top: 12,
              bottom: 26,
              left: 0,
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFFFCC80),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'assets/icons/ic_matakuliah.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
