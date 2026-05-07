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
  final kategoriPresensi = ['Luring', 'Daring'];
  ValueChanged<String>? onChanged;

  final List<String> semuaPertemuan =
      List.generate(32, (i) => (i + 1).toString());

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

                                final selected = _controller.listProdi
                                    .firstWhere(
                                        (e) =>
                                            e.namaProdi.toLowerCase().trim() ==
                                            val!.toLowerCase().trim(),
                                        orElse: () =>
                                            DataProdi(id: '', namaProdi: ''));

                                _controller.selectedProdiMap.value = {
                                  'id': selected.id,
                                  'nama_prodi': selected.namaProdi,
                                };

                                _controller.validateMatkul();
                                _controller.validateDisabledPertemuans();
                              },
                            );
                          }),

                          const SizedBox(height: 12),

                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value:
                                  _controller.selectedSemester.value.isNotEmpty
                                      ? _controller.selectedSemester.value
                                      : null,
                              hint: const Text("Silahkan pilih semester"),
                              items: ['1', '2', '3', '4', '5', '6', '7', '8']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (val) {
                                _controller.selectedSemester.value = val!;
                                _controller.validateMatkul();
                                _controller.validateDisabledPertemuans();
                              },
                            );
                          }),

                          const SizedBox(height: 12),
                          Obx(() {
                            final bool enabled =
                                _controller.tahunAjaran.value.isNotEmpty;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Ajaran",
                                    style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: styles.getTextColor(context))),
                                const SizedBox(height: 6),
                                TextFormField(
                                  style: TextStyle(
                                    color: enabled
                                        ? styles.getTextColor(context)
                                        : Colors.grey[600],
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        _controller.tahunAjaran.value.isNotEmpty
                                            ? _controller.tahunAjaran.value
                                            : null,
                                    hintStyle: TextStyle(color: Colors.black),
                                    filled: true,
                                    fillColor: enabled
                                        ? Colors.white
                                        : Colors.grey[200],
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                  readOnly: true,
                                  enabled: enabled,
                                ),
                              ],
                            );
                          }),

                          const SizedBox(
                            height: 12,
                          ),

                          /// ================= MATKUL =================
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value: _controller.selectedMatkul.value.isNotEmpty
                                  ? _controller.selectedMatkul.value
                                  : null,
                              hint: const Text("Pilih matkul"),
                              items: _controller.listMatkul
                                  .map((e) => e.namaMatkul)
                                  .toSet()
                                  .map((nama) => DropdownMenuItem(
                                      value: nama, child: Text(nama ?? "")))
                                  .toList(),
                              onChanged: (val) {
                                final selected =
                                    _controller.listMatkul.firstWhere(
                                  (e) => e.namaMatkul == val,
                                  orElse: () => MatkulModel(
                                      idMatkul: 0,
                                      kodeMatkul: '',
                                      namaMatkul: ''),
                                );
                                _controller.selectedMatkul.value = val ?? "";
                                _controller.selectedMatkulMap.value = {
                                  'id': selected.idMatkul.toString(),
                                  'nama_matkul': selected.namaMatkul!,
                                  'kode_matkul': selected.kodeMatkul!,
                                };
                                _controller.validateDisabledPertemuans();
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
                            final selected = semuaPertemuan.contains(
                                    _controller.selectedPertemuan.value)
                                ? _controller.selectedPertemuan.value
                                : null;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pertemuan Ke-",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: styles.getTextColor(context),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "Silahkan pilih pertemuan",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: whiteColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: styles.getOutlined(context)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: styles.getOutlined(context)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 0, 80, 145),
                                          width: 1),
                                    ),
                                  ),
                                  value: selected,
                                  items: semuaPertemuan.map((pertemuan) {
                                    final isDisabled = _controller
                                        .pertemuanTerpakai
                                        .contains(int.parse(pertemuan));
                                    return DropdownMenuItem<String>(
                                      value: pertemuan,
                                      enabled: !isDisabled,
                                      child: Text(
                                        !isDisabled
                                            ? "Pertemuan $pertemuan"
                                            : "Pertemuan $pertemuan telah digunakan",
                                        style: TextStyle(
                                          color: isDisabled
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      _controller.selectedPertemuan.value =
                                          value;
                                    }
                                  },
                                ),
                              ],
                            );
                          }),

                          SizedBox(
                            height: 12,
                          ),

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

                          Obx(() {
                            if (_controller.selectedStatus.value != "Aktif") {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Obx(() {
                                  final selected = jenisPertemuan
                                          .toList()
                                          .contains(
                                              _controller.selectedJenis.value)
                                      ? _controller.selectedJenis.value
                                      : null;
                                  bool? enabledItem;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Jenis Pertemuan",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: styles
                                                  .getTextColor(context))),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selected,
                                        hint: Text(
                                            "Silahkan pilih jenis pertemuan"),
                                        items: jenisPertemuan
                                            .toList()
                                            .map((e) => DropdownMenuItem(
                                                value: e ?? '',
                                                enabled: (enabledItem != null)
                                                    ? enabledItem
                                                    : true,
                                                child: Text(e ?? '')))
                                            .toList(),
                                        onChanged: (val) {
                                          _controller.selectedJenis.value =
                                              val ?? "";
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              "Silahkan pilih jenis pertemuan",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: whiteColor,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: styles
                                                    .getOutlined(context)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: styles.getOutlined(
                                                    context)), // tambahkan ini
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 0, 80, 145),
                                                width: 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Obx(() {
                                      return Expanded(
                                        child: _buildTimePicker(
                                          label: 'Jam Awal',
                                          time: _controller.jamAwal.value,
                                          onTap: () async {
                                            final picked = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());
                                            if (picked != null)
                                              _controller.jamAwal.value =
                                                  picked;
                                          },
                                        ),
                                      );
                                    }),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 20),
                                      child: Icon(Icons.swap_horiz,
                                          size: 20, color: Colors.blue),
                                    ),
                                    Obx(() {
                                      return Expanded(
                                        child: _buildTimePicker(
                                          label: 'Jam Akhir',
                                          time: _controller.jamAkhir.value,
                                          onTap: () async {
                                            final picked = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());
                                            if (picked != null)
                                              _controller.jamAkhir.value =
                                                  picked;
                                          },
                                        ),
                                      );
                                    })
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Obx(() {
                                  final selected = kategoriPresensi
                                          .toList()
                                          .contains(_controller
                                              .selectedKategori.value)
                                      ? _controller.selectedKategori.value
                                      : null;
                                  return _buildDropdownField(
                                    label: "Jenis Presensi",
                                    value: selected,
                                    hint: "Silahkan pilih jenis presensi",
                                    items: kategoriPresensi,
                                    onChanged: (val) {
                                      _controller.selectedKategori.value = val!;

                                      if (_controller.selectedKategori.value ==
                                          'Luring') {
                                        _controller.linkZoomController.text =
                                            '';
                                      } else {
                                        _controller.selectedRuanganID.value =
                                            '';
                                      }
                                    },
                                  );
                                }),
                                const SizedBox(
                                  height: 12,
                                ),
                                Obx(() {
                                  if (_controller.selectedKategori.value ==
                                      'Daring') {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Link Zoom  ",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: styles
                                                    .getTextColor(context))),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller:
                                              _controller.linkZoomController,
                                          onChanged: onChanged,
                                          maxLength: 254,
                                          decoration: InputDecoration(
                                            hintText: "Masukkan link zoom",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            filled: true,
                                            fillColor: whiteColor,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 79, 176, 255)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .blue), // tambahkan ini
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 0, 80, 145),
                                                  width: 1),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    final selected = _controller.listRuangan
                                            .toList()
                                            .contains(_controller
                                                .selectedRuanganID.value)
                                        ? _controller.selectedRuanganID.value
                                        : null;
                                    bool? enabledItem;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Ruangan  ",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: styles
                                                    .getTextColor(context))),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          value: selected,
                                          hint: Text("Silahkan pilih ruangan"),
                                          items: _controller.listRuangan
                                              .map((e) => DropdownMenuItem(
                                                  value: e.namaRuangan ?? '',
                                                  child: Text(
                                                      e.namaRuangan ?? '')))
                                              .toList(),
                                          onChanged: (val) {
                                            _controller.selectedRuanganID
                                                .value = val ?? "";
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Silahkan pilih ruangan",
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            filled: true,
                                            fillColor: whiteColor,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: styles
                                                      .getOutlined(context)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: styles.getOutlined(
                                                      context)), // tambahkan ini
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 0, 80, 145),
                                                  width: 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                                const SizedBox(height: 6),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Lokasi Presensi",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: styles.getTextColor(context),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                    value: _controller
                                            .selectedLokasiId.value.isNotEmpty
                                        ? _controller.selectedLokasiId.value
                                        : null,
                                    hint: const Text("Pilih lokasi"),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                        )),
                                    items: [
                                      ..._controller.listLokasi.map((lokasi) {
                                        return DropdownMenuItem(
                                          value: lokasi.id.toString(),
                                          child: Text(lokasi.nama ?? ""),
                                        );
                                      }),
                                      const DropdownMenuItem(
                                          value: 'tambah_lokasi',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add_location_alt,
                                                color: Colors.blue,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Tambah Lokasi Baru",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ))
                                    ],
                                    onChanged: (val) {
                                      if (val == 'tambah_lokasi') {
                                        _controller.selectedLokasiId.value =
                                            _controller.selectedLokasiId.value;

                                        _controller.openLocationPicker(context);
                                      } else {
                                        _controller.selectedLokasiId.value =
                                            val!;

                                        final lokasi = _controller.listLokasi
                                            .firstWhere(
                                                (e) => e.id.toString() == val);

                                        _controller.selectedLokasiNama.value =
                                            lokasi.nama ?? "";
                                        _controller.latitude.value =
                                            lokasi.latitude?.toString() ?? "";
                                        _controller.longitude.value =
                                            lokasi.longitude?.toString() ?? '';
                                      }
                                    }),
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

                          SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                return ElevatedButton(
                                  onPressed: (_controller.isEnabled.value)
                                      ? _controller.submitPresence
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }))
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 79, 176, 255)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 80, 145), width: 1.5),
        ),
      );

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: styles.getTextColor(context))),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null ? time.format(context) : 'Pilih waktu',
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(Icons.access_time, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
