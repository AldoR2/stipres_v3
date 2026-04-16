import 'package:get/get.dart';
import 'package:stipres/controllers/auth/forget_password_step3_controller.dart';

class ForgetPasswordStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgetPasswordStep3Controller());
  }
}
