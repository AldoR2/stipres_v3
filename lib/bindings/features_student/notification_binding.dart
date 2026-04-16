import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
