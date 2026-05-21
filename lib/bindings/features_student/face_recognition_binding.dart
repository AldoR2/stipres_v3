import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/face_attendance_controller.dart';

class FaceRecognitionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaceAttendanceController());
  }
}
