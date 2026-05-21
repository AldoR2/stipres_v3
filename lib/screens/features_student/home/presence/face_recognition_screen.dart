import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/home/face_attendance_controller.dart';
import 'package:stipres/screens/features_student/widgets/face_box_painter.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

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
      body: Obx(() {
        if (!controller.isCameraInitialize.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        return Column(
          children: [
            CustomHeader(
              title: "Presensi dengan Deteksi Wajah",
              backgroundColor: styles.getMainColor(context),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FB),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Tinggi kamera adaptif: antara 240px dan 52% tinggi tersedia
                    final cameraHeight =
                        (constraints.maxHeight * 0.52).clamp(240.0, 420.0);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label seksi
                          Text(
                            "Presensi Mata Kuliah",
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Camera Area ──
                          _CameraArea(
                            controller: controller,
                            cameraHeight: cameraHeight,
                          ),
                          const SizedBox(height: 14),

                          // ── Instruksi liveness ──
                          _InstructionCard(controller: controller),
                          const SizedBox(height: 14),

                          // ── Validation Card ──
                          _ValidationCard(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════
// 📷 Camera Area
// ══════════════════════════════════════════════════════

class _CameraArea extends StatelessWidget {
  final FaceAttendanceController controller;
  final double cameraHeight;

  const _CameraArea({required this.controller, required this.cameraHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cameraHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview
            FutureBuilder(
              future: controller.initializeCamera(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller
                          .cameraController!.value.previewSize!.height,
                      height:
                          controller.cameraController!.value.previewSize!.width,
                      child: CameraPreview(controller.cameraController!),
                    ),
                  );
                }
                return Container(
                  color: const Color(0xFF0D1B3E),
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.white54)),
                );
              },
            ),

            // Face box overlay
            Obx(() => CustomPaint(
                  painter: FaceBoxPainter(
                    faces: controller.faceRects.toList(),
                    imageSize: controller.imageSize.value,
                    isFrontCamera: true,
                  ),
                )),

            // Vignette
            _VignetteOverlay(
                frameSize: cameraHeight * 0.72, totalHeight: cameraHeight),

            // Face detection frame
            Center(
              child: _FaceDetectionFrame(frameSize: cameraHeight * 0.72),
            ),

            // Scan line
            Center(
              child: _ScanLineAnimation(frameSize: cameraHeight * 0.72),
            ),

            // Hint chip di bawah
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.15), width: 0.5),
                  ),
                  child: const Text(
                    "Posisikan wajah di dalam frame",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// 💬 Instruction Card
// ══════════════════════════════════════════════════════

class _InstructionCard extends StatelessWidget {
  final FaceAttendanceController controller;

  const _InstructionCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Icon(Icons.remove_red_eye_outlined, color: blueColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              return Text(
                controller.livenessInstruction.value,
                style: TextStyle(
                  color: blueColor,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// ✅ Validation Card
// ══════════════════════════════════════════════════════

class _ValidationCard extends GetView<FaceAttendanceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = [
        _ValItem(label: 'Satu wajah', ok: controller.isSingleFace.value),
        _ValItem(label: 'Wajah di tengah', ok: controller.isFaceCentered.value),
        _ValItem(
            label: 'Wajah cukup dekat', ok: !controller.isFaceTooSmall.value),
        _ValItem(label: 'Mata terbuka', ok: controller.isEyesOpen.value),
        _ValItem(label: 'Kepala lurus', ok: controller.isHeadStraight.value),
      ];

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "STATUS DETEKSI",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grid 2 kolom
            _TwoColumnGrid(items: items),
            const SizedBox(height: 8),

            // Liveness – full width
            _ValidationItem(
              label: controller.livenessMessage.value,
              value: controller.livenessPassed.value,
              isLiveness: true,
            ),
          ],
        ),
      );
    });
  }
}

class _ValItem {
  final String label;
  final bool ok;
  const _ValItem({required this.label, required this.ok});
}

class _TwoColumnGrid extends StatelessWidget {
  final List<_ValItem> items;
  const _TwoColumnGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _ValidationItem(label: left.label, value: left.ok)),
            const SizedBox(width: 8),
            Expanded(
              child: right != null
                  ? _ValidationItem(label: right.label, value: right.ok)
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 2 < items.length) rows.add(const SizedBox(height: 6));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}

class _ValidationItem extends StatelessWidget {
  final String label;
  final bool value;
  final bool isLiveness;

  const _ValidationItem({
    required this.label,
    required this.value,
    this.isLiveness = false,
  });

  @override
  Widget build(BuildContext context) {
    final okColor = const Color(0xFF3B6D11);
    final failColor = const Color(0xFFA32D2D);
    final okBg = const Color(0xFFEAF3DE);
    final failBg = const Color(0xFFFCEBEB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: value ? okBg : failBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: value ? okColor : failColor,
            size: 15,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: value ? okColor : failColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isLiveness) ...[
            const SizedBox(width: 4),
            Icon(Icons.refresh_rounded,
                color: value ? okColor : failColor, size: 13),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// 🌑 VIGNETTE (tidak berubah dari semula)
// ══════════════════════════════════════════════════════

class _VignetteOverlay extends StatelessWidget {
  final double frameSize;
  final double totalHeight;

  const _VignetteOverlay({required this.frameSize, required this.totalHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: CustomPaint(painter: _VignettePainter(frameSize: frameSize)),
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

// ══════════════════════════════════════════════════════
// 🔵 FACE FRAME (tidak berubah dari semula)
// ══════════════════════════════════════════════════════

class _FaceDetectionFrame extends StatelessWidget {
  final double frameSize;
  const _FaceDetectionFrame({required this.frameSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: CustomPaint(painter: _FaceFramePainter()),
    );
  }
}

class _FaceFramePainter extends CustomPainter {
  static const _blue = Color(0xFF1565C0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const arm = 30.0;
    const thick = 4.5;
    const r = 10.0;
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

    final path = Path();
    path.moveTo(0, arm);
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0),
        radius: const Radius.circular(r), clockwise: true);
    path.lineTo(arm, 0);

    path.moveTo(w - arm, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r),
        radius: const Radius.circular(r), clockwise: true);
    path.lineTo(w, arm);

    path.moveTo(0, h - arm);
    path.lineTo(0, h - r);
    path.arcToPoint(Offset(r, h),
        radius: const Radius.circular(r), clockwise: false);
    path.lineTo(arm, h);

    path.moveTo(w - arm, h);
    path.lineTo(w - r, h);
    path.arcToPoint(Offset(w, h - r),
        radius: const Radius.circular(r), clockwise: false);
    path.lineTo(w, h - arm);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, solidPaint);

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
// 🔴 SCAN LINE (tidak berubah dari semula)
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.repeat(reverse: true);
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
