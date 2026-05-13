import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorService extends GetxService {
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: false,
          enableClassification: true,
          enableTracking: true,
          performanceMode: FaceDetectorMode.fast));

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    return await _faceDetector.processImage(inputImage);
  }

  Future<List<Face>> detectFacesFromFile(String path) async {
    final inputImage = InputImage.fromFilePath(path);

    return await _faceDetector.processImage(inputImage);
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
