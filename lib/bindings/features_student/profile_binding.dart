import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
