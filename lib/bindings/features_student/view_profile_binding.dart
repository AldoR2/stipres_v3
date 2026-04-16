import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/view_profile_controller.dart';

class ViewProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StudentViewProfileController());
  }
}
