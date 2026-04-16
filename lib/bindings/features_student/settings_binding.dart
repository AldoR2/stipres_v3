import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}
