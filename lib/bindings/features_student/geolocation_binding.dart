import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/geolocation_controller.dart';

class GeolocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GeolocationController());
  }
}
