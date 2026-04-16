import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/account/view_profile_controller.dart';

class LecturerViewProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ViewProfileController());
  }
}
