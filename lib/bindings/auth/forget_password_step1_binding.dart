import 'package:get/get.dart';
import 'package:stipres/controllers/auth/forget_password_step1_controller.dart';

class ForgetPasswordStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgetPasswordStep1Controller());
  }
}
