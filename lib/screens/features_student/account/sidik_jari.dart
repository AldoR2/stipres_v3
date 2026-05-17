import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/account/biometric_controller.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class SidikJari extends StatefulWidget {
  SidikJari({Key? key}) : super(key: key);

  @override
  State<SidikJari> createState() => _SidikJariState();
}

class _SidikJariState extends State<SidikJari> {
  final _controller = Get.find<BiometricController>();

  @override
  Widget build(BuildContext context) {
    final bool dark = styles.isDarkMode(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          CustomHeader(
            title: "Sidik Jari",
            backgroundColor: styles.getMainColor(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  // ─── Icon Sidik Jari ─────────────────────────────
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
                      child: Image.asset(
                        'assets/icons/ic_fingerprint3.png',
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // ─── Deskripsi ───────────────────────────────────
                  Text(
                    'Akses STIPRES dengan cara yang aman dan mudah menggunakan sidik jari',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: styles.getSecondaryTextColor(context),
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // ─── Card Pengaturan Sidik Jari ──────────────────
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
                        // ── Header Card ──────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: Text(
                            "Pengaturan Sidik Jari",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: styles.getTextColor(context),
                            ),
                          ),
                        ),

                        const Divider(height: 24),

                        // ── Toggle Login Sidik Jari ──────────────
                        Obx(() {
                          final isEnabled =
                              _controller.isBiometricEnabled.value;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 16, 20),
                            child: InkWell(
                              onTap: () {
                                _controller.toggleBiometric(!isEnabled);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  // Icon
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: isEnabled
                                          ? blueColor.withOpacity(0.1)
                                          : styles
                                              .getSecondaryTextColor(context)
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/ic_fingerprint2.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // Label
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Login dengan sidik jari",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: styles.getTextColor(context),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isEnabled ? "Aktif" : "Nonaktif",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: isEnabled
                                                ? greenColor
                                                : styles.getSecondaryTextColor(
                                                    context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Switch
                                  Transform.scale(
                                    scale: 0.85,
                                    child: Switch(
                                      value: isEnabled,
                                      onChanged: (bool newValue) {
                                        _controller.toggleBiometric(newValue);
                                      },
                                      activeColor: blueColor,
                                      activeTrackColor:
                                          blueColor.withOpacity(0.25),
                                      inactiveThumbColor: Colors.grey,
                                      inactiveTrackColor:
                                          const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // ─── Info Card ───────────────────────────────────
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
                            "Sidik jari digunakan untuk mempermudah login. Pastikan sidik jari sudah terdaftar di perangkat Anda.",
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

                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
