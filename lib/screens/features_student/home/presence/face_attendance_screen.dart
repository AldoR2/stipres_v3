import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/face_attendance_controller.dart';
import 'package:stipres/screens/features_student/widgets/face_box_painter.dart';

class FaceAttendanceScreen extends StatelessWidget {
  FaceAttendanceScreen({super.key});

  final controller = Get.put(FaceAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: controller.captureFace,
      //   child: const Icon(Icons.camera),
      // ),
      body: Obx(() {
        if (!controller.isCameraInitialize.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(controller.cameraController!),
            Obx(() {
              return CustomPaint(
                painter: FaceBoxPainter(
                    faces: controller.faceRects.toList(),
                    imageSize: controller.imageSize.value,
                    isFrontCamera: true),
              );
            }),
            Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Obx(() {
                  return Column(
                    children: [
                      Text(controller.isSingleFace.value
                          ? "1 wajah terdeteksi"
                          : "Pastikan hanya ada 1 wajah"),
                      Text(controller.isFaceCentered.value
                          ? "Wajah di tengah"
                          : "Posisikan wajah di tengah")
                    ],
                  );
                }))
          ],
        );
      }),
    );
  }
}
