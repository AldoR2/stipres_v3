import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/face_recognition_controller.dart';

class FacerecognitionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaceRecognitionController());
  }
}
