import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class FaceCropService extends GetxService {
  Future<img.Image?> cropFace({
    required String imagePath,
    required Face face,
  }) async {
    final bytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;
    final rect = face.boundingBox;

    final cropped = img.copyCrop(image,
        x: rect.left.toInt(),
        y: rect.top.toInt(),
        width: rect.width.toInt(),
        height: rect.height.toInt());

    return img.copyResize(cropped, width: 112, height: 112);
  }

}
