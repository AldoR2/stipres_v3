import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/home/face_recognition_controller.dart';
import 'package:stipres/main.dart';
import 'package:stipres/screens/reusable/custom_header.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() {
    if (cameras.isEmpty) return;

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    Get.find<FaceRecognitionController>();

    _controller = CameraController(frontCamera, ResolutionPreset.medium,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.nv21);

    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
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

                      // ═══════════════════════════════════════
                      // 📷 CAMERA AREA
                      // ═══════════════════════════════════════
                      SizedBox(
                        height: cameraHeight,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera preview
                            FutureBuilder(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return ClipRRect(
                                    child: SizedBox.expand(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _controller!
                                              .value.previewSize!.height,
                                          height: _controller!
                                              .value.previewSize!.width,
                                          child: CameraPreview(_controller!),
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

                      Center(
                        child: Text(
                          "Posisikan wajah Anda berada di dalam frame",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),

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
                        child: Center(
                          child: Text(
                            "Mendeteksi Wajah....",
                            style: TextStyle(
                              color: blueColor,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// 🌑 VIGNETTE OVERLAY
// ══════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════
// 🎯 FACE DETECTION FRAME — FIXED CORNER BRACKETS
// ══════════════════════════════════════════════════════

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
    )..repeat(reverse: true);
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
