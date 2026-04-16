import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/add_presence_controller.dart';

class AddPresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPresenceController());
  }
}
