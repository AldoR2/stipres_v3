import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/screens/features_student/account/face_registry/face_camera_page.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;
// import 'face_camera_page.dart'; // uncomment setelah file dibuat

class FaceRegisterGuidePage extends StatelessWidget {
  const FaceRegisterGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool dark = styles.isDarkMode(context);

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          // ─── Header ─────────────────────────────────────────────
          CustomHeader(
            title: "Petunjuk wajah",
            backgroundColor: styles.getMainColor(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ─── Ilustrasi Scanner Wajah ───────────────────────
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.white.withOpacity(0.05)
                          : blueColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Frame sudut
                        CustomPaint(
                          size: const Size(140, 140),
                          painter: _FaceFramePainter(color: blueColor),
                        ),
                        // Icon wajah
                        Icon(
                          Icons.face_retouching_natural,
                          size: 72,
                          color: blueColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Judul ─────────────────────────────────────────
                  Text(
                    "Daftarkan Wajah Anda",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: styles.getTextColor(context),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── Deskripsi ─────────────────────────────────────
                  Text(
                    "Gunakan wajah Anda untuk presensi secara otomatis dan aman. Data wajah akan digunakan untuk presensi kehadiran.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: styles.getSecondaryTextColor(context),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── Checklist Persiapan ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF1A1F24) : whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Persiapan sebelum mendaftar",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: styles.getTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ChecklistItem(
                          text: "Wajah terlihat jelas",
                          context: context,
                        ),
                        _ChecklistItem(
                          text: "Pencahayaan cukup",
                          context: context,
                        ),
                        _ChecklistItem(
                          text: "Lepas alat yang menutupi muka",
                          context: context,
                        ),
                        _ChecklistItem(
                          text: "Berada di area stabil",
                          context: context,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── Info proses ───────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: blueColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.photo_camera_outlined,
                            color: blueColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Kamera akan memandu Anda melalui 3 posisi wajah: depan, kiri, dan kanan.",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: blueColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ─── Tombol Mulai ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(FaceCameraPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Mulai Pendaftaran",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget Checklist Item ────────────────────────────────────────────────────
class _ChecklistItem extends StatelessWidget {
  final String text;
  final BuildContext context;
  final bool isLast;

  const _ChecklistItem({
    required this.text,
    required this.context,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: greenColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: greenColor, size: 15),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: styles.getTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom Painter Frame Sudut ───────────────────────────────────────────────
class _FaceFramePainter extends CustomPainter {
  final Color color;
  _FaceFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double corner = 20;
    const double padding = 8;

    final left = padding;
    final top = padding;
    final right = size.width - padding;
    final bottom = size.height - padding;

    // Sudut kiri atas
    canvas.drawLine(Offset(left, top + corner), Offset(left, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left + corner, top), paint);

    // Sudut kanan atas
    canvas.drawLine(Offset(right - corner, top), Offset(right, top), paint);
    canvas.drawLine(Offset(right, top), Offset(right, top + corner), paint);

    // Sudut kiri bawah
    canvas.drawLine(Offset(left, bottom - corner), Offset(left, bottom), paint);
    canvas.drawLine(Offset(left, bottom), Offset(left + corner, bottom), paint);

    // Sudut kanan bawah
    canvas.drawLine(
        Offset(right - corner, bottom), Offset(right, bottom), paint);
    canvas.drawLine(
        Offset(right, bottom), Offset(right, bottom - corner), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
