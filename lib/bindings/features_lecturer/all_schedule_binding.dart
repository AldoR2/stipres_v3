import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/all_schedule_controller.dart';

class LecturerAllScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LecturerAllScheduleController());
  }
}
