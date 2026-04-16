import 'package:get/get.dart';
import 'package:stipres/controllers/features_lecturer/home/lectures/lecture_controller.dart';

class LecturerLectureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LectureController());
  }
}
