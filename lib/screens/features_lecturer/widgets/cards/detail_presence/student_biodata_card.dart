import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:ui';

class StudentBiodataCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String semester;
  final String prodi;
  final String fotoAssetPath;

  const StudentBiodataCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.semester,
    required this.prodi,
    required this.fotoAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      width: 350,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background image
            Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/bgBiodataMahasiswa.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Kontainer putih
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: Container(
                height: 230,
                padding: const EdgeInsets.only(
                    top: 60, left: 12, right: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowInfo('Nama', nama),
                      SizedBox(height: 12),
                      _buildRowInfo('NIM', nim),
                      SizedBox(height: 12),
                      _buildRowInfo('Semester', semester),
                      SizedBox(height: 12),
                      _buildRowInfo('Program Studi', prodi),
                    ],
                  ),
                ),
              ),
            ),

            // Foto profil (di atas container putih)
            Positioned(
              top: 60,
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: Get.context!,
                      barrierDismissible: true,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero,
                        // ✅ beri jarak agar tidak full fullscreen
                        child: Stack(
                          children: [
                            // Background blur
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            // Centered Image bulat & diperbesar
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: Center(
                                  child: ClipOval(
                                      child: (fotoAssetPath.isNotEmpty)
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/icons/ic_profile.jpeg",
                                              image: fotoAssetPath,
                                              height: 300,
                                              width: 300,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                "assets/icons/ic_profile.jpeg",
                                                height: 300,
                                                width: 300,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              "assets/icons/ic_profile.jpeg",
                                              height: 300,
                                              width: 300,
                                              fit: BoxFit.cover,
                                            ))),
                            ),
                            // Close button
                            Positioned(
                              top: 20,
                              right: 20,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 30),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipOval(
                      child: (fotoAssetPath.isNotEmpty)
                          ? FadeInImage.assetNetwork(
                              placeholder: "assets/icons/ic_profile.jpeg",
                              image: fotoAssetPath,
                              height: 92,
                              width: 92,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, url, error) =>
                                  Image.asset(
                                "assets/icons/ic_profile.jpeg",
                                height: 92,
                                width: 92,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/icons/ic_profile.jpeg",
                              height: 92,
                              width: 92,
                              fit: BoxFit.cover,
                            ))),
            ),

            // Judul
            const Positioned(
              top: 16,
              child: Text(
                "Biodata Mahasiswa",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.normal,
                color: Color(0xFF005095),
                fontSize: 14),
          ),
        ),
        const Text(": "),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: Color(0xFF005095),
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
