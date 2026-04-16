import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_controller.dart';

class LecturerPresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PresenceController());
  }
}
