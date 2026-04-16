import 'package:get/get.dart';
import 'package:stipres/controllers/auth/activation_step3_controller.dart';

class ActivationStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivationStep3Controller());
  }
}
