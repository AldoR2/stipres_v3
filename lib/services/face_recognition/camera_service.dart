import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraService extends GetxService {
  CameraController? controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    controller = CameraController(frontCamera, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888);

    await controller!.initialize();
  }

  Future<void> startImageStream(Function(CameraImage image) onImage) async {
    if (controller == null) return;

    await controller!.startImageStream((image) {
      onImage(image);
    });
  }

  Future<void> stopimageStream() async {
    await controller?.stopImageStream();
  }

  Future<void> dispose() async {
    await controller?.dispose();
  }
}
