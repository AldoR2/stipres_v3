import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_detail_controller.dart';

class PresenceInformationCard extends StatelessWidget {
  final String waktuPresensi;
  final String keterangan;
  final String alasan;
  final String? buktiFilePath;

  PresenceInformationCard({
    super.key,
    required this.waktuPresensi,
    required this.keterangan,
    required this.alasan,
    this.buktiFilePath,
  });

  final _controller = Get.find<PresenceDetailController>();
  final isExpanded = false.obs;

  Logger log = Logger();

  @override
  Widget build(BuildContext context) {
    log.d(buktiFilePath);
    return SizedBox(
      height: 395,
      width: 350,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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

              const Positioned(
                top: 16,
                child: Text(
                  "Detail Presensi Mahasiswa",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              Positioned(
                top: 60,
                left: 20,
                right: 20,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowInfo('Waktu Presensi', waktuPresensi),
                      const SizedBox(height: 12),
                      _buildRowInfo('Keterangan', keterangan),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              'Bukti',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF005095),
                              ),
                            ),
                          ),
                          Text(
                            ":",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF005095),
                            ),
                          ),
                          const SizedBox(width: 4),
                          buktiFilePath != null && buktiFilePath!.isNotEmpty
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: InkWell(
                                      onTap: (!_controller
                                              .isButtonEnabled.value)
                                          ? null
                                          : () {
                                              print("BUKTI DITEKAN");
                                              _controller
                                                  .openBukti(buktiFilePath!);
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Lihat Bukti",
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  "-",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF005095),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildExpandableAlasan('Alasan', alasan),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF005095),
            ),
          ),
        ),
        Text(": "),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF005095),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableAlasan(String label, String value) {
    final maxLines = 5;
    final textStyle = GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF005095),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 110,
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF005095),
                ),
              ),
            ),
            const Text(": "),
            Expanded(child: Obx(() {
              return isExpanded.value
                  ? SizedBox(
                      height: 130,
                      child: SingleChildScrollView(
                        child: Text(
                          value,
                          style: textStyle,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: textStyle,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    );
            })),
          ],
        ),
        if (value.length > 100)
          Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                return TextButton(
                  onPressed: () {
                    isExpanded.value = !isExpanded.value;
                  },
                  child: Text(
                    isExpanded.value ? 'Sembunyikan' : 'Lihat Selengkapnya',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                );
              })),
      ],
    );
  }
}
