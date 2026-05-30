import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/face_recognition/camera_service.dart';
import 'package:stipres/services/face_recognition/face_api_service.dart';
import 'package:stipres/services/face_recognition/face_crop_service.dart';
import 'package:stipres/services/face_recognition/face_detector_service.dart';
import 'package:stipres/services/face_recognition/face_recognition_service.dart';

class RegisterFaceController extends GetxController {
  final CameraService _cameraService = CameraService();
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  final FaceCropService _faceCropService = FaceCropService();
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();
  final FaceApiService _faceApiService = FaceApiService();

  CameraController? get cameraController => _cameraService.controller;

  final RxBool isCameraInitialize = false.obs;
  final RxBool isDetecting = false.obs;
  final RxBool isRegistering = false.obs;

  final RxBool isAvailable = false.obs;

  final RxInt mahasiswaId = 0.obs;
  final GetStorage _box = GetStorage();
  final Logger log = Logger();

  final RxList<Face> detectedFaces = <Face>[].obs;
  final RxList<Rect> faceRects = <Rect>[].obs;
  final Rx<Size> imageSize = Size.zero.obs;

  final RxBool isSingleFace = false.obs;
  final RxBool isFaceCentered = false.obs;
  final RxBool isFaceTooSmall = false.obs;
  final RxBool isEyesOpen = false.obs;
  final RxBool isHeadStraight = false.obs;
  final RxBool isFaceValid = false.obs;

  final RxString resultTitle = ''.obs;
  final RxString resultMessage = ''.obs;
  final RxBool hasResult = false.obs;
  final RxBool isSuccess = false.obs;

  final Rx<RegisterFaceStep> currentStep = RegisterFaceStep.front.obs;
  final Rx<RegisterCaptureState> captureState = RegisterCaptureState.idle.obs;

  final RxString instructionTitle = 'Lihat lurus ke depan'.obs;
  final RxString instructionMessage = 'Posisikan wajah di tengah frame'.obs;

  final RxBool blinkStarted = false.obs;
  final RxBool livenessCompleted = false.obs;

  bool _isClose = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    mahasiswaId.value = _box.read("mahasiswa_id") ?? 0;

