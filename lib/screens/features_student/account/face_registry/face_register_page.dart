import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/account/register_face_controller.dart';
import 'package:stipres/screens/features_student/account/face_registry/face_guide.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;
import 'package:stipres/screens/reusable/custom_header.dart';
// import 'face_register_guide_page.dart'; // uncomment setelah file dibuat

class FaceRegisterPage extends StatelessWidget {
  FaceRegisterPage({Key? key}) : super(key: key);
  final _controller = Get.find<RegisterFaceController>();

  @override
  Widget build(BuildContext context) {
    final bool dark = styles.isDarkMode(context);

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          CustomHeader(
            title: "Presensi dengan Deteksi Wajah",
            backgroundColor: styles.getMainColor(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // ─── Icon Wajah ───────────────────────────────────
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.white.withOpacity(0.05)
                          : blueColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 60,
                        color: blueColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Deskripsi ────────────────────────────────────
                  Text(
                    "Lakukan presensi secara akurat dan efektif menggunakan Deteksi Wajah",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: styles.getSecondaryTextColor(context),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ─── Card Manajemen Wajah ─────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF1A1F24) : whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: Text(
                            "Manajemen Wajah",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: styles.getTextColor(context),
                            ),
                          ),
                        ),

                        const Divider(height: 24),

                        // ─── Status wajah terdaftar ───────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: blueColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.face,
                                  color: blueColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Data Wajah",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: styles.getTextColor(context),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(() {
                                      final status =
                                          _controller.isAvailable.value;

                                      return Text(
                                        (!status)
                                            ? "Belum ada data wajah terdaftar"
                                            : "Data wajah sudah terdaftar",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: styles
                                              .getSecondaryTextColor(context),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                              // Badge status
                              Obx(() {
                                final status = _controller.isAvailable.value;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (!status)
                                        ? redColor.withOpacity(0.1)
                                        : greenColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    (!status) ? "Belum ada" : "Tersedia",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: (!status) ? redColor : greenColor,
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ─── Tombol Tambah Wajah ──────────────────
                        Obx(() {
                          final status = _controller.isAvailable.value;
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Get.toNamed(
                                          "/student/face-register-guide-screen");
                                    },
                                    icon: Icon(
                                        (!status)
                                            ? Icons.add_circle_outline
                                            : Icons.change_circle_outlined,
                                        color: blueColor,
                                        size: 20),
                                    label: Text(
                                      (!status)
                                          ? "Tambahkan Data Wajah"
                                          : "Ganti Data Wajah",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: blueColor,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      side: BorderSide(
                                          color: blueColor, width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  )));
                        })
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Info Card ────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: blueColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: blueColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Data wajah digunakan untuk verifikasi presensi. Pastikan pencahayaan cukup saat mendaftarkan wajah.",
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
        ],
      ),
    );
  }
}
