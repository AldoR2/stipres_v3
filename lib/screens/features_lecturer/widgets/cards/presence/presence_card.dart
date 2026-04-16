import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_controller.dart';
import 'package:stipres/models/lecturers/presence_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/dialog/presence/delete_presence_dialog.dart';
import 'package:stipres/screens/features_lecturer/widgets/dialog/presence/edit_presence_dialog.dart';

class PresenceCard extends StatelessWidget {
  final PresensiDosenModel data;

  PresenceCard({
    super.key,
    required this.data,
  });

  final _controller = Get.find<PresenceController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE6DFF5), // ← latar pindah ke sini
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Get.toNamed("/lecturer/presence-detail-screen",
              arguments: data.presensisId);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.purple.withOpacity(0.2),
        highlightColor: Colors.purple.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC8C8C8), width: 0.5),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 252, 252, 252).withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 105,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Semester",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      data.semester.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PresensiChip(jam: data.durasiPresensi!),
                    const SizedBox(height: 6),
                    Text(
                      data.namaMatkul,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    IconTextInfo(
                      iconPath: 'assets/icons/ic_matakuliah.png',
                      text: data.kodeMatkul,
                    ),
                    const SizedBox(height: 4),
                    IconTextInfo(
                        iconPath: 'assets/icons/ic_duration.png',
                        text: "${data.durasiMatkul} Jam"),
                  ],
                ),
              ),
              Container(
                height: 105,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => EditPresensiDialog(
                                  presensisId: data.presensisId.toString(),
                                  awal: data.jamAwal,
                                  akhir: data.jamAkhir,
                                ),
                              );

                              if (result != null) {
                                final jamAwal = result['jamAwal'] as TimeOfDay?;
                                final jamAkhir =
                                    result['jamAkhir'] as TimeOfDay?;

                                print('Jam Awal: ${jamAwal?.format(context)}');
                                print(
                                    'Jam Akhir: ${jamAkhir?.format(context)}');
                              }
                            },
                            borderRadius: BorderRadius.circular(24),
                            splashColor: Colors.purple.withOpacity(0.2),
                            hoverColor: Colors.purple.withOpacity(0.05),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/ic_edit.png',
                                height: 20,
                                width: 20,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final confirm =
                                  await showDeleteConfirmationDialog(context);
                              confirm == true
                                  ? _controller.deletePresence(
                                      data.presensisId.toString())
                                  : null;
                            },
                            borderRadius: BorderRadius.circular(24),
                            splashColor: Colors.purple.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/ic_delete.png',
                                height: 20,
                                width: 20,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconTextInfo extends StatelessWidget {
  final String iconPath;
  final String text;

  const IconTextInfo({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, height: 16, width: 16),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
      ],
    );
  }
}

class PresensiChip extends StatelessWidget {
  final String jam;

  const PresensiChip({super.key, required this.jam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/ic_clock.png', height: 16, width: 16),
          const SizedBox(width: 4),
          Text(
            jam,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
