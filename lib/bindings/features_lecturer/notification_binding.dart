import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/notification_controller.dart';

class LecturerNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LecturerNotificationController());
  }
}
