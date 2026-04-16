import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/rekap_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RekapController());
  }
}
