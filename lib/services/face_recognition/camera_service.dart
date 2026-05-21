import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService extends GetxService {
  CameraController? controller;

  Future<void> initialize() async {
    final status = await Permission.camera.request();

    if (status.isDenied) {
      throw Exception("Izin kamera ditolak");
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      throw Exception("Izin kamera diblokir permanen. Aktifkan di pengaturan.");
    }

    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception("Tidak ada kamera yang tersedia.");
    }

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
