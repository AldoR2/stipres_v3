import 'package:get/get.dart';
import 'package:stipres/controllers/auth/forget_password_step2_controller.dart';

class ForgetPasswordStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgetPasswordStep2Controller());
  }
}
