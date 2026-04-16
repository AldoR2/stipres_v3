import 'package:get/get.dart';
import 'package:stipres/controllers/auth/activation_step2_controller.dart';

class ActivationStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivationStep2Controller());
  }
}
