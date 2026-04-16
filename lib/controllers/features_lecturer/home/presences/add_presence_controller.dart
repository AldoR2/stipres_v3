import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_controller.dart';
import 'package:stipres/models/lecturers/active_school_year_model.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/models/lecturers/disabled_pertemuan_model.dart';
import 'package:stipres/models/lecturers/matkul_model.dart';
import 'package:stipres/models/lecturers/presence_request_model.dart';
import 'package:stipres/screens/reusable/failed_dialog.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/screens/reusable/success_dialog.dart';
import 'package:stipres/screens/reusable/upload_data_dialog.dart';
import 'package:stipres/services/lecturer/add_presence_lecturer_service.dart';

class AddPresenceController extends GetxController {
  final dosenId = 0.obs;
  final selectedSemester = ''.obs;
  final idMatkul = ''.obs;
  final tahunAjaran = ''.obs;
  final tahunAjaranId = 0.obs;
  final isEnabled = true.obs;
  final selectedDate = Rx<DateTime?>(null);
  final jamAwal = Rx<TimeOfDay?>(null);
  final jamAwalStr = ''.obs;
  final jamAkhir = Rx<TimeOfDay?>(null);
  final jamAkhirStr = ''.obs;
  final TextEditingController linkZoomController = TextEditingController();

  final selectedProdiName = ''.obs;
  final listProdi = <DataProdi>[].obs;
  final selectedProdiMap = <String, String>{}.obs;

  final selectedMatkul = ''.obs;
  final selectedPertemuan = ''.obs;
  final selectedJenis = ''.obs;
  final pertemuanTerpakai = <int>[].obs;
  final listMatkul = <MatkulModel>[].obs;
  final listPertemuan = <DisabledPertemuansModel>[].obs;
  final selectedStatus = ''.obs;
  final listStatus = [
    'Aktif',
    'Libur',
    'UTS',
    'UAS',
  ];
  final selectedMatkulMap = <String, String>{}.obs;

  final tahunAjar = <TahunAjaranAktif>{}.obs;

  final Logger log = Logger();
  final GetStorage _box = GetStorage();

  final AddPresenceLecturerService addPresenceLecturerService =
      AddPresenceLecturerService();

  @override
  void onInit() {
    super.onInit();
    dosenId.value = _box.read("dosen_id");
    fetchProdi();
    fetchTahunAjaran();
  }

  void validateMatkul() async {
    final idProdi = selectedProdiMap['id'];
    final semester = selectedSemester.value;
    if (semester.isNotEmpty && idProdi != null) {
      fetchMatkul(idProdi, semester);
    } else {
      null;
    }
  }

  void validateDisabledPertemuans() async {
    final prodiId = selectedProdiMap['id'];
    final semester = selectedSemester.value;
    final matkulId = selectedMatkulMap['id'];
    final tahunAjaranIdd = tahunAjaranId.value;
    if (prodiId != null &&
        semester.isNotEmpty &&
        matkulId != null &&
        tahunAjaranIdd != 0) {
      fetchDisabledPertemuans(
          prodiId, semester, matkulId, tahunAjaranIdd.toString());
    } else {
      null;
    }
  }

