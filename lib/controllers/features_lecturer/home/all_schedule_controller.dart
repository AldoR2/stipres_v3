import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/lecturers/all_schedule_model.dart';
import 'package:stipres/services/lecturer/all_schedules_service.dart';

class LecturerAllScheduleController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final errorMessage = ''.obs;

  var scheduleList = <LecturerAllScheduleModel>[].obs;
  final LecturerAllSchedulesService lecturerAllSchedulesService =
      LecturerAllSchedulesService();

  @override
  void onInit() {
    super.onInit();
    final dosenId = _box.read("dosen_id");
    fetchAllSchedule(dosenId.toString());
  }

  void fetchAllSchedule(String dosenId) async {
    try {
      log.d("Check dosen Id: $dosenId");
      final result = await lecturerAllSchedulesService.fetchSchedule(dosenId);

      if (result.status == "success" && result.data != null) {
        final List<LecturerAllScheduleModel> updatedList =
            result.data!.map((schedule) {
          final jamMenit = DateFormat('HH:mm')
              .format(DateTime.parse("2023-01-01 ${schedule.jam}"));
          schedule.durasiPerkuliahan = jamMenit;
          return schedule;
        }).toList();
        scheduleList.assignAll(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Error : $e");
    }
  }
}
