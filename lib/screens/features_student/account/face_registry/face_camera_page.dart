import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/account/register_face_controller.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

// ─── Enums ────────────────────────────────────────────────────────────────────

enum CaptureState { idle, validating, valid, capturing, done }

enum FaceValidation {
  noFace,
  tooClose,
  tooFar,
  notCentered,
  notTurnedRight,
  eyesOpen,
  valid,
}

class FaceCameraPage extends StatefulWidget {
  const FaceCameraPage({Key? key}) : super(key: key);

  @override
  State<FaceCameraPage> createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage>
    with TickerProviderStateMixin {
  // ─── Kamera ───────────────────────────────────────────────────────────────
  // CameraController? _cameraController;
  final _controller = Get.find<RegisterFaceController>();

  // ─── State UI ─────────────────────────────────────────────────────────────
  // FaceStep _currentStep = FaceStep.front;
  CaptureState _captureState = CaptureState.idle;
  FaceValidation _validation = FaceValidation.noFace;

  // ─── Animasi ──────────────────────────────────────────────────────────────
  late AnimationController _progressAnimController;
  late Animation<double> _progressAnimation;
  late AnimationController _countdownController;
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  int getStepIndex(RegisterFaceStep step) {
    switch (step) {
      case RegisterFaceStep.front:
        return 0;
      case RegisterFaceStep.right:
        return 1;
      case RegisterFaceStep.left:
        return 2;
      case RegisterFaceStep.blink:
        return 3;
      case RegisterFaceStep.completed:
        return 3;
    }
  }

  int get _totalStep => 4;

  int get _visibleStepIndex {
    final step = _controller.currentStep.value;

    switch (step) {
      case RegisterFaceStep.front:
        return 0;
      case RegisterFaceStep.right:
        return 1;
      case RegisterFaceStep.left:
        return 2;
      case RegisterFaceStep.blink:
      case RegisterFaceStep.completed:
        return 3;
    }
  }

  // ─── Getter ───────────────────────────────────────────────────────────────
  double get _sw => MediaQuery.of(context).size.width;
  double get _sh => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // _initCamera();
  }

