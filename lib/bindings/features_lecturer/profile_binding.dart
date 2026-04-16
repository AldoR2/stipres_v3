import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/account/profile_controller.dart';

class LecturerProfileBinding extends Bindings {
  @override
  void dependencies() {
    print("🔧 LecturerProfileBinding dipanggil");
    Get.put(ProfileController());
  }
}
