import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/register_setting_face_controller.dart';

class ResiterSettingFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterSettingFaceController());
  }
}
