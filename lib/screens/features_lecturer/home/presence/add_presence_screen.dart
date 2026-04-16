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

class _AddPresenceScreenState extends State<AddPresenceScreen>
    with SingleTickerProviderStateMixin {
  final _controller = Get.find<AddPresenceController>();
  final jenisPertemuan = ['Teori', 'Praktik'];

  final List<String> semuaPertemuan =
      List.generate(32, (i) => (i + 1).toString());

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String?> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: styles.getTextColor(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          items: items
              .map(
                  (e) => DropdownMenuItem(value: e ?? '', child: Text(e ?? '')))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: whiteColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: styles.getOutlined(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: styles.getOutlined(context)), // tambahkan ini
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 0, 80, 145), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: styles.getTextColor(context))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLength: 254,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: whiteColor,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 79, 176, 255)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // tambahkan ini
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 0, 80, 145), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField2({
    required String label,
    required String? text,
    required String hint,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: styles.getTextColor(context))),
        const SizedBox(height: 6),
        TextFormField(
          style: TextStyle(
            color: enabled ? styles.getTextColor(context) : Colors.grey[600],
          ),
          decoration: InputDecoration(
            labelText: text,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[200],
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          readOnly: !enabled,
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal Presensi',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: styles.getTextColor(context))),
        const SizedBox(height: 6),
        Obx(() {
          return GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) _controller.selectedDate.value = picked;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _controller.selectedDate.value != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(_controller.selectedDate.value!)
                        : 'Pilih tanggal',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today, size: 18),
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _buildTimePickers(BuildContext context) {
    return Row(
      children: [
        Obx(() {
          return Expanded(
            child: _buildTimePicker(
              label: 'Jam Awal',
              time: _controller.jamAwal.value,
              onTap: () async {
                final picked = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (picked != null) _controller.jamAwal.value = picked;
              },
            ),
          );
        }),
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 20),
          child: Icon(Icons.swap_horiz, size: 20, color: Colors.blue),
        ),
        Obx(() {
          return Expanded(
            child: _buildTimePicker(
              label: 'Jam Akhir',
              time: _controller.jamAkhir.value,
              onTap: () async {
                final picked = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (picked != null) _controller.jamAkhir.value = picked;
              },
            ),
          );
        })
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

  @override
  Widget build(BuildContext context) {
    // final bool isAktif = _controller.selectedStatus.value == 'Aktif';

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(title: 'Presensi Mata Kuliah'),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Presensi",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: blueColor),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Mohon isi data dibawah ini",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: styles.getTextColor(context)),
                      ),
                      Divider(
                        color: Color(0xFFDADADA),
                        thickness: 1,
                        height: 20,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dropdown Program Studi
                              Obx(() {
                                return _buildDropdownField(
                                    label: "Program Studi",
                                    value: _controller
                                            .selectedProdiName.value.isNotEmpty
                                        ? _controller.selectedProdiName.value
                                        : null,
                                    hint: "Silahkan pilih program studi",
                                    items: _controller.listProdi
                                        .map((e) => e.namaProdi)
                                        .toList(),
                                    onChanged: (val) {
                                      _controller.selectedProdiName.value =
                                          val ?? "";

                                      final selected = _controller.listProdi
                                          .firstWhere(
                                              (e) =>
                                                  e.namaProdi
                                                      .toLowerCase()
                                                      .trim() ==
                                                  val!.toLowerCase().trim(),
                                              orElse: () => DataProdi(
                                                  id: '', namaProdi: ''));

                                      _controller.selectedProdiMap.value = {
                                        'id': selected.id,
                                        'nama_prodi': selected.namaProdi,
                                      };

                                      _controller.validateMatkul();
                                      _controller.validateDisabledPertemuans();
                                    });
                              }),
                              const SizedBox(height: 12),
                              Obx(() {
                                return _buildDropdownField(
                                    label: "Semester",
                                    value: _controller
                                            .selectedSemester.value.isNotEmpty
                                        ? _controller.selectedSemester.value
                                        : null,
                                    hint: "Silahkan pilih semester",
                                    items: [
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8'
                                    ],
                                    onChanged: (val) {
                                      _controller.selectedSemester.value = val!;
                                      _controller.validateMatkul();
                                      _controller.validateDisabledPertemuans();
                                    });
                              }),
                              const SizedBox(height: 12),
                              Obx(() {
                                return _buildTextField2(
                                  label: "Tahun Ajaran",
                                  hint: "Tahun Ajaran ",
                                  text: _controller.tahunAjaran.value.isNotEmpty
                                      ? _controller.tahunAjaran.value
                                      : null,
                                  enabled: false,
                                );
                              }),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Obx(() {
                                        return _buildDropdownField(
                                            label: "Nama Matkul",
                                            value: _controller.selectedMatkul
                                                    .value.isNotEmpty
                                                ? _controller
                                                    .selectedMatkul.value
                                                : null,
                                            hint: "Pilih matkul",
                                            items: _controller.listMatkul
                                                .map((e) => e.namaMatkul)
                                                .toList(),
                                            onChanged: (val) {
                                              final selected = _controller
                                                  .listMatkul
                                                  .firstWhere(
                                                (e) => e.namaMatkul == val,
                                                orElse: () => MatkulModel(
                                                    idMatkul: 0,
                                                    kodeMatkul: '',
                                                    namaMatkul: ''),
                                              );

                                              _controller.selectedMatkul.value =
                                                  val ?? "";

                                              _controller
                                                  .selectedMatkulMap.value = {
                                                'id': selected.idMatkul
                                                    .toString(),
                                                'nama_matkul':
                                                    selected.namaMatkul!,
                                                'kode_matkul':
                                                    selected.kodeMatkul!,
                                              };
                                              _controller
                                                  .validateDisabledPertemuans();
                                            });
                                      })),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 20),
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 20, color: Colors.blue),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Obx(() {
                                        return _buildTextField2(
                                          label: "Kode Matkul",
                                          hint: "Kode Matkul",
                                          text: _controller
                                                  .selectedMatkulMap.isNotEmpty
                                              ? _controller.selectedMatkulMap[
                                                  'kode_matkul']
                                              : "Kode Matkul",
                                          enabled: false,
                                        );
                                      })),
                                ],
                              ),
                              const SizedBox(height: 12),
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
                                              color:
                                                  styles.getOutlined(context)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  styles.getOutlined(context)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 0, 80, 145),
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
                              const SizedBox(height: 12),
                              // Tanggal Presensi
                              _buildDatePicker(context),
                              const SizedBox(height: 12),
                              Obx(() {
                                final statusList =
                                    _controller.listStatus.toList();
                                final selected = statusList.contains(
                                        _controller.selectedStatus.value)
                                    ? _controller.selectedStatus.value
                                    : null;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdownField(
                                        label: "Status Presensi",
                                        value: selected,
                                        hint: "Silahkan pilih status",
                                        items: statusList,
                                        onChanged: (val) {
                                          _controller.selectedStatus.value =
                                              val ?? "";
                                        }),
                                    const SizedBox(height: 12),
                                    // Slide down/up animation for jam awal, akhir, dan link zoom
                                    ClipRect(
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: _controller
                                                    .selectedStatus.value ==
                                                "Aktif"
                                            ? Column(
                                                children: [
                                                  Obx(() {
                                                    final selected = jenisPertemuan
                                                            .toList()
                                                            .contains(_controller
                                                                .selectedJenis
                                                                .value)
                                                        ? _controller
                                                            .selectedJenis.value
                                                        : null;
                                                    return _buildDropdownField(
                                                        label:
                                                            "Jenis Pertemuan",
                                                        value: selected,
                                                        hint:
                                                            "Silahkan pilih jenis pertemuan",
                                                        items: jenisPertemuan
                                                            .toList(),
                                                        onChanged: (val) {
                                                          _controller
                                                                  .selectedJenis
                                                                  .value =
                                                              val ?? "";
                                                        });
                                                  }),
                                                  const SizedBox(height: 12),
                                                  _buildTimePickers(context),
                                                  const SizedBox(height: 12),
                                                  _buildTextField(
                                                    label: "Link Zoom",
                                                    hint: "Masukkan link zoom",
                                                    controller: _controller
                                                        .linkZoomController,
                                                  ),
                                                  const SizedBox(height: 30),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: Text(
                                        'Submit',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  })),
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
        ],
      ),
    );
  }
}
