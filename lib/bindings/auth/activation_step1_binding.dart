import 'package:get/get.dart';
import 'package:stipres/controllers/auth/activation_step1_controller.dart';

class ActivationStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivationStep1Controller());
  }
}
