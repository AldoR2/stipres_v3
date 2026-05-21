import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/failed_dialog.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/screens/reusable/success_dialog.dart';
import 'package:stipres/services/face_recognition/camera_service.dart';
import 'package:stipres/services/face_recognition/face_api_service.dart';
import 'package:stipres/services/face_recognition/face_comparater_service.dart';
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
  final FaceComparaterService _faceComparaterService = FaceComparaterService();

  final RxBool isCameraInitialize = false.obs;
  final RxBool isDetecting = false.obs;
  final Logger log = Logger();
  final mahasiswaId = 0.obs;
  final presensisId = 0.obs;
  final lokasiId = 0.obs;
  final namaLokasi = ''.obs;

  final RxList<Face> detectedFaces = <Face>[].obs;
  final RxList<Rect> faceRects = <Rect>[].obs;
  final Rx<Size> imageSize = Size.zero.obs;
  final RxList<double> registeredEmbedding = <double>[].obs;

  final RxBool isLoadingRegisteredEmbedding = false.obs;
  final RxBool hasRegisteredEmbedding = false.obs;
  final RxString embeddingMessage = ''.obs;

  final isFaceValid = false.obs;
  final RxBool isComparingface = false.obs;

  final RxBool isSingleFace = false.obs;
  final RxBool isFaceCentered = false.obs;
  final RxBool isFaceTooSmall = false.obs;
  final RxBool isEyesOpen = false.obs;
  final RxBool isHeadStraight = false.obs;

  final RxBool livenessPassed = false.obs;
  final RxBool hasEyeOpenBeforeBlink = false.obs;
  final RxBool hasBlinked = false.obs;
  final RxString livenessMessage = 'Silakan posisikan wajah'.obs;

  final Rx<LivenessStep> currentLivenessStep = LivenessStep.lookStraight.obs;
  final RxString livenessInstruction = 'Lihat lurus ke kamera'.obs;

  final Rx<File?> croppedFaceFile = Rx<File?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      presensisId.value = Get.arguments[0] as int;
      lokasiId.value = Get.arguments[1] as int;
      namaLokasi.value = Get.arguments[2];
      mahasiswaId.value = Get.arguments[3];
    }
    await initializeCamera();
    await _faceRecognitionService.loadModel();
    loadInitialData();
  }

  Future<void> initializeCamera() async {
    try {
      await _cameraService.initialize();
      isCameraInitialize.value = true;
      await startFaceDetection();
      log.f("Tess");
    } catch (e) {
      log.f("Tess 2");
      Get.back();
      Get.dialog(FailedDialog(
          title: "Gagal membaca kamera",
          subtitle: e.toString(),
          gifAssetPath: 'assets/gif/failed_animation.gif'));
    }
  }

  Future<void> loadInitialData() async {
    await loadRegisteredEmbedding();
  }

  Future<void> loadRegisteredEmbedding() async {
    try {
      isLoadingRegisteredEmbedding.value = true;
      hasRegisteredEmbedding.value = false;
      embeddingMessage.value = '';

      final result =
          await _faceApiService.getEmbedding(mahasiswaId: mahasiswaId.value);

      if (result.status == "success" && result.data != null) {
        final data = result.data;

        final List<double> embedding = List<double>.from(
            data['embedding'].map((e) => (e as num).toDouble()));

        registeredEmbedding.assignAll(embedding);
        hasRegisteredEmbedding.value = true;
        embeddingMessage.value = 'Embedding Wajah ditemukan';
        log.d("Registered embedding length: ${registeredEmbedding.length}");
      } else {
        registeredEmbedding.clear();
        hasRegisteredEmbedding.value = false;
        embeddingMessage.value = result.message;
        Get.dialog(FailedDialog(
          title: "Data wajah belum terdaftar!",
          subtitle: "Daftarkan wajah anda terlebih dahulu melalui menu setting",
          gifAssetPath: "assets/gif/failed_animation.gif",
          onOkPressed: () {
            Get.offAllNamed("/");
          },
          onDetailPressed: () => Get.offAllNamed("/"),
        ));
        // Future.delayed(Duration(seconds: 2), () {
        //   Get.offAllNamed("/");
        // });
        log.w("Embedding belum tersedia: ${result.message}");
      }
    } catch (e) {
      registeredEmbedding.clear();
      hasRegisteredEmbedding.value = false;
      embeddingMessage.value = "Gagal memuat embedding wajah";
      log.e("Error: $e");
    } finally {
      isLoadingRegisteredEmbedding.value = false;
    }
  }

  Future<void> processFaceAttendance() async {
    try {
      if (isLoadingRegisteredEmbedding.value) {
        Get.snackbar("Mohon Tunggu", "Data wajah sedang dimuat");
        return;
      }

      if (!hasRegisteredEmbedding.value || registeredEmbedding.isEmpty) {
        Get.snackbar("Wajah belum terdaftar",
            'Silahkan daftarkan wajah terlebih dahulu melalui menu Setting');
        return;
      }
      if (!isFaceValid.value) {
        Get.snackbar("Wajah tidak Valid",
            "Pastikan wajah berada di tengah, mata terbuka dan menghadap kamera");
        return;
      }
      if (!livenessPassed.value) {
        Get.snackbar(
            "Liveness Belum Valid", "Silahkan kedipkan mata terlebih dahulu");
      }

      isComparingface.value = true;

      final imagePath = await cameraController!.takePicture();

      // if (imagePath == null) {
      //   Get.snackbar("Gagal", "Gagal mengambil gambar wajah");
      //   return;
      // }
      final faces =
          await _faceDetectorService.detectFacesFromFile(imagePath.path);

      if (faces.isEmpty) {
        Get.snackbar("Gagal", "Wajah tidak terdeteksi");
        resetLiveness();
        return;
      }
      if (faces.length > 1) {
        Get.snackbar("Gagal", "Terdeteksi lebih dari satu wajah");
        return;
      }
      final face = faces.first;
      final croppedFace = await _faceCropService.cropFace(
          imagePath: imagePath.path, face: face);

      if (croppedFace == null) {
        Get.snackbar("Gagal", "Gagal memotong wajah");
        return;
      }
      showLoading();
      log.d("Crop success: ${croppedFace.width} x ${croppedFace.height}");

      final currentEmbedding =
          await _faceRecognitionService.generateEmbedding(croppedFace);

      log.d("Current embedding length: ${currentEmbedding.length}");

      final compareResult = _faceComparaterService.compare(
          currentEmbedding: currentEmbedding.toList(),
          registeredEmbedding: registeredEmbedding,
          threshold: 0.75);
      log.d("Similarity: ${compareResult.similarity}");
      log.d("Is match: ${compareResult.isMatch}");

      if (!compareResult.isMatch) {
        hideLoading();
        Get.dialog(FailedDialog(
          title: "Presensi Ditolak!",
          subtitle:
              "Wajah tidak cocok. Similarity: ${compareResult.similarity.toStringAsFixed(3)}",
          gifAssetPath: "assets/gif/failed_animation.gif",
        ));
        return;
      }
      hideLoading();
      Get.dialog(SuccessDialog(
        title: "Wajah Cocok!",
        subtitle: "Similarity: ${compareResult.similarity.toStringAsFixed(3)}",
        gifAssetPath: "assets/gif/success_animation.gif",
      ));
      Future.delayed(Duration(seconds: 1));
      Get.offNamed("/student/geolocation-screen", arguments: [
        presensisId.value,
        lokasiId.value,
        namaLokasi.value,
        mahasiswaId.value
      ]);
      resetLiveness();
    } catch (e) {
      log.e("Error: $e");
    }
  }

  // Future<void> fetchEmbedding({required List<double> currentEmbedding}) async {
  //   final result =
  //       await _faceApiService.getEmbedding(mahasiswaId: mahasiswaId.value);
  //   if (result.status == "success" && result.data != null) {
  //     final data = result.data;
  //     final List<double> registeredEmbedding = List<double>.from(
  //         data['embedding'].map((e) => (e as num).toDouble()));

  //     final response = _faceComparaterService.compare(
  //         currentEmbedding: currentEmbedding,
  //         registeredEmbedding: registeredEmbedding,
  //         threshold: 0.75);

  //     if (response.isMatch) {
  //       Get.back();
  //       Future.delayed(Duration(seconds: 2));
  //       Get.snackbar("Berhasil",
  //           'Wajah cocok. Similarity: ${response.similarity.toStringAsFixed(3)}');
  //       log.d("Berhasil");
  //     } else {
  //       Get.back();
  //       Future.delayed(Duration(seconds: 2));
  //       Get.snackbar("Gagal",
  //           "Wajah tidak cocok. Similarity: ${response.similarity.toStringAsFixed(3)}");
  //       log.d("Gagal");
  //     }
  //   } else {
  //     Get.snackbar("Gagal", result.message);
  //     return;
  //   }
  // }

  // Future<void> captureFace() async {
  //   if (!isFaceValid.value) return;
  //   log.d("Pressed");
  //   try {
  //     final file = await cameraController!.takePicture();

  //     final faces = await _faceDetectorService.detectFacesFromFile(file.path);

  //     if (faces.isEmpty) {
  //       Get.snackbar("Error", "Wajah tidak ditemukan");
  //       return;
  //     }

  //     final face = faces.first;
  //     final croppedFace =
  //         await _faceCropService.cropFace(imagePath: file.path, face: face);

  //     if (croppedFace == null) {
  //       Get.snackbar("Error", "Crop wajah gagal");
  //       return;
  //     }

  //     log.d("Crop success: ${croppedFace.width} x ${croppedFace.height}");
  //     showLoading();
  //     final embedding =
  //         await _faceRecognitionService.generateEmbedding(croppedFace);

  //     // await fetchEmbedding(currentEmbedding: embedding);

  //     log.d("Embedding length: ${embedding.length}");
  //     // await _faceApiService.saveEmbedding(
  //     //     mahasiswaId: mahasiswaId.value, embedding: embedding);
  //   } catch (e) {
  //     log.e("Error: $e");
  //   }
  // }

  void resetLiveness() {
    livenessPassed.value = false;
    hasEyeOpenBeforeBlink.value = false;
    hasBlinked.value = false;
    livenessMessage.value = 'Silahkan posisikan wajah';
    livenessInstruction.value = "Lihat lurus ke kamera";
    currentLivenessStep.value = LivenessStep.lookStraight;
  }

  void updateBlinkLiveness({
    required double leftEye,
    required double rightEye,
  }) {
    final bool eyesOpen = leftEye > 0.7 && rightEye > 0.7;
    final bool eyesClosed = leftEye < 0.3 && rightEye < 0.3;

    if (livenessPassed.value) return;

    if (eyesOpen && !hasEyeOpenBeforeBlink.value) {
      hasEyeOpenBeforeBlink.value = true;
      livenessMessage.value = 'Silahkan kedipkan mata';
      return;
    }

    if (hasEyeOpenBeforeBlink.value && eyesClosed && !hasBlinked.value) {
      hasBlinked.value = true;
      livenessMessage.value = 'Bagus, buka mata kembali';
      return;
    }

    if (hasEyeOpenBeforeBlink.value && hasBlinked.value && eyesOpen) {
      livenessPassed.value = true;
      livenessMessage.value = 'Liveness berhasil';
      currentLivenessStep.value = LivenessStep.completed;
      livenessInstruction.value = 'Liveness Berhasil';
    }
  }

  Future<void> startFaceDetection() async {
    await _cameraService.startImageStream((CameraImage image) async {
      if (isDetecting.value) return;

      isDetecting.value = true;

      try {
        final inputImage = _convertToInputImage(image);

        final faces = await _faceDetectorService.detectFaces(inputImage);

        if (faces.length != 1) {
          resetLiveness();
        }

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

          if (currentLivenessStep.value == LivenessStep.lookStraight) {
            if (yaw.abs() < 10) {
              currentLivenessStep.value = LivenessStep.lookRight;
              livenessInstruction.value = 'Tengok ke kanan';
            }
          }

          if (currentLivenessStep.value == LivenessStep.lookRight) {
            if (yaw < -20) {
              currentLivenessStep.value = LivenessStep.lookLeft;
              livenessInstruction.value = 'Tengok ke kiri';
            }
          }

          if (currentLivenessStep.value == LivenessStep.lookLeft) {
            if (yaw > 20) {
              currentLivenessStep.value = LivenessStep.blink;
              livenessInstruction.value = 'Kedipkan mata';
            }
          }

          if (currentLivenessStep.value == LivenessStep.blink) {
            updateBlinkLiveness(leftEye: leftEye, rightEye: rightEye);
          }

          //   isFaceCentered.value = checkFaceCentered(
          //       face: face,
          //       imageSize: imageSize.value,
          //       lensDirection: CameraLensDirection.front);
          // }
          final centerX = face.boundingBox.center.dx;
          final imageCenterX = image.width / 2;
          final diff = (centerX - imageCenterX).abs();
          isFaceCentered.value = diff < 80;
        }

        isFaceValid.value = isSingleFace.value &&
            isFaceCentered.value &&
            !isFaceTooSmall.value &&
            isEyesOpen.value &&
            isHeadStraight.value &&
            currentLivenessStep.value == LivenessStep.completed &&
            livenessPassed.value;

        if (isFaceValid.value) {
          processFaceAttendance();
          return;
        }
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

  // bool checkFaceCentered({
  //   required Face face,
  //   required Size imageSize,
  //   required CameraLensDirection lensDirection,
  // }) {
  //   double faceCenterX = face.boundingBox.center.dx;
  //   final double faceCenterY = face.boundingBox.center.dy;

  //   if (lensDirection == CameraLensDirection.front) {
  //     faceCenterX = imageSize.width - faceCenterX;
  //   }

  //   final imageCenterX = imageSize.width / 2;
  //   final imageCenterY = imageSize.height / 2;

  //   final dx = (faceCenterX - imageCenterX).abs();
  //   final dy = (faceCenterY - imageCenterY).abs();

  //   final toleranceX = imageSize.width * 0.18;
  //   final toleranceY = imageSize.height * 0.18;

  //   return dx <= toleranceX && dy <= toleranceY;
  // }

  @override
  void onClose() async {
    await _cameraService.dispose();
    await _faceDetectorService.dispose();
    super.onClose();
  }

  void hideLoading() {
    if (Get.isDialogOpen == true) {
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
    }
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}

enum LivenessStep {
  lookStraight,
  lookRight,
  lookLeft,
  blink,
  completed,
}
