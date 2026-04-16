import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/models/students/lecture_model.dart';

class PerkuliahanCard extends StatelessWidget {
  final LectureModelApi data;

  const PerkuliahanCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFC0EFC9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFC8C8C8),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            // SEMESTER COLUMN
            Container(
              width: 90,
              height: 170, // fix height supaya sejajar
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 136, 62),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Semester',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.semester.toString(),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // MAIN CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mata Kuliah
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      // Background merah (menyesuaikan tinggi ikon)
                      Container(
                        margin: const EdgeInsets.only(
                            left: 28), // supaya gak nabrak ikon
                        height: 36, // sama dengan tinggi ikon
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          data.namaMatkul,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Ikon di atas background
                      Positioned(
                        // sedikit ke atas biar seimbang
                        child: Image.asset(
                          "assets/icons/ic_book2.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  PerkuliahanChip(
                    iconPath: "assets/icons/ic_calendar2.png",
                    text: data.tglPresensi,
                  ),
                  const SizedBox(height: 8),
                  PerkuliahanChip(
                    iconPath: "assets/icons/ic_lecturer.png",
                    text: data.namaDosen!,
                  ),
                  const SizedBox(height: 8),
                  PerkuliahanChip(
                    iconPath: "assets/icons/ic_clock.png",
                    text: "${data.durasiPresensi} WIB",
                  ),
                  const SizedBox(height: 8),

                  // Zoom Link

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/ic_link.png", width: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: data.linkZoom),
                          readOnly: true,
                          style: GoogleFonts.plusJakartaSans(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Ripple animation button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: data.linkZoom),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Link Zoom berhasil disalin!"),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            child: Row(
                              children: [
                                Image.asset("assets/icons/ic_copy.png",
                                    width: 20),
                                const SizedBox(width: 4),
                                const Text("Salin",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight
                                            .normal, // Add a comma here
                                        color: Color(0xFF168200))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerkuliahanChip extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;

  const PerkuliahanChip({
    super.key,
    required this.iconPath,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AutoSizeText(
              text,
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
