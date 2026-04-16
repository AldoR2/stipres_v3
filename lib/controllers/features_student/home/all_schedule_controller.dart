import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/all_schedule_model.dart';
import 'package:stipres/services/student/all_schedules_service.dart';

class AllScheduleController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final errorMessage = ''.obs;

  var scheduleList = <AllScheduleModelApi>[].obs;
  final AllSchedulesService allSchedulesService = AllSchedulesService();

  @override
  void onInit() {
    super.onInit();
    final mahasiswaId = _box.read("mahasiswa_id");
    fetchAllSchedule(mahasiswaId.toString());
  }

  void fetchAllSchedule(String mahasiswaId) async {
    try {
      log.d("Check mahasiswa Id: $mahasiswaId");
      final result = await allSchedulesService.fetchSchedule(mahasiswaId);

      if (result.status == "success" && result.data != null) {
        final List<AllScheduleModelApi> updatedList =
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
