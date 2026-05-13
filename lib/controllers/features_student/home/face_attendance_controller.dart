import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:stipres/services/face_recognition/camera_service.dart';
import 'package:stipres/services/face_recognition/face_api_service.dart';
import 'package:stipres/services/face_recognition/face_crop_service.dart';
import 'package:stipres/services/face_recognition/face_detector_service.dart';
import 'package:stipres/services/face_recognition/face_recognition_service.dart';

class FaceAttendanceController extends GetxController {
  final CameraService _cameraService = CameraService();
  final FaceDetectorService _faceDetectorService = FaceDetectorService();

  CameraController? get cameraController => _cameraService.controller;
  final FaceCropService _faceCropService = FaceCropService();
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();
  final FaceApiService _faceApiService = FaceApiService();

  final RxBool isCameraInitialize = false.obs;
  final RxBool isDetecting = false.obs;
  final Logger log = Logger();
  final mahasiswaId = 0.obs;

  final RxList<Face> detectedFaces = <Face>[].obs;
  final RxList<Rect> faceRects = <Rect>[].obs;
  final Rx<Size> imageSize = Size.zero.obs;

  final isFaceValid = false.obs;

  final RxBool isSingleFace = false.obs;
  final RxBool isFaceCentered = false.obs;
  final RxBool isFaceTooSmall = false.obs;
  final RxBool isEyesOpen = false.obs;
  final RxBool isHeadStraight = false.obs;

  final Rx<File?> croppedFaceFile = Rx<File?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      mahasiswaId.value = Get.arguments;
    }
    await initializeCamera();
    await _faceRecognitionService.loadModel();
  }

  Future<void> initializeCamera() async {
    await _cameraService.initialize();

    isCameraInitialize.value = true;
    await startFaceDetection();
  }

  Future<void> captureFace() async {
    if (!isFaceValid.value) return;
    log.d("Pressed");
    try {
      final file = await cameraController!.takePicture();

      final faces = await _faceDetectorService.detectFacesFromFile(file.path);

      if (faces.isEmpty) {
        Get.snackbar("Error", "Wajah tidak ditemukan");
        return;
      }

      final face = faces.first;
      final croppedFace =
          await _faceCropService.cropFace(imagePath: file.path, face: face);

      if (croppedFace == null) {
        Get.snackbar("Error", "Crop wajah gagal");
        return;
      }

      log.d("Crop success: ${croppedFace.width} x ${croppedFace.height}");

      final embedding =
          await _faceRecognitionService.generateEmbedding(croppedFace);

      log.d("Embedding length: ${embedding.length}");
      await _faceApiService.saveEmbedding(
          mahasiswaId: mahasiswaId.value, embedding: embedding);
    } catch (e) {
      log.e("Error: $e");
    }
  }

  Future<void> startFaceDetection() async {
    await _cameraService.startImageStream((CameraImage image) async {
      if (isDetecting.value) return;

      isDetecting.value = true;

      try {
        final inputImage = _convertToInputImage(image);

        final faces = await _faceDetectorService.detectFaces(inputImage);
        log.d("Faces detected: ${faces.length}");

        detectedFaces.value = faces;
        faceRects.value = faces.map((face) => face.boundingBox).toList();
        imageSize.value = Size(image.width.toDouble(), image.height.toDouble());
        isSingleFace.value = faces.length == 1;

        if (faces.isNotEmpty) {
          final face = faces.first;
          final faceWidth = face.boundingBox.width;

          isFaceTooSmall.value = faceWidth < 150;

          final leftEye = face.leftEyeOpenProbability ?? 0;
          final rightEye = face.rightEyeOpenProbability ?? 0;
          isEyesOpen.value = leftEye > 0.7 && rightEye > 0.7;

          final yaw = face.headEulerAngleY ?? 0;

          isHeadStraight.value = yaw.abs() < 15;

          final centerX = face.boundingBox.center.dx;
          final imageCenterX = image.width / 2;
          final diff = (centerX - imageCenterX).abs();
          isFaceCentered.value = diff < 80;
        }

        isFaceValid.value = isSingleFace.value &&
            isFaceCentered.value &&
            !isFaceTooSmall.value &&
            isEyesOpen.value &&
            isHeadStraight.value;
      } catch (e) {
        log.e("Error: $e");
      } finally {
        isDetecting.value = false;
      }
    });
  }

  InputImage _convertToInputImage(CameraImage image) {
    final camera = cameraController!;

    final rotation = InputImageRotationValue.fromRawValue(
            camera.description.sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow);

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void onClose() async {
    await _cameraService.dispose();
    await _faceDetectorService.dispose();
    super.onClose();
  }
}
