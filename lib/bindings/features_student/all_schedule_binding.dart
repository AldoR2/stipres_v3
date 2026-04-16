import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/all_schedule_controller.dart';

class StudentAllScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllScheduleController());
  }
}
