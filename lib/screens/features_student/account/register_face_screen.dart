import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/account/register_face_controller.dart';

class RegisterFaceScreen extends StatelessWidget {
  RegisterFaceScreen({super.key});

  final controller = Get.find<RegisterFaceController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!controller.isCameraInitialize.value ||
            controller.cameraController == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Positioned.fill(
                    child: CameraPreview(controller.cameraController!)),
                Center(child: Obx(() {
                  return Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: controller.isFaceValid.value
                              ? Colors.green
                              : Colors.red,
                          width: 3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  );
                })),
                Positioned(
                    left: 16, right: 16, bottom: 16, child: _ValidationCard()),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: controller.isFaceValid.value &&
                              !controller.isRegistering.value
                          ? controller.registerFace
                          : null,
                      child: Text(controller.isRegistering.value
                          ? "Mendaftarkan..."
                          : "Daftarkan Wajah")),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: _ResultCard(),
              ),
            )
          ],
        );
      }),
    );
  }
}

class _ValidationCard extends GetView<RegisterFaceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ValidationItem(
              label: 'Satu wajah',
              value: controller.isSingleFace.value,
            ),
            _ValidationItem(
              label: 'Wajah di tengah',
              value: controller.isFaceCentered.value,
            ),
            _ValidationItem(
              label: 'Wajah cukup dekat',
              value: !controller.isFaceTooSmall.value,
            ),
            _ValidationItem(
              label: 'Mata terbuka',
              value: controller.isEyesOpen.value,
            ),
            _ValidationItem(
              label: 'Kepala lurus',
              value: controller.isHeadStraight.value,
            ),
          ],
        ),
      );
    });
  }
}

class _ValidationItem extends StatelessWidget {
  final String label;
  final bool value;

  const _ValidationItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.greenAccent : Colors.redAccent,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends GetView<RegisterFaceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasResult.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: controller.isSuccess.value
              ? Colors.green.withOpacity(0.12)
              : Colors.red.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.isSuccess.value ? Colors.green : Colors.red,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.resultTitle.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: controller.isSuccess.value ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              controller.resultMessage.value,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    });
  }
}
