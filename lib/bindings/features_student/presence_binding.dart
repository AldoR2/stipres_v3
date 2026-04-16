import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/presence_controller.dart';

class PresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PresenceController());
  }
}
