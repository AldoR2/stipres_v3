import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/add_presence_controller.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/models/lecturers/matkul_model.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AddPresenceScreen extends StatefulWidget {
  const AddPresenceScreen({super.key});

  @override
  State<AddPresenceScreen> createState() => _AddPresenceScreenState();
}

class _AddPresenceScreenState extends State<AddPresenceScreen> {
  final _controller = Get.find<AddPresenceController>();

  final jenisPertemuan = ['Teori', 'Praktik'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          CustomHeader(title: 'Presensi Mata Kuliah'),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Presensi",
                    style: TextStyle(fontSize: 16, color: blueColor),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ================= PROGRAM STUDI =================
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value:
                                  _controller.selectedProdiName.value.isNotEmpty
                                      ? _controller.selectedProdiName.value
                                      : null,
                              hint: const Text("Silahkan pilih program studi"),
                              items: _controller.listProdi
                                  .map((e) => DropdownMenuItem(
                                        value: e.namaProdi,
                                        child: Text(e.namaProdi ?? ""),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                _controller.selectedProdiName.value = val ?? "";
                              },
                            );
                          }),

                          const SizedBox(height: 12),

                          /// ================= MATKUL =================
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value: _controller.selectedMatkul.value.isNotEmpty
                                  ? _controller.selectedMatkul.value
                                  : null,
                              hint: const Text("Pilih matkul"),
                              items: _controller.listMatkul
                                  .map((e) => DropdownMenuItem(
                                        value: e.namaMatkul,
                                        child: Text(e.namaMatkul ?? ""),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                _controller.selectedMatkul.value = val ?? "";
                              },
                            );
                          }),

                          const SizedBox(height: 12),

                          /// ================= TANGGAL =================
                          Obx(() {
                            return GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  _controller.selectedDate.value = picked;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Text(
                                  _controller.selectedDate.value != null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          _controller.selectedDate.value!)
                                      : "Pilih tanggal",
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 12),

                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value: _controller.selectedStatus.value.isNotEmpty
                                  ? _controller.selectedStatus.value
                                  : null,
                              hint: const Text("Silahkan pilih status"),
                              items: _controller.listStatus
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                _controller.selectedStatus.value = val ?? "";
                              },
                            );
                          }),

                          /// ================= LOKASI (FRONTEND ONLY) =================
                          Obx(() {
                            if (_controller.selectedStatus.value != "Aktif") {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),

                                Text(
                                  "Lokasi Presensi",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: styles.getTextColor(context),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                GestureDetector(
                                  onTap: () {
                                    _controller.openLocationPicker(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _controller.selectedLokasi.value
                                                    .isNotEmpty
                                                ? _controller
                                                    .selectedLokasi.value
                                                : "Pilih lokasi",
                                            style: TextStyle(
                                              color: _controller.selectedLokasi
                                                      .value.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.location_on,
                                            color: Colors.blue),
                                      ],
                                    ),
                                  ),
                                ),

                                /// hanya display (tidak ke API)
                                if (_controller.latitude.value.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Lat: ${_controller.latitude.value}, Lng: ${_controller.longitude.value}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),

                          const SizedBox(height: 24),

                          /// ================= SUBMIT =================
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _controller.submitPresence,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                ),
                                child: const Text("Submit"),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
