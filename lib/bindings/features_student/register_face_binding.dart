import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/register_face_controller.dart';

class RegisterFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterFaceController());
  }
}
