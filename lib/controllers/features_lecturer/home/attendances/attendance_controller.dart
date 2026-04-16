import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/lecturers/attendance_model.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/services/lecturer/attendance_lecturer_service.dart';

class AttendanceController extends GetxController {
  final Logger log = Logger();
  final AttendanceLecturerService attendanceLecturerService =
      AttendanceLecturerService();

  final isSnackbarOpen = false.obs;
  final selectedSemester = "".obs;
  final selectedProdi = "".obs;
  final tempSelectedSemester = "".obs;
  final tempSelectedProdi = "".obs;
  final prodiMap = <String, String>{}.obs;
  final listProdi = <DataProdi>[].obs;
  var studentList = <DataMahasiswa>[].obs;

  @override
  void onInit() {
    super.onInit();
    showProdis();
  }

  void showProdis() async {
    try {
      final result = await attendanceLecturerService.fetchDataProdi();
      log.d(result.data);

      if (result.status == "success") {
        listProdi.assignAll(result.data!);

        prodiMap.clear();
        for (var prodi in listProdi) {
          prodiMap[prodi.id] = prodi.namaProdi;
        }
      } else {
        // Get.snackbar("Gagal", result.message);
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<void> showStudent() async {
    final semester = selectedSemester.value;
    final prodiId = selectedProdi.value;
    try {
      final result =
          await attendanceLecturerService.fetchMahasiswa(semester, prodiId);
      if (result.status == "success") {
        if (result.data != null) {
          final List<DataMahasiswa> updatedList = result.data!.map((student) {
            return student;
          }).toList();
          studentList.assignAll(updatedList);
        } else {
          studentList.clear();
        }
      } else {
        // Get.snackbar("Gagal", result.message);
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }
}
