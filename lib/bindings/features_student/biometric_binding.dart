import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/biometric_controller.dart';

class BiometricBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BiometricController());
  }
}
