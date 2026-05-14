import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_detail_controller.dart';
import 'package:stipres/models/lecturers/list_detail_presence_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/detail_presence/presence_information.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/detail_presence/student_biodata_card.dart';

class PresenceDetailCard extends StatelessWidget {
  final ListDetailPresensi mahasiswa;

  PresenceDetailCard({super.key, required this.mahasiswa});

  final _controller = Get.find<PresenceDetailController>();

  double _sp(BuildContext ctx, double size) {
    final w = MediaQuery.of(ctx).size.width;
    return size * (w / 390).clamp(0.80, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final String iconPath = mahasiswa.jenisKelamin!.toLowerCase() == "p"
        ? 'assets/icons/ic_mahasiswi2.png'
        : 'assets/icons/ic_mahasiswa2.png';

    final double iconSize = _sp(context, 60);
    final double chipW = _sp(context, 70);
    final double chipH = _sp(context, 24);
    final double nimFs = _sp(context, 13);
    final double namaFs = _sp(context, 15);
    final double btnFs = _sp(context, 11);
    final double btnPadH = _sp(context, 10);
    final double btnPadV = _sp(context, 5);
    final double btnMinH = _sp(context, 28);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: const Color(0xFFE6DFF5),
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(_sp(context, 14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row: avatar + info + chip ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar + status chip
                    Column(
                      children: [
                        Image.asset(
                          iconPath,
                          height: iconSize,
                          width: iconSize,
                        ),
                        const SizedBox(height: 6),
                        _buildModeChip(
                          mahasiswa.keterangan!,
                          chipW,
                          chipH,
                          _sp(context, 11),
                        ),
                      ],
                    ),

                    SizedBox(width: _sp(context, 12)),

                    // NIM & Nama
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mahasiswa.nim!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: nimFs,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF555555),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mahasiswa.nama!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: namaFs,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F1F1F),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: _sp(context, 12)),

                // ── Row: Biodata + Lihat Detail buttons ────────
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Biodata',
                        fontSize: btnFs,
                        padH: btnPadH,
                        padV: btnPadV,
                        minHeight: btnMinH,
                        icon: Icons.person_outline_rounded,
                        onPressed: () async {
                          await _controller.fetchBiodata(mahasiswa.nim!);
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: StudentBiodataCard(
                                nama: _controller.biodata.value?.nama ?? "-",
                                nim: _controller.biodata.value?.nim ?? "-",
                                semester: _controller.biodata.value?.semester
                                        .toString() ??
                                    "-",
                                prodi:
                                    _controller.biodata.value?.namaProdi ?? "-",
                                fotoAssetPath:
                                    _controller.biodata.value?.foto ?? "",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: _sp(context, 8)),
                    Expanded(
                      child: _ActionButton(
                        label: 'Lihat Detail',
                        fontSize: btnFs,
                        padH: btnPadH,
                        padV: btnPadV,
                        minHeight: btnMinH,
                        icon: Icons.info_outline_rounded,
                        onPressed: () async {
                          await _controller
                              .fetchDetailMahasiswa(mahasiswa.nim!);
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: PresenceInformationCard(
                                waktuPresensi:
                                    _controller.detail.value?.waktu ?? '-',
                                keterangan:
                                    _controller.detail.value?.keterangan ?? '-',
                                alasan: _controller.detail.value?.alasan ?? '-',
                                buktiFilePath:
                                    _controller.detail.value?.bukti ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable action button ─────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final double fontSize;
  final double padH;
  final double padV;
  final double minHeight;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.fontSize,
    required this.padH,
    required this.padV,
    required this.minHeight,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6D0082),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        minimumSize: Size(0, minHeight),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: fontSize + 2),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

// ── Status chip ────────────────────────────────────────────────
Widget _buildModeChip(
    String mode, double width, double height, double fontSize) {
  final lower = mode.toLowerCase();
  final bool isHadir = lower == 'hadir';
  final bool isIzin = lower == 'izin';
  final bool isSakit = lower == 'sakit';

  final Color color = isHadir
      ? const Color(0xFF00A126)
      : isIzin
          ? const Color(0xFFEAA904)
          : isSakit
              ? const Color(0xFF0496EA)
              : const Color(0xFFEA0408);

  final String label = isHadir
      ? 'Hadir'
      : isIzin
          ? 'Izin'
          : isSakit
              ? 'Sakit'
              : 'Alpa';

  return Container(
    width: width,
    height: height,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
