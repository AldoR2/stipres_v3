import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/base_screen_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseScreenController());
  }
}
