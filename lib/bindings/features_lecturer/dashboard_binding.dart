import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/dashboard_controller.dart';

class LecturerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
