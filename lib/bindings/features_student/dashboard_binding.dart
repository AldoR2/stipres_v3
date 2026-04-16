import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
