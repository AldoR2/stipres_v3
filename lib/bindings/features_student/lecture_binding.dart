import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/lecture_controller.dart';

class LectureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LectureController());
  }
}
