import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_detail_controller.dart';
import 'package:stipres/models/lecturers/list_detail_presence_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/detail_presence/presence_information.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/detail_presence/student_biodata_card.dart'; // pastikan path ini sesuai

class PresenceDetailCard extends StatelessWidget {
  final ListDetailPresensi mahasiswa;

  PresenceDetailCard({super.key, required this.mahasiswa});

  final _controller = Get.find<PresenceDetailController>();

  @override
  Widget build(BuildContext context) {
    String iconPath = mahasiswa.jenisKelamin!.toLowerCase() == "p"
        ? 'assets/icons/ic_mahasiswi2.png'
        : 'assets/icons/ic_mahasiswa2.png';

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 8), // Tambah jarak bawah antar card
      child: Material(
        color: const Color(0xFFE6DFF5),
        elevation: 3,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          iconPath,
                          height: 70,
                          width: 70,
                        ),
                        const SizedBox(height: 8),
                        _buildModeChip(mahasiswa.keterangan!),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mahasiswa.nim!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mahasiswa.nama!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F1F1F),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol Biodata
              Positioned(
                  top: 8,
                  right: 90,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6D0082),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size(0, 32),
                      ),
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
                      child: Text(
                        'Biodata',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )),

              Positioned(
                top: 8,
                right: 8,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D0082),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size(0, 32),
                    ),
                    onPressed: () async {
                      await _controller.fetchDetailMahasiswa(mahasiswa.nim!);
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
                    child: Text(
                      'Lihat Detail',
                      style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildModeChip(String mode) {
  bool isHadir = mode.toLowerCase() == 'hadir';
  bool isIzin = mode.toLowerCase() == 'izin';
  bool isSakit = mode.toLowerCase() == 'sakit';
  return Container(
    width: 70,
    height: 25,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isHadir
          ? Color(0xFF00A126) // Green for "Hadir"
          : isIzin
              ? Color(0xFFEAA904) // Yellow for "Izin"
              : isSakit
                  ? Color(0xFF0496EA)
                  : Color(0xFFEA0408), // Default color for "Alpa"
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      isHadir
          ? 'Hadir'
          : isIzin
              ? 'Izin'
              : isSakit
                  ? 'Sakit'
                  : 'Alpa',
      style: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