  void fetchMatkul(String prodiId, String semester) async {
    try {
      listMatkul.clear();
      final result =
          await addPresenceLecturerService.fetchMatkul(prodiId, semester);

      if (result.status == "success") {
        final matkulList = result.data!.whereType<MatkulModel>().toList();
        listMatkul.assignAll(matkulList);

        if (selectedMatkul.value.isNotEmpty) {
          final stillExists = listMatkul
              .any((matkul) => matkul.namaMatkul == selectedMatkul.value);

          if (!stillExists) {
            selectedMatkul.value = "";
            selectedMatkulMap.value = {
              'id': '',
              'nama_matkul': '',
              'kode_matkul': '',
            };
          }
        }
      } else {
        log.e(result.message);
        listMatkul.clear;
        selectedMatkul.value = "";
        selectedMatkulMap.value = {
          'id': '',
          'nama_matkul': '',
          'kode_matkul': '',
        };
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  void fetchTahunAjaran() async {
    try {
      final result = await addPresenceLecturerService.fetchTahunAjaran();

      if (result.status == "success" && result.data != null) {
        final tahunList = result.data!;
        tahunAjaran.value =
            "${tahunList.tahunAwal}/${tahunList.tahunAkhir} ${tahunList.keterangan}";
        tahunAjaranId.value = tahunList.id ?? 0;
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  void fetchProdi() async {
    try {
      final result = await addPresenceLecturerService.fetchProdi();

      if (result.status == "success" && result.data != null) {
        final prodiList = result.data!.whereType<DataProdi>().toList();
        listProdi.assignAll(prodiList);
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  void fetchDisabledPertemuans(String prodiId, String semester, String matkulId,
      String tahunAjaranIdd) async {
    try {
      final result = await addPresenceLecturerService.fetchDisabledPertemuans(
          int.parse(prodiId),
          int.parse(semester),
          int.parse(matkulId),
          int.parse(tahunAjaranIdd));

      if (result.status == "success") {
        final pertemuanList =
            result.data!.whereType<DisabledPertemuansModel>().toList();
        listPertemuan.assignAll(pertemuanList);
        pertemuanTerpakai.assignAll(
          pertemuanList.map((e) => e.pertemuanKe).whereType<int>().toList(),
        );

        if (selectedPertemuan.value.isNotEmpty) {
          final selectedInt = int.tryParse(selectedPertemuan.value);

          final isInPertemuanTerpakai = pertemuanTerpakai.contains(selectedInt);

          if (isInPertemuanTerpakai) {
            selectedPertemuan.value = "";
          }
        }
      } else {
        log.e(result.message);
        listMatkul.clear;
        selectedPertemuan.value = "";
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<String> getPresensiId() async {
    try {
      final result = await addPresenceLecturerService.getPresensiId();

      if (result.status == "success" && result.data != null) {
        final responPresence = result.data!;
        final year = responPresence.tahun;
        final lastInc = responPresence.lastIncrement! + (1);
        final presenceId = "TR$year${lastInc.toString().padLeft(4, '0')}";
        return presenceId;
      } else {
        return '';
      }
    } catch (e) {
      log.f("Error: $e");
      return '';
    }
  }

  Future<bool> checkPresence(
      int prodiId,
      int semester,
      String jamAwal,
      String jamAkhir,
      String tglPresensi,
      int pertemuan,
      String status,
      int matkulId,
      int tahunAjaranId) async {
    try {
      showLoading();
      final result = await addPresenceLecturerService.checkPresence(
          dosenId.value.toString(),
          prodiId,
          semester,
          jamAwal,
          jamAkhir,
          tglPresensi,
          pertemuan,
          status,
          matkulId,
          tahunAjaranId);

      if (result.status == "conflict") {
        Get.back();
        isEnabled.value = false;
        Get.dialog(FailedDialog(
          title: "Presensi gagal diunggah!",
          subtitle:
              "Data presensi bentrok dengan matkul lain di kelas yang sama",
          gifAssetPath: "assets/gif/failed_animation.gif",
          onDetailPressed: () => Get.toNamed("/lecturer/notification-screen"),
        ));
        Future.delayed(
          Duration(seconds: 3),
          () => isEnabled.value = true,
        );

        return false;
      } else if (result.status == "no_conflict") {
        return true;
      } else {
        Get.back();
        isEnabled.value = false;
        Get.dialog(FailedDialog(
            title: "Presensi gagal diunggah",
            subtitle: "Data presensi gagal ditambahkan",
            gifAssetPath: "assets/gif/failed_animation.gif",
            onDetailPressed: () =>
                Get.toNamed("/lecturer/notification-screen")));
        Future.delayed(
          Duration(seconds: 3),
          () => isEnabled.value = true,
        );
        return false;
      }
    } catch (e) {
      log.f("Error: $e");
      Get.back();
      return false;
    }
  }

  Future<void> uploadPresence(String presensiId) async {
    try {
      final result =
          await addPresenceLecturerService.uploadPresensi(PresenceRequest(
        presensiId: presensiId,
        tglPresensi: selectedDate.value!.toString(),
        jamAwal: jamAwalStr.value,
        jamAkhir: jamAkhirStr.value,
        dosenId: dosenId.value,
        prodiId: int.parse(selectedProdiMap['id']!),
        semester: int.parse(selectedSemester.value),
        matkulId: int.parse(selectedMatkulMap['id']!),
        tahunAjaranId: tahunAjaranId.value,
        linkZoom: linkZoomController.text.trim(),
        pertemuanKe: int.parse(selectedPertemuan.value),
        jenisPertemuan: selectedJenis.value,
        status: selectedStatus.value,
      ));

      if (result.status == "success") {
        Get.back();
        Get.offAllNamed("/");
        isEnabled.value = false;
        Get.dialog(
          SuccessDialog(
            title: 'Presensi berhasil diunggah!',
            subtitle: 'Data presensi berhasil ditambahkan',
            gifAssetPath: 'assets/gif/success_animation.gif',
            onDetailPressed: () => Get.toNamed("/lecturer/notification-screen"),
          ),
          barrierDismissible: false,
        );
        Future.delayed(
          Duration(seconds: 3),
          () => isEnabled.value = true,
        );
      } else {
        Get.back();
        isEnabled.value = false;
        Get.dialog(FailedDialog(
            title: "Presensi gagal diunggah",
            subtitle: "Data presensi gagal ditambahkan",
            gifAssetPath: "assets/gif/failed_animation.gif",
            onDetailPressed: () =>
                Get.toNamed("/lecturer/notification-screen")));
        Future.delayed(
          Duration(seconds: 3),
          () => isEnabled.value = true,
        );
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  void submitPresence() async {
    log.d("Pertemuan ke ${selectedPertemuan.value}");
    if (validatePresence() == true) {
      final isConflictFree = await checkPresence(
          int.parse(selectedProdiMap['id']!),
          int.parse(selectedSemester.value),
          jamAwalStr.value,
          jamAkhirStr.value,
          selectedDate.value!.toString(),
          int.parse(selectedPertemuan.value),
          selectedStatus.value,
          int.parse(selectedMatkulMap['id']!),
          tahunAjaranId.value);

      if (isConflictFree) {
        final presensiId = await getPresensiId();
        log.d("Presensi Id : $presensiId");
        await uploadPresence(presensiId);
      }
    }
  }

  // bool validatePresence() {
  //   if (jamAwal.value == null || jamAkhir.value == null) {
  //     Get.dialog(UploadDialog(
  //         title: "Validasi!",
  //         subtitle: "Silahkan isi data terlebih dahulu",
  //         gifAssetPath: "assets/gif/upload_data_animation.gif"));
  //     return false;
  //   }

  //   final now = DateTime.now();
  //   final selected = selectedDate.value;

  //   if (selected != null &&
  //       DateTime(selected.year, selected.month, selected.day)
  //           .isBefore(DateTime(now.year, now.month, now.day))) {
  //     isEnabled.value = false;
  //     Get.dialog(UploadDialog(
  //       title: "Validasi!",
  //       subtitle: "Tanggal tidak boleh kurang dari hari ini.",
  //       gifAssetPath: "assets/gif/upload_data_animation.gif",
  //     ));
  //     Future.delayed(
  //       const Duration(seconds: 3),
  //       () => isEnabled.value = true,
  //     );
  //     return false;
  //   }

  //   jamAwalStr.value = timeOfDayToString(jamAwal.value!);
  //   jamAkhirStr.value = timeOfDayToString(jamAkhir.value!);
  //   final awal = timeOfDayToString(jamAwal.value!);
  //   final akhir = timeOfDayToString(jamAkhir.value!);

  //   log.d("Dosen ID:  ${dosenId.value}");
  //   log.d("SelectedProdi id: ${selectedProdiMap['id']}");
  //   log.d("SelectedMatkul id: ${selectedMatkulMap['id']}");
  //   log.d("SelectedPertemuan ke ${selectedPertemuan.value}");
  //   log.d("SelectedStatus: ${selectedStatus.value}");
  //   log.d("semester: ${selectedSemester.value}");
  //   log.d("TahunAjar Id: ${tahunAjaranId.value}");
  //   log.d("selectedDate : ${selectedDate.value}");
  //   log.d("Jam Awal : ${jamAwal.value}");
  //   log.d("Jam Akhir : ${jamAkhir.value}");
  //   log.d("Jam Awal Str : ${jamAwalStr.value}");
  //   log.d("Jam Akhir Str: ${jamAkhirStr.value}");
  //   log.d("LinkZoom : ${linkZoomController.text}");
  //   if (!selectedProdiMap.containsKey('id') ||
  //       selectedProdiMap['id'] == null ||
  //       selectedProdiMap['id']!.isEmpty ||
  //       selectedSemester.isEmpty ||
  //       selectedPertemuan.isEmpty ||
  //       selectedStatus.isEmpty ||
  //       !selectedMatkulMap.containsKey('id') ||
  //       selectedMatkulMap['id'] == null ||
  //       selectedMatkulMap['id']!.isEmpty ||
  //       tahunAjaranId.value == 0 ||
  //       selectedDate.value == null ||
  //       jamAwal.value == null ||
  //       jamAkhir.value == null ||
  //       jamAwalStr.value.isEmpty ||
  //       jamAkhirStr.value.isEmpty ||
  //       linkZoomController.text.isEmpty && selectedStatus.value == "Aktif") {
  //     isEnabled.value = false;
  //     Get.dialog(UploadDialog(
  //         title: "Validasi!",
  //         subtitle: "Silahkan isi data terlebih dahulu",
  //         gifAssetPath: "assets/gif/upload_data_animation.gif"));
  //     Future.delayed(
  //       Duration(seconds: 3),
  //       () => isEnabled.value = true,
  //     );
  //     return false;
  //   } else if (!selectedProdiMap.containsKey('id') ||
  //       selectedProdiMap['id'] == null ||
  //       selectedProdiMap['id']!.isEmpty ||
  //       selectedSemester.isEmpty ||
  //       selectedPertemuan.isEmpty ||
  //       selectedStatus.isEmpty ||
  //       !selectedMatkulMap.containsKey('id') ||
  //       selectedMatkulMap['id'] == null ||
  //       selectedMatkulMap['id']!.isEmpty ||
  //       tahunAjaranId.value == 0 ||
  //       selectedDate.value == null && selectedStatus.value != "Aktif") {
  //     "";
  //   } else if (!isAfter(jamAkhir.value!, jamAwal.value!) || awal == akhir) {
  //     isEnabled.value = false;
  //     Get.dialog(UploadDialog(
  //         title: "Validasi!",
  //         subtitle: "Jam akhir harus setelah jam awal",
  //         gifAssetPath: "assets/gif/upload_data_animation.gif"));
  //     Future.delayed(
  //       Duration(seconds: 3),
  //       () => isEnabled.value = true,
  //     );
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  bool validatePresence() {
    log.d("Dosen ID:  ${dosenId.value}");
    log.d("SelectedProdi id: ${selectedProdiMap['id']}");
    log.d("SelectedMatkul id: ${selectedMatkulMap['id']}");
    log.d("SelectedPertemuan ke ${selectedPertemuan.value}");
    log.d("SelectedJenisPertemuan: ${selectedJenis.value}");
    log.d("SelectedStatus: ${selectedStatus.value}");
    log.d("semester: ${selectedSemester.value}");
    log.d("TahunAjar Id: ${tahunAjaranId.value}");
    log.d("selectedDate : ${selectedDate.value}");
    log.d("Jam Awal : ${jamAwal.value}");
    log.d("Jam Akhir : ${jamAkhir.value}");
    log.d("Jam Awal Str : ${jamAwalStr.value}");
    log.d("Jam Akhir Str: ${jamAkhirStr.value}");
    log.d("LinkZoom : ${linkZoomController.text}");

    void showValidationDialog(String message) {
      isEnabled.value = false;
      Get.dialog(UploadDialog(
          title: "Validasi!",
          subtitle: message,
          gifAssetPath: "assets/gif/upload_data_animation.gif"));
      Future.delayed(const Duration(seconds: 3), () => isEnabled.value = true);
    }

    final requiredFields = [
      selectedProdiMap['id'],
      selectedSemester.value,
      selectedPertemuan.value,
      selectedStatus.value,
      selectedMatkulMap['id'],
      tahunAjaranId.value.toString(),
      selectedDate.value
    ];

    if (requiredFields.any((e) => e == null || e.toString().isEmpty)) {
      showValidationDialog("Silahkan isi data terlebih dahulu");
      return false;
    }

    if ((selectedStatus.value == "Aktif" || selectedStatus.value.isEmpty) &&
        (jamAwal.value == null || jamAkhir.value == null)) {
      showValidationDialog(
          "Silahkan isi jam awal dan jam akhir terlebih dahulu");
      return false;
    }

    final selected = selectedDate.value;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    if (selected != null &&
        DateTime(selected.year, selected.month, selected.day)
            .isBefore(todayOnly)) {
      showValidationDialog("Tanggal tidak boleh kurang dari hari ini");
      return false;
    }

    if (selectedStatus.value != "Aktif" &&
        jamAwal.value == null &&
        jamAkhir.value == null &&
        linkZoomController.text.isEmpty) {
      return true;
    }

    jamAwalStr.value = timeOfDayToString(jamAwal.value!);
    jamAkhirStr.value = timeOfDayToString(jamAkhir.value!);

    final awal = jamAwalStr.value;
    final akhir = jamAkhirStr.value;

    if (!isAfter(jamAkhir.value!, jamAwal.value!) || awal == akhir) {
      showValidationDialog("Jam akhir harus setelah jam awal");
      return false;
    }

    if (selectedStatus.value == "Aktif" && linkZoomController.text.isEmpty) {
      showValidationDialog("Silahkan isi link zoom terlebih dahulu");
      return false;
    }
    if (selectedStatus.value == "Aktif" && selectedJenis.isEmpty) {
      showValidationDialog("Silahkan isi jenis pertemuan terlebih dahulu");
      return false;
    }

    return true;
  }

  bool isAfter(TimeOfDay a, TimeOfDay b) {
    if (a.hour > b.hour) return true;
    if (a.hour == b.hour && a.minute > b.minute) return true;
    return false;
  }

  String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}
