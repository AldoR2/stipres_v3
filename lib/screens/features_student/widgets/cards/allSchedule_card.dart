import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/models/students/all_schedule_model.dart';
import 'package:stipres/screens/features_student/models/allSchedule_model.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AllScheduleCard extends StatelessWidget {
  final AllScheduleModelApi jadwal;

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
              "${jadwal.durasiPerkuliahan} - Selesai",
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: styles.getTextColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
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
              Image.asset(
                'assets/icons/ic_matakuliah.png',
                height: 70,
                width: 70,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            jadwal.namaMatkul!,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_location.png',
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(jadwal.namaRuangan!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_jumlahSKS.png',
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text("${jadwal.durasi!} SKS"),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
