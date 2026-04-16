import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_lecturer/home/attendances/attendance_controller.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class CariDataScreen extends StatefulWidget {
  final void Function(String semester, String prodi) onSearch;

  const CariDataScreen({super.key, required this.onSearch});

  @override
  State<CariDataScreen> createState() => _CariDataScreenState();
}

class _CariDataScreenState extends State<CariDataScreen> {
  final _controller = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cari Data Kehadiran Mahasiswa',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: styles.getTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/ic_document.png', height: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Mohon isi data dibawah ini',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Semester',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: styles.getTextColor(context))),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final semesterList = ['1', '2', '3', '4', '5', '6', '7', '8'];
              return DropdownButtonFormField<String>(
                value: _controller.tempSelectedSemester.value.isEmpty
                    ? null
                    : _controller.tempSelectedSemester.value,
                hint: const Text("Silahkan pilih semester"),
                items: semesterList
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) =>
                    _controller.tempSelectedSemester.value = value!,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              );
            }),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Program Studi',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: styles.getTextColor(context))),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: _controller.tempSelectedProdi.value.isEmpty
                    ? null
                    : _controller.tempSelectedProdi.value,
                hint: const Text("Silahkan pilih program studi"),
                items: _controller.prodiMap.entries
                    .map((entry) => DropdownMenuItem<String>(
                        value: entry.key, child: Text(entry.value)))
                    .toList(),
                onChanged: (value) =>
                    _controller.tempSelectedProdi.value = value!,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: (_controller.isSnackbarOpen.value)
                      ? null
                      : () async {
                          if (_controller.tempSelectedSemester.value.isEmpty ||
                              _controller.tempSelectedProdi.value.isEmpty) {
                            _controller.isSnackbarOpen.value = true;
                            Get.snackbar("Gagal", "Penuhi data terlebih dahulu",
                                duration: Duration(seconds: 1));
                            await Future.delayed(Duration(seconds: 2));
                            _controller.isSnackbarOpen.value = false;
                          } else {
                            _controller.selectedSemester.value =
                                _controller.tempSelectedSemester.value;
                            _controller.selectedProdi.value =
                                _controller.tempSelectedProdi.value;
                            widget.onSearch(_controller.selectedSemester.value,
                                _controller.selectedProdi.value);
                            Get.back();
                            await _controller.showStudent();
                          }
                          ;
                        },
                  child: Text('Cari',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
