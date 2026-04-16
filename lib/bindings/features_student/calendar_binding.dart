import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController());
  }
}
