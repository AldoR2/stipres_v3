import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/lecture_model.dart';
import 'package:stipres/services/student/lecture_student_service.dart';

class LectureController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final errorMessage = ''.obs;

  var lectureList = <LectureModelApi>[].obs;
  final LectureStudentService lectureStudentService = LectureStudentService();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null) {
      fetchLecture();
    } else {
      final presensisId = Get.arguments;
      fetchContentLecture(presensisId);
    }
  }

  String formatTanggal(String tanggal) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(tanggal);

      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      log.d("Error: $e");
      Get.snackbar("Error", "Terjadi error: $e");
      return tanggal;
    }
  }

  void fetchLecture() async {
    try {
      String nim = _box.read("user_nim");
      log.d("Check nim: $nim");
      final result = await lectureStudentService.tampilZoom(nim);

      if (result.status == "success" && result.data != null) {
        final List<LectureModelApi> updatedList = result.data!.map((lecture) {
          log.d("tgl: ${lecture.tglPresensi}");
          lecture.tglPresensi = formatTanggal(lecture.tglPresensi);

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

  void fetchContentLecture(int presensisId) async {
    try {
      log.d("Check presensisId: $presensisId");
      final result = await lectureStudentService.tampilZoomContent(presensisId);

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
}