    await fetchEmbedding();
    await initializeCamera();
    await _faceRecognitionService.loadModel();
  }

  Future<void> initializeCamera() async {
    await _cameraService.initialize();
    isCameraInitialize.value = true;
    await startFaceDetection();
  }

  Future<void> fetchEmbedding() async {
    try {
      final result =
          await _faceApiService.getEmbedding(mahasiswaId: mahasiswaId.value);

      if (result.status == "success") {
        isAvailable.value = true;
      } else {
        isAvailable.value = false;
      }
    } catch (e) {
      log.e("Error: $e");
    }
  }

  Future<void> registerFace() async {
    if (isRegistering.value) return;
    try {
      clearResult();

      if (!isFaceValid.value) {
        setResult(
            title: "Wajah Belum Valid",
            message:
                "Pastikan hanya ada satu wajah, mata terbuka, wajah tidak miring, dan wajah terlihat jelas.",
            success: false);
        return;
      }

      isRegistering.value = true;
      showLoading();

      final file = await cameraController!.takePicture();

      if (_isClose) return;
      final faces = await _faceDetectorService.detectFacesFromFile(file.path);

      if (faces.isEmpty) {
        hideLoading();
        setResult(
            title: "Gagal", message: "Wajah tidak terdeteksi", success: false);
        return;
      }

      if (faces.length > 1) {
        hideLoading();
        setResult(
            title: "Gagal",
            message: "Terdeteksi lebih dari satu wajah.",
            success: false);
        return;
      }

      final face = faces.first;

      final croppedFace =
          await _faceCropService.cropFace(imagePath: file.path, face: face);

      if (croppedFace == null) {
        hideLoading();
        setResult(
            title: "Gagal", message: "Gagal memotong wajah.", success: false);
        return;
      }

      log.d("Crop successs: ${croppedFace.width} x ${croppedFace.height}");

      final embedding =
          await _faceRecognitionService.generateEmbedding(croppedFace);
      log.d("Embedding Length: ${embedding.length}");

      final result = await _faceApiService.saveEmbedding(
          mahasiswaId: mahasiswaId.value, embedding: embedding);
      hideLoading();

      if (result.status == 'success') {
        isAvailable.value = true;
        setResult(
            title: "Berhasil",
            message: result.message.isNotEmpty
                ? result.message
                : "Wajah berhasil didaftarkan",
            success: true);
      } else {
        setResult(
            title: "Gagal",
            message: result.message.isNotEmpty
                ? result.message
                : "Gagal mendaftarkan wajah",
            success: false);
        return;
      }
    } catch (e) {
      hideLoading();
      log.e("Error: $e");

      setResult(
          title: "Gagal",
          message: "Terjadi kesalahan saat mendaftarkan wajah",
          success: false);
    } finally {
      isRegistering.value = false;
    }
  }

  Future<void> startFaceDetection() async {
    await _cameraService.startImageStream((CameraImage image) async {
      if (isDetecting.value) return;

      isDetecting.value = true;

      try {
        final inputImage = _convertToInputImage(image);

        final faces = await _faceDetectorService.detectFaces(inputImage);

        detectedFaces.value = faces;
        faceRects.value = faces.map((face) => face.boundingBox).toList();
        imageSize.value = Size(image.width.toDouble(), image.height.toDouble());
        isSingleFace.value = faces.length == 1;

        if (faces.length != 1) {
          resetRegisterStep();
        }

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
          final imageCenterX = (image.width / 2) - 120;
          final diff = (centerX - imageCenterX).abs();
          isFaceCentered.value = diff < 80;

          updateRegisterLiveness(
              face: face, leftEye: leftEye, rightEye: rightEye);
        } else {
          isFaceTooSmall.value = false;
          isEyesOpen.value = false;
          isHeadStraight.value = false;
          isFaceCentered.value = false;
          resetRegisterStep();
        }

        isFaceValid.value = isSingleFace.value &&
            isFaceCentered.value &&
            !isFaceTooSmall.value &&
            livenessCompleted.value;
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

  void updateRegisterLiveness({
    required Face face,
    required double leftEye,
    required double rightEye,
  }) {
    final yaw = face.headEulerAngleY ?? 0;
    log.d("Current step: ${currentStep.value}");
    log.d("Yaw: $yaw");

    final eyesOpen = leftEye > 0.7 && rightEye > 0.7;
    final eyesClosed = leftEye < 0.3 && rightEye < 0.3;

    if (!isSingleFace.value || isFaceTooSmall.value) {
      resetRegisterStep();
      return;
    }

    if (currentStep.value == RegisterFaceStep.front && !isFaceCentered.value) {
      resetRegisterStep();
      return;
    }

    switch (currentStep.value) {
      case RegisterFaceStep.front:
        instructionTitle.value = 'Lihat lurus ke depan';
        instructionMessage.value = 'Hadapkan wajah lurus ke kamera';

        if (yaw.abs() < 12 && eyesOpen) {
          currentStep.value = RegisterFaceStep.right;
          instructionTitle.value = 'Putar kepala ke kanan';
          instructionMessage.value = 'Perlahan putar kepala ke kanan';
        }
        break;

      case RegisterFaceStep.right:
        instructionTitle.value = 'Putar kepala ke kanan';
        instructionMessage.value = 'Perlahan putar kepala ke kanan';

        if (yaw < -18) {
          currentStep.value = RegisterFaceStep.left;
          instructionTitle.value = 'Putar kepala ke kiri';
          instructionMessage.value = 'Perlahan putar kepala ke kiri';
        }
        break;

      case RegisterFaceStep.left:
        instructionTitle.value = 'Putar kepala ke kiri';
        instructionMessage.value = 'Perlahan putar kepala ke kiri';

        if (yaw > 18) {
          currentStep.value = RegisterFaceStep.blink;
          instructionTitle.value = 'Kedipkan mata';
          instructionMessage.value = 'Kedipkan mata satu kali';
        }
        break;

      case RegisterFaceStep.blink:
        instructionTitle.value = 'Kedipkan mata';
        instructionMessage.value = 'Kedipkan mata satu kali';

        if (eyesClosed) {
          blinkStarted.value = true;
        }

        if (blinkStarted.value && eyesOpen) {
          currentStep.value = RegisterFaceStep.completed;
          livenessCompleted.value = true;
          captureState.value = RegisterCaptureState.done;

          instructionTitle.value = 'Verifikasi selesai';
          instructionMessage.value = 'Wajah siap didaftarkan';
        }
        break;

      case RegisterFaceStep.completed:
        break;
    }
  }

  void setResult({
    required String title,
    required String message,
    required bool success,
  }) {
    resultTitle.value = title;
    resultMessage.value = message;
    isSuccess.value = success;
    hasResult.value = true;
  }

  void resetRegisterStep() {
    currentStep.value = RegisterFaceStep.front;
    captureState.value = RegisterCaptureState.idle;

    blinkStarted.value = false;
    livenessCompleted.value = false;

    instructionTitle.value = 'Lihat lurus ke depan';
    instructionMessage.value = 'Posisikan wajah di tengah frame';

    isFaceValid.value = false;
  }

  void clearResult() {
    resultTitle.value = '';
    resultMessage.value = '';
    isSuccess.value = false;
    hasResult.value = false;
  }

  void hideLoading() {
    if (Get.isDialogOpen == true && Get.context != null) {
      Navigator.of(Get.context!, rootNavigator: true).pop();
    }
  }

  void showLoading() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(const LoadingPopup(),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.3));
  }

  @override
  void onClose() async {
    _isClose = true;
    await _cameraService.dispose();
    await _faceDetectorService.dispose();
    super.onClose();
  }
}

enum RegisterFaceStep { front, right, left, blink, completed }

enum RegisterCaptureState { idle, valid, invalid, registering, done }