  // ─── Init animasi ─────────────────────────────────────────────────────────
  void _initAnimations() {
    _progressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressAnimController, curve: Curves.easeInOut),
    );
    _updateProgressTarget();

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // _cameraController?.dispose();
    _progressAnimController.dispose();
    _countdownController.dispose();
    _scanAnimController.dispose();
    super.dispose();
  }

  void _updateProgressTarget() {
    final target = (_visibleStepIndex + 1) / _totalStep;
    _progressAnimController.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
    );
  }

  // ─── Step metadata ────────────────────────────────────────────────────────
  int get _stepIndex =>
      RegisterFaceStep.values.indexOf(_controller.currentStep.value);

  // Map<FaceStep, _StepMeta> get _stepMeta => {
  //       FaceStep.front: _StepMeta(
  //         title: 'Lihat lurus ke depan',
  //         subtitle: 'Posisikan wajah Anda di dalam frame',
  //         validLabel: 'Wajah lurus terdeteksi',
  //         icon: Icons.arrow_upward_rounded,
  //       ),
  //       FaceStep.right: _StepMeta(
  //         title: 'Putar kepala ke kanan',
  //         subtitle: 'Perlahan putar kepala Anda ke kanan',
  //         validLabel: 'Posisi kepala terdeteksi',
  //         icon: Icons.arrow_forward_rounded,
  //       ),
  //       FaceStep.left: _StepMeta(
  //         title: 'Putar kepala ke kiri',
  //         subtitle: 'Perlahan putar kepala Anda ke kiri',
  //         validLabel: 'Posisi kepala terdeteksi',
  //         icon: Icons.arrow_back_rounded,
  //       ),
  //       FaceStep.blink: _StepMeta(
  //         title: 'Kedipkan mata anda',
  //         subtitle: 'Silahkan kedipkan mata anda sekali',
  //         validLabel: 'Kedipan terdeteksi',
  //         icon: Icons.visibility_off_outlined,
  //       ),
  //     };

  bool get _isValid => _validation == FaceValidation.valid;

  String get _validationHint {
    final validation = _validationFromController;

    if (_controller.isRegistering.value) {
      return "Mendaftarkan wajah...";
    }

    switch (validation) {
      case FaceValidation.noFace:
        return 'Posisikan wajah Anda di dalam frame';
      case FaceValidation.tooClose:
        return 'Terlalu dekat, mundur sedikit';
      case FaceValidation.tooFar:
        return 'Terlalu jauh, maju sedikit';
      case FaceValidation.notCentered:
        return 'Posisikan wajah di tengah frame';
      case FaceValidation.notTurnedRight:
        return 'Putar kepala lebih ke kanan';
      case FaceValidation.eyesOpen:
        return 'Buka mata dengan jelas';
      case FaceValidation.valid:
        return 'Wajah valid, siap didaftarkan';
    }
  }

  Color get _hintColor {
    if (_captureState == CaptureState.capturing) return blueColor;
    if (_captureState == CaptureState.valid || _isValid) return blueColor;
    if (_validation == FaceValidation.noFace) return greyColor;
    return Colors.orange;
  }

  FaceValidation get _validationFromController {
    if (!_controller.isSingleFace.value) {
      return FaceValidation.noFace;
    }
    if (_controller.isFaceTooSmall.value) {
      return FaceValidation.tooFar;
    }
    if (!_controller.isFaceCentered.value) {
      return FaceValidation.notCentered;
    }
    if (!_controller.isEyesOpen.value) {
      return FaceValidation.eyesOpen;
    }
    if (!_controller.isHeadStraight.value) {
      return FaceValidation.notTurnedRight;
    }
    if (_controller.isFaceValid.value) {
      return FaceValidation.valid;
    }

    return FaceValidation.noFace;
  }

  // ─── Simulasi validasi ────────────────────────────────────────────────────
  // void _simulateValidation(FaceValidation val) {
  //   _countdownController.removeStatusListener(_onCountdownDone);
  //   _countdownController.reset();
  //   setState(() {
  //     _validation = val;
  //     _captureState = val == FaceValidation.valid
  //         ? CaptureState.valid
  //         : CaptureState.validating;
  //   });
  //   if (val == FaceValidation.valid) {
  //     _countdownController.addStatusListener(_onCountdownDone);
  //     _countdownController.forward();
  //   }
  // }

  // void _onCountdownDone(AnimationStatus status) {
  //   if (status == AnimationStatus.completed && mounted) _doCapture();
  // }

  // void _doCapture() {
  //   setState(() => _captureState = CaptureState.capturing);
  //   Future.delayed(const Duration(milliseconds: 700), () {
  //     if (!mounted) return;
  //     _goNextStep();
  //   });
  // }

  // void _goNextStep() {
  //   _countdownController.removeStatusListener(_onCountdownDone);
  //   _countdownController.reset();
  //   final next = {
  //     RegisterFaceStep.front: RegisterFaceStep.right,
  //     RegisterFaceStep.right: RegisterFaceStep.blink,
  //   };
  //   if (next.containsKey(_controller.currentStep.value)) {
  //     setState(() {
  //       // _current = next[_controller.currentStep.value]!;
  //       _captureState = CaptureState.idle;
  //       _validation = FaceValidation.noFace;
  //     });
  //     _updateProgressTarget();
  //   } else {
  //     setState(() => _captureState = CaptureState.done);
  //     Future.delayed(const Duration(seconds: 2), () {
  //       if (mounted) Get.back();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double sw = _sw;
    final double sh = _sh;
    final bool dark = styles.isDarkMode(context);
    // final meta = _stepMeta[_controller.currentStep]!;
    final double frameW = sw * 0.72;
    final double frameH = frameW;

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          CustomHeader(
            title: 'Pendaftaran wajah',
            backgroundColor: styles.getMainColor(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: sh * 0.85),
                child: Column(
                  children: [
                    SizedBox(height: sh * 0.03),

                    // ── Step indicator pills ──────────────────────────────

                    Obx(() => _buildStepIndicator(sw)),

                    SizedBox(height: sh * 0.025),

                    // ── Judul instruksi ───────────────────────────────────
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Obx(() {
                          return Text(
                            _controller.instructionTitle.value,
                            style: GoogleFonts.poppins(
                              fontSize: sw * 0.052,
                              fontWeight: FontWeight.w700,
                              color: styles.getTextColor(context),
                            ),
                            textAlign: TextAlign.center,
                          );
                        })),

                    SizedBox(height: sh * 0.022),

                    // ── Frame kamera ──────────────────────────────────────
                    _buildCameraFrame(sw, sh, frameW, frameH, dark),

                    SizedBox(height: sh * 0.022),

                    // ── Hint validasi card ────────────────────────────────
                    _buildValidationHintCard(sw),

                    SizedBox(height: sh * 0.022),

                    _buildResultCard(sw),

                    SizedBox(height: sh * 0.022),

                    // ── Progress bar ──────────────────────────────────────
                    Obx(() => _buildProgressBar(sw, dark)),

                    SizedBox(height: sh * 0.018),

                    // ── Sim chips + batal ─────────────────────────────────
                    _buildBottomSection(sw, sh),

                    SizedBox(height: sh * 0.025),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step indicator pills (ganti dots) ───────────────────────────────────
  Widget _buildStepIndicator(double sw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isCompleted =
            _controller.currentStep.value == RegisterFaceStep.completed;
        final isActive = !isCompleted && _visibleStepIndex == i;
        final isDone = isCompleted || _visibleStepIndex > i;
        final labels = ['Depan', 'Kanan', 'Kiri', 'Kedip', 'Selesai'];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isDone
                ? blueColor
                : isActive
                    ? blueColor.withOpacity(0.12)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDone || isActive
                  ? blueColor
                  : styles.getSecondaryTextColor(context).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDone)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.check_rounded,
                      size: sw * 0.03, color: Colors.white),
                ),
              Text(
                labels[i],
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  fontWeight: FontWeight.w600,
                  color: isDone
                      ? Colors.white
                      : isActive
                          ? blueColor
                          : styles.getSecondaryTextColor(context),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ─── Frame kamera bulat dengan gradient border ────────────────────────────
  Widget _buildCameraFrame(
      double sw, double sh, double frameW, double frameH, bool dark) {
    final bool isValid = _controller.isFaceValid.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _captureState == CaptureState.validating &&
                  _validation != FaceValidation.noFace &&
                  !_isValid
              ? [Colors.orange.shade300, Colors.orange.shade600]
              : [Colors.blue.shade300, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (_captureState == CaptureState.validating &&
                        _validation != FaceValidation.noFace &&
                        !_isValid
                    ? Colors.orange
                    : Colors.blue)
                .withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: styles.getMainColor(context),
        ),
        child: ClipOval(
          child: SizedBox(
            width: frameW,
            height: frameH,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Live preview ─────────────────────────────────────────

                Obx(() {
                  final cameraReady = _controller.isCameraInitialize.value &&
                      _controller.cameraController != null &&
                      _controller.cameraController!.value.isInitialized;

                  return cameraReady
                      ? _buildCameraPreview(frameW, frameH)
                      : _buildCameraLoading(dark, frameW);
                }),

                // ── Overlay biru saat valid ───────────────────────────────
                Obx(() {
                  return _controller.isFaceValid.value
                      ? Container(
                          color: blueColor.withOpacity(0.06),
                        )
                      : const SizedBox.shrink();
                }),

                // ── Flash putih saat capture ──────────────────────────────
                if (_captureState == CaptureState.capturing)
                  Container(color: Colors.white.withOpacity(0.4)),

                // ── Scan line ─────────────────────────────────────────────
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (_, __) => Positioned(
                    top: _scanAnimation.value * (frameH - 12),
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          blueColor.withOpacity(_isValid ? 0.7 : 0.3),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),

                // ── Countdown ring ────────────────────────────────────────
                if (_captureState == CaptureState.valid)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: AnimatedBuilder(
                      animation: _countdownController,
                      builder: (_, __) => SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          value: 1 - _countdownController.value,
                          strokeWidth: 3,
                          backgroundColor: Colors.white38,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ),

                // ── Centang saat capturing ────────────────────────────────
                if (_captureState == CaptureState.capturing)
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: blueColor.withOpacity(0.2),
                      ),
                      child:
                          Icon(Icons.check_rounded, color: blueColor, size: 42),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(double sw) {
    return Obx(() {
      if (!_controller.hasResult.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: sw * 0.08),
        padding: EdgeInsets.all(sw * 0.035),
        decoration: BoxDecoration(
          color: _controller.isSuccess.value
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _controller.isSuccess.value ? Colors.green : Colors.red,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _controller.resultTitle.value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: _controller.isSuccess.value ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _controller.resultMessage.value,
              style: GoogleFonts.poppins(
                fontSize: sw * 0.032,
                color: styles.getTextColor(context),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Camera preview ───────────────────────────────────────────────────────
  Widget _buildCameraPreview(double frameW, double frameH) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.cameraController!.value.previewSize!.height,
          height: _controller.cameraController!.value.previewSize!.width,
          child: CameraPreview(_controller.cameraController!),
        ),
      ),
    );
  }

  // ─── Loading kamera ───────────────────────────────────────────────────────
  Widget _buildCameraLoading(bool dark, double frameW) {
    return Container(
      color: dark ? const Color(0xFF111318) : const Color(0xFFE8EDF2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child:
                  CircularProgressIndicator(color: blueColor, strokeWidth: 2.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Memuat kamera...',
              style: GoogleFonts.poppins(
                  fontSize: frameW * 0.038, color: greyColor),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Hint validasi sebagai card ───────────────────────────────────────────
  Widget _buildValidationHintCard(double sw) {
    final isWarning = _captureState == CaptureState.validating &&
        _validation != FaceValidation.noFace;
    final isGood = _isValid ||
        _captureState == CaptureState.valid ||
        _captureState == CaptureState.capturing;

    final Color bgColor = isWarning
        ? Colors.orange.withOpacity(0.08)
        : isGood
            ? blueColor.withOpacity(0.08)
            : greyColor.withOpacity(0.06);

    final Color borderColor = isWarning
        ? Colors.orange.withOpacity(0.3)
        : isGood
            ? blueColor.withOpacity(0.3)
            : greyColor.withOpacity(0.2);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_validationHint),
        margin: EdgeInsets.symmetric(horizontal: sw * 0.08),
        padding:
            EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.025),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isWarning
                  ? Icons.warning_amber_rounded
                  : isGood
                      ? Icons.check_circle_outline
                      : Icons.info_outline_rounded,
              color: _hintColor,
              size: sw * 0.042,
            ),
            SizedBox(width: sw * 0.02),
            Flexible(child: Obx(() {
              return Text(
                _controller.instructionMessage.value,
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.033,
                  color: _hintColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              );
            })),
          ],
        ),
      ),
    );
  }

  // ─── Progress bar + step label ────────────────────────────────────────────
  Widget _buildProgressBar(double sw, bool dark) {
    final progress = (_visibleStepIndex + 1) / _totalStep;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (_, __) => LinearProgressIndicator(
                value: (_visibleStepIndex + 1) / _totalStep,
                minHeight: 6,
                backgroundColor:
                    dark ? Colors.white12 : const Color(0xFFDDE3EE),
                valueColor: AlwaysStoppedAnimation<Color>(blueColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah ${_visibleStepIndex + 1} dari $_totalStep',
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  color: styles.getSecondaryTextColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  color: blueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Sim chips + batal ────────────────────────────────────────────────────
  Widget _buildBottomSection(double sw, double sh) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            width: sw * 0.86,
            height: 48,
            child: ElevatedButton(
              onPressed: _controller.isFaceValid.value &&
                      !_controller.isRegistering.value
                  ? _controller.registerFace
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                disabledBackgroundColor: greyColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _controller.isRegistering.value
                    ? 'Mendaftarkan...'
                    : _controller.isAvailable.value
                        ? 'Update Wajah'
                        : 'Daftarkan Wajah',
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.038,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: sh * 0.015),
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontSize: sw * 0.038,
                fontWeight: FontWeight.w500,
                color: blueColor,
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─── Sim chip ─────────────────────────────────────────────────────────────────
class _SimChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isBlue;

  const _SimChip(
      {required this.label, required this.onTap, this.isBlue = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: isBlue
              ? blueColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isBlue ? blueColor : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isBlue ? blueColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────
class _StepMeta {
  final String title;
  final String subtitle;
  final String validLabel;
  final IconData icon;

  _StepMeta({
    required this.title,
    required this.subtitle,
    required this.validLabel,
    required this.icon,
  });
}
