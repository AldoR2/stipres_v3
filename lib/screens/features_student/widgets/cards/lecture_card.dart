import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/models/students/lecture_model.dart';

class PerkuliahanCard extends StatelessWidget {
  final LectureModelApi data;

  const PerkuliahanCard({super.key, required this.data});

  static const _green900 = Color(0xFF1B5E20);
  static const _green700 = Color(0xFF2E7D32);
  static const _green500 = Color(0xFF43A047);
  static const _green100 = Color(0xFFC8E6C9);
  static const _green50 = Color(0xFFE8F5E9);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _green50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _green100, width: 1),
        boxShadow: [
          BoxShadow(
            color: _green700.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Nama Matkul ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: _green700,
              borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _green500,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/icons/ic_book2.png",
                    width: 22,
                    height: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AutoSizeText(
                    data.namaMatkul,
                    style: GoogleFonts.plusJakartaSans(
                      color: _white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _green900.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Smt ${data.semester}',
                    style: GoogleFonts.plusJakartaSans(
                      color: _white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Info rows
                _InfoRow(
                  iconPath: "assets/icons/ic_calendar2.png",
                  label: "Tanggal",
                  value: data.tglPresensi,
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  iconPath: "assets/icons/ic_lecturer.png",
                  label: "Dosen",
                  value: data.namaDosen ?? '-',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  iconPath: "assets/icons/ic_clock.png",
                  label: "Waktu",
                  value: "${data.durasiPresensi} WIB",
                ),

                const SizedBox(height: 14),

                // Divider
                Container(
                  height: 1,
                  color: _green100,
                ),

                const SizedBox(height: 14),

                // ── Link Zoom ──────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: _green100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        "assets/icons/ic_link.png",
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: _white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _green100),
                        ),
                        child: AutoSizeText(
                          data.linkZoom ?? '-',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.blue.shade700,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue.shade700,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Salin
                    Material(
                      color: _green700,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: data.linkZoom ?? "Kosong"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Link Zoom berhasil disalin!",
                                style:
                                    GoogleFonts.plusJakartaSans(color: _white),
                              ),
                              backgroundColor: _green700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 9),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_copy.png",
                                width: 16,
                                height: 16,
                                color: _white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Salin",
                                style: GoogleFonts.plusJakartaSans(
                                  color: _white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const _InfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  static const _green700 = Color(0xFF2E7D32);
  static const _green50 = Color(0xFFE8F5E9);
  static const _green100 = Color(0xFFC8E6C9);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _green100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(iconPath, width: 18, height: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _green700.withOpacity(0.6),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 1),
            SizedBox(
              width: 220,
              child: AutoSizeText(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B5E20),
                ),
                maxLines: 1,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
