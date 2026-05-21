import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/home/face_attendance_controller.dart';
import 'package:stipres/screens/features_student/widgets/face_box_painter.dart';
import 'package:stipres/screens/reusable/custom_header.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  final controller = Get.find<FaceAttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
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
          return Column(
            children: [
              CustomHeader(title: "Presensi dengan Deteksi Wajah"),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cameraHeight = constraints.maxHeight * 0.52;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Presensi Mata Kuliah",
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: cameraHeight,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Camera preview
                                FutureBuilder(
                                  future: controller.initializeCamera(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return ClipRRect(
                                        child: SizedBox.expand(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: SizedBox(
                                              width: controller
                                                  .cameraController!
                                                  .value
                                                  .previewSize!
                                                  .height,
                                              height: controller
                                                  .cameraController!
                                                  .value
                                                  .previewSize!
                                                  .width,
                                              child: CameraPreview(
                                                  controller.cameraController!),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                Obx(() {
                                  return CustomPaint(
                                    painter: FaceBoxPainter(
                                        faces: controller.faceRects.toList(),
                                        imageSize: controller.imageSize.value,
                                        isFrontCamera: true),
                                  );
                                }),

                                // Vignette (area luar frame digelapkan)
                                _VignetteOverlay(
                                  frameSize: cameraHeight * 0.74,
                                  totalHeight: cameraHeight,
                                ),

                                // Face frame
                                _FaceDetectionFrame(
                                  frameSize: cameraHeight * 0.74,
                                ),

                                // Scan line
                                _ScanLineAnimation(
                                  frameSize: cameraHeight * 0.74,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Center(child: Obx(() {
                          //   return Column(
                          //     children: [
                          //       Text(
                          //         (controller.isSingleFace.value)
                          //             ? "1 Wajah telah terdeteksi"
                          //             : "Pastikan hanya ada 1 wajah yang terdeteksi",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           color: Colors.grey[600],
                          //           fontSize: 13,
                          //         ),
                          //       ),
                          //       Text(
                          //         (controller.isFaceCentered.value)
                          //             ? "Posisi wajah sudah di tengah"
                          //             : "Posisikan wajah Anda berada di tengah frame",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           color: Colors.grey[600],
                          //           fontSize: 13,
                          //         ),
                          //       ),
                          //     ],
                          //   );
                          // })),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(child: Obx(() {
                              final message =
                                  controller.livenessInstruction.value;

                              return Text(
                                (message),
                                style: TextStyle(
                                  color: blueColor,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            })),
                          ),
                          const Spacer(),
                          // Obx(() {
                          //   if (controller.isLoadingRegisteredEmbedding.value) {
                          //     return const ElevatedButton(
                          //         onPressed: null,
                          //         child: Text("Memuat data wajah..."));
                          //   }

                          //   if (!controller.hasRegisteredEmbedding.value) {
                          //     return ElevatedButton(
                          //         onPressed: () {
                          //           Get.snackbar("Wajah Belum Terdaftar",
                          //               "Silahkan daftarkan wajah terlebih dahulu melalui menu Setting");
                          //         },
                          //         child: const Text("Wajah Belum Terdaftar"));
                          //   }

                          //   if (controller.isComparingface.value) {
                          //     return const ElevatedButton(
                          //         onPressed: null,
                          //         child: Text("Memproses Presensi..."));
                          //   }

                          //   return ElevatedButton(
                          //       onPressed: controller.isFaceValid.value
                          //           ? () => controller.processFaceAttendance()
                          //           : null,
                          //       child: const Text("Presensi Sekarang"));
                          // }),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     onPressed: () => Navigator.pop(context),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: blueColor,
                          //       padding:
                          //           const EdgeInsets.symmetric(vertical: 16),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       elevation: 0,
                          //     ),
                          //     child: const Text(
                          //       "Batal",
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 24),
                          Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: _ValidationCard()),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }));
  }
}

class _ValidationCard extends GetView<FaceAttendanceController> {
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
            _ValidationItem(
              label: controller.livenessMessage.value,
              value: controller.livenessPassed.value,
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

class _VignetteOverlay extends StatelessWidget {
  final double frameSize;
  final double totalHeight;

  const _VignetteOverlay({
    required this.frameSize,
    required this.totalHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: CustomPaint(
        painter: _VignettePainter(frameSize: frameSize),
      ),
    );
  }
}

class _VignettePainter extends CustomPainter {
  final double frameSize;

  _VignettePainter({required this.frameSize});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final frameRect =
        Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    final frameRRect =
        RRect.fromRectAndRadius(frameRect, const Radius.circular(16));

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final framePath = Path()..addRRect(frameRRect);
    final vignettePath =
        Path.combine(PathOperation.difference, fullPath, framePath);

    canvas.drawPath(
        vignettePath, Paint()..color = Colors.black.withOpacity(0.38));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FaceDetectionFrame extends StatelessWidget {
  final double frameSize;

  const _FaceDetectionFrame({required this.frameSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: CustomPaint(
        painter: _FaceFramePainter(),
      ),
    );
  }
}

class _FaceFramePainter extends CustomPainter {
  // ⚠️ Ganti dengan blueColor dari constant.dart kamu
  static const _blue = Color(0xFF1565C0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const arm = 30.0; // panjang lengan bracket
    const thick = 4.5; // ketebalan garis
    const r = 10.0; // radius sudut — SEMUA sudut pakai nilai ini

    const tickLen = 14.0;
    const tickThick = 2.0;

    final glowPaint = Paint()
      ..color = _blue.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thick + 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    final solidPaint = Paint()
      ..color = _blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = tickThick
      ..strokeCap = StrokeCap.round;

    // ─────────────────────────────────────────────
    // Semua 4 corner menggunakan pola yang SAMA:
    // vertikal arm → arc → horizontal arm
    // Kuncinya: titik awal & arah arc konsisten
    // ─────────────────────────────────────────────
    final path = Path();

    // ┌ TOP-LEFT
    //   mulai dari bawah sisi kiri, naik ke atas, arc ke kanan
    path.moveTo(0, arm);
    path.lineTo(0, r);
    path.arcToPoint(
      Offset(r, 0),
      radius: const Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(arm, 0);

    // ┐ TOP-RIGHT
    //   mulai dari kiri sisi atas, gerak ke kanan, arc ke bawah
    path.moveTo(w - arm, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(
      Offset(w, r),
      radius: const Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(w, arm);

    // └ BOTTOM-LEFT
    //   mulai dari atas sisi kiri, turun ke bawah, arc ke kanan
    path.moveTo(0, h - arm);
    path.lineTo(0, h - r);
    path.arcToPoint(
      Offset(r, h),
      radius: const Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(arm, h);

    // ┘ BOTTOM-RIGHT
    //   mulai dari kiri sisi bawah, gerak ke kanan, arc ke atas
    path.moveTo(w - arm, h);
    path.lineTo(w - r, h);
    path.arcToPoint(
      Offset(w, h - r),
      radius: const Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(w, h - arm);

    // Glow dulu, lalu solid
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, solidPaint);

    // Mid-side tick marks (putih, subtle)
    canvas.drawLine(Offset(0, h / 2 - tickLen / 2),
        Offset(0, h / 2 + tickLen / 2), tickPaint);
    canvas.drawLine(Offset(w, h / 2 - tickLen / 2),
        Offset(w, h / 2 + tickLen / 2), tickPaint);
    canvas.drawLine(Offset(w / 2 - tickLen / 2, 0),
        Offset(w / 2 + tickLen / 2, 0), tickPaint);
    canvas.drawLine(Offset(w / 2 - tickLen / 2, h),
        Offset(w / 2 + tickLen / 2, h), tickPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════
// 🔴 SCAN LINE
// ══════════════════════════════════════════════════════

class _ScanLineAnimation extends StatefulWidget {
  final double frameSize;

  const _ScanLineAnimation({required this.frameSize});

  @override
  State<_ScanLineAnimation> createState() => _ScanLineAnimationState();
}

class _ScanLineAnimationState extends State<_ScanLineAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final frameSize = widget.frameSize;

    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final top = _controller.value * (frameSize - 4);
            return Stack(
              children: [
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.redAccent.withOpacity(0.5),
                          Colors.redAccent,
                          Colors.redAccent.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
