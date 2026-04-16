import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/lecturers/presence_model.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/screens/reusable/success_dialog.dart';
import 'package:stipres/screens/reusable/upload_data_dialog.dart';
import 'package:stipres/services/lecturer/presence_lecturer_service.dart';

class PresenceController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final errorMessage = ''.obs;
  var jamAwal = Rx<TimeOfDay?>(null);
  var jamAkhir = Rx<TimeOfDay?>(null);

  final dosenId = ''.obs;

  var presenceList = <PresensiDosenModel>[].obs;
  final PresenceLecturerService presenceLecturerService =
      PresenceLecturerService();

  @override
  void onReady() {
    super.onReady();
    log.d("PresenceLecturerController ONINIT");
    dosenId.value = _box.read("dosen_id").toString();
    fetchPresencee();
  }

  Future<void> fetchPresencee() async {
    try {
      final result = await presenceLecturerService.fetchPresence(dosenId.value);
      log.d(result.data);

      if (result.status == "success" && result.data != null) {
        final List<PresensiDosenModel> updatedList =
            result.data!.map((presence) {
          presence.durasiPresensi =
              "${presence.jamAwal} - ${presence.jamAkhir} WIB";
          return presence;
        }).toList();
        presenceList.assignAll(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.f("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan $e");
    }
  }

  bool validateUpdate(String awal, String akhir) {
    final newAwal = timeOfDayToString(jamAwal.value!);
    final newAkhir = timeOfDayToString(jamAkhir.value!);

    if (newAwal == awal && newAkhir == akhir) {
      Get.back();
      return false;
    } else if (!isAfter(jamAkhir.value!, jamAwal.value!)) {
      Get.back();
      Get.dialog(
          UploadDialog(
            title: "Validasi!",
            subtitle: "Jam akhir harus setelah jam awal",
            gifAssetPath: "assets/gif/upload_data_animation.gif",
          ),
          barrierDismissible: false);
      return false;
    }
    return true;
  }

  Future<bool> checkPresence(String presensisId) async {
    try {
      log.d("Log Debug dosen id ${dosenId.value}");
      final awal = timeOfDayToString(jamAwal.value!);
      final akhir = timeOfDayToString(jamAkhir.value!);
      final result = await presenceLecturerService.checkPresence(
          dosenId.value, presensisId, awal, akhir);

      log.d("hasil conflict: ${result.status}");
      log.d("Data: $awal");
      log.d("Data: $akhir");
      log.d("Data: $presensisId");

      if (result.status == "conflict") {
        Get.back();

        return false;
      } else if (result.status == "no_conflict") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.f("Error: $e");
      return false;
    }
  }

  Future<void> updatePresence(String presensisId) async {
    try {
      final awal = timeOfDayToString(jamAwal.value!);
      final akhir = timeOfDayToString(jamAkhir.value!);
      log.d(awal);
      log.d(akhir);

      showLoading();
      final result = await presenceLecturerService.updatePresence(
          dosenId.value, presensisId, awal, akhir);
      if (result.status == "success") {
        Get.back();
        Get.back();
        fetchPresencee();
        Get.dialog(
          SuccessDialog(
            title: 'Presensi berhasil diubah!',
            subtitle: 'Data presensi berhasil diubah',
            gifAssetPath: 'assets/gif/success_animation.gif',
            onDetailPressed: () => Get.toNamed("/lecturer/notification-screen"),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.back();
        Get.snackbar("Error", result.message, duration: Duration(seconds: 1));
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan $e",
          duration: Duration(seconds: 1));
    }
  }

  Future<void> deletePresence(String presensisId) async {
    try {
      showLoading();
      final result = await presenceLecturerService.deletePresence(presensisId);
      if (result.status == "success") {
        Get.back();
        fetchPresencee();
        Get.snackbar("Berhasil", "Presensi berhasil dihapus",
            duration: Duration(seconds: 1));
      } else {
        Get.back();
        Get.snackbar("Error", result.message, duration: Duration(seconds: 1));
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan $e",
          duration: Duration(seconds: 1));
    }
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

  void setInitialTime(String awal, String akhir) {
    jamAwal.value = stringToTimeOfDay(awal);
    jamAkhir.value = stringToTimeOfDay(akhir);
  }

  void showLoading() {
    Get.dialog(const LoadingPopup(),
        barrierDismissible: false, barrierColor: Colors.black.withOpacity(0.3));
  }
}
