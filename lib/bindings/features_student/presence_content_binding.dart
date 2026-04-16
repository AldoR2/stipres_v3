import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/presence_content_controller.dart';

class PresenceContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PresenceContentController());
  }
}
