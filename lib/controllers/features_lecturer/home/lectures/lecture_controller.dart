import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/lecture_model.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/lecturer/lecture_lecturer_service.dart';

class LectureController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();
  final errorMessage = ''.obs;

  var lectureList = <LectureModelApi>[].obs;
  final LectureLecturerService lectureLecturerService =
      LectureLecturerService();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null) {
      fetchLecture();
    } else {
      final presensisId = Get.arguments.toString();
      fetchContentLecture(presensisId);
    }
  }

  String formatTanggal(String tanggal) {
    try {
      DateTime date = DateFormat('dd-MM-yyyy').parse(tanggal);

      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      log.d("Error: $e");
      Get.snackbar("Error", "Terjadi error: $e");
      return tanggal;
    }
  }

  void fetchLecture() async {
    try {
      String dosenId = _box.read("dosen_id").toString();
      String namaDosen = _box.read("user_nama");
      log.d(namaDosen);
      log.d("Check Dosen Id: $dosenId");
      final result = await lectureLecturerService.tampilZoom(dosenId);
      log.f("fmalmfa;lmf");

      if (result.status == "success") {
        final List<LectureModelApi> updatedList = result.data!.map((lecture) {
          lecture.tglPresensi = formatTanggal(lecture.tglPresensi);
          lecture.namaDosen ??= namaDosen;
          log.f(lecture.namaDosen);
          log.d(lectureList);

          return lecture;
        }).toList();
        lectureList.assignAll(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Error : $e");
    }
  }

  void fetchContentLecture(String presensisId) async {
    try {
      final result =
          await lectureLecturerService.tampilZoomContent(presensisId);

      if (result.status == "success" && result.data != null) {
        final lecture = result.data!;
        lecture.tglPresensi = formatTanggal(lecture.tglPresensi);

        lectureList.assignAll([lecture]);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Error : $e");
    }
  }

  void submitUpdateLecture(int presensisId, String newLink, String currentLink,
      LectureModelApi? currentData) {
    if (newLink == currentLink) {
      null;
    } else if (newLink.isEmpty) {
      Get.snackbar("Gagal", "Link perkuliahan tidak boleh kosong");
    } else {
      updateLecture(presensisId, newLink);
      onInit();
    }
  }

  void updateLecture(int presensisId, String linkZoom) async {
    try {
      showLoading();
      final result = await lectureLecturerService.updateLecture(
          presensisId.toString(), linkZoom);

      if (result.status == "success") {
        Get.back();
        Get.snackbar("Berhasil", "Link zoom berhasil diperbarui",
            duration: Duration(seconds: 1));
      } else {
        Get.back();
        Get.snackbar("Gagal", result.message, duration: Duration(seconds: 1));
        return;
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Gagal", "Terjadi kesalahan $e",
          duration: Duration(seconds: 1));
      log.f("Error: $e");
      return;
    }
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}
