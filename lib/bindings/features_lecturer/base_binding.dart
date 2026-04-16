import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/base_screen_controller.dart';

class LecturerBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseScreenController());
  }
}
