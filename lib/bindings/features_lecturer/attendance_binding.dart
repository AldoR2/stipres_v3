import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/attendances/attendance_controller.dart';

class LecturerAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceController());
  }
}
