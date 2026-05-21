import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

// ─── Enums ────────────────────────────────────────────────────────────────────
enum FaceStep { front, right, blink }

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
  CameraController? _cameraController;
  bool _isCameraReady = false;

  // ─── State UI ─────────────────────────────────────────────────────────────
  FaceStep _currentStep = FaceStep.front;
  CaptureState _captureState = CaptureState.idle;
  FaceValidation _validation = FaceValidation.noFace;

  // ─── Animasi ──────────────────────────────────────────────────────────────
  late AnimationController _progressAnimController;
  late Animation<double> _progressAnimation;
  late AnimationController _countdownController;
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  // ─── Getter ───────────────────────────────────────────────────────────────
  double get _sw => MediaQuery.of(context).size.width;
  double get _sh => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initCamera();
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

  // ─── Init kamera depan ────────────────────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _progressAnimController.dispose();
    _countdownController.dispose();
    _scanAnimController.dispose();
    super.dispose();
  }

  void _updateProgressTarget() {
    final target = (_stepIndex + 1) / FaceStep.values.length;
    _progressAnimController.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
    );
  }

  // ─── Step metadata ────────────────────────────────────────────────────────
  int get _stepIndex => FaceStep.values.indexOf(_currentStep);

  Map<FaceStep, _StepMeta> get _stepMeta => {
        FaceStep.front: _StepMeta(
          title: 'Lihat lurus ke depan',
          subtitle: 'Posisikan wajah Anda di dalam frame',
          validLabel: 'Wajah lurus terdeteksi',
          icon: Icons.arrow_upward_rounded,
        ),
        FaceStep.right: _StepMeta(
          title: 'Putar kepala ke kanan',
          subtitle: 'Perlahan putar kepala Anda ke kanan',
          validLabel: 'Posisi kepala terdeteksi',
          icon: Icons.arrow_forward_rounded,
        ),
        FaceStep.blink: _StepMeta(
          title: 'Kedipkan mata anda',
          subtitle: 'Silahkan kedipkan mata anda sekali',
          validLabel: 'Kedipan terdeteksi',
          icon: Icons.visibility_off_outlined,
        ),
      };

  bool get _isValid => _validation == FaceValidation.valid;

  String get _validationHint {
    if (_captureState == CaptureState.capturing) return 'Mengambil gambar...';
    if (_captureState == CaptureState.valid)
      return _stepMeta[_currentStep]!.validLabel;
    switch (_validation) {
      case FaceValidation.noFace:
        return _stepMeta[_currentStep]!.subtitle;
      case FaceValidation.tooClose:
        return 'Terlalu dekat, mundur sedikit';
      case FaceValidation.tooFar:
        return 'Terlalu jauh, maju sedikit';
      case FaceValidation.notCentered:
        return 'Posisikan wajah di tengah frame';
      case FaceValidation.notTurnedRight:
        return 'Putar kepala lebih ke kanan';
      case FaceValidation.eyesOpen:
        return 'Kedipkan mata sekarang';
      case FaceValidation.valid:
        return _stepMeta[_currentStep]!.validLabel;
    }
  }

  Color get _hintColor {
    if (_captureState == CaptureState.capturing) return blueColor;
    if (_captureState == CaptureState.valid || _isValid) return blueColor;
    if (_validation == FaceValidation.noFace) return greyColor;
    return Colors.orange;
  }

  // ─── Simulasi validasi ────────────────────────────────────────────────────
  void _simulateValidation(FaceValidation val) {
    _countdownController.removeStatusListener(_onCountdownDone);
    _countdownController.reset();
    setState(() {
      _validation = val;
      _captureState = val == FaceValidation.valid
          ? CaptureState.valid
          : CaptureState.validating;
    });
    if (val == FaceValidation.valid) {
      _countdownController.addStatusListener(_onCountdownDone);
      _countdownController.forward();
    }
  }

  void _onCountdownDone(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) _doCapture();
  }

  void _doCapture() {
    setState(() => _captureState = CaptureState.capturing);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _goNextStep();
    });
  }

  void _goNextStep() {
    _countdownController.removeStatusListener(_onCountdownDone);
    _countdownController.reset();
    final next = {
      FaceStep.front: FaceStep.right,
      FaceStep.right: FaceStep.blink,
    };
    if (next.containsKey(_currentStep)) {
      setState(() {
        _currentStep = next[_currentStep]!;
        _captureState = CaptureState.idle;
        _validation = FaceValidation.noFace;
      });
      _updateProgressTarget();
    } else {
      setState(() => _captureState = CaptureState.done);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sw = _sw;
    final double sh = _sh;
    final bool dark = styles.isDarkMode(context);
    final meta = _stepMeta[_currentStep]!;
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
                    _buildStepIndicator(sw),

                    SizedBox(height: sh * 0.025),

                    // ── Judul instruksi ───────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: Text(
                        meta.title,
                        key: ValueKey(_currentStep),
                        style: GoogleFonts.poppins(
                          fontSize: sw * 0.052,
                          fontWeight: FontWeight.w700,
                          color: styles.getTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: sh * 0.022),

                    // ── Frame kamera ──────────────────────────────────────
                    _buildCameraFrame(sw, sh, frameW, frameH, dark),

                    SizedBox(height: sh * 0.022),

                    // ── Hint validasi card ────────────────────────────────
                    _buildValidationHintCard(sw),

                    SizedBox(height: sh * 0.022),

                    // ── Progress bar ──────────────────────────────────────
                    _buildProgressBar(sw, dark),

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
      children: List.generate(FaceStep.values.length, (i) {
        final isActive = _stepIndex == i;
        final isDone = _stepIndex > i;
        final labels = ['Depan', 'Samping', 'Kedip'];
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
                _isCameraReady && _cameraController != null
                    ? _buildCameraPreview(frameW, frameH)
                    : _buildCameraLoading(dark, frameW),

                // ── Overlay biru saat valid ───────────────────────────────
                if (_captureState == CaptureState.valid ||
                    _captureState == CaptureState.capturing)
                  Container(color: blueColor.withOpacity(0.06)),

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

  // ─── Camera preview ───────────────────────────────────────────────────────
  Widget _buildCameraPreview(double frameW, double frameH) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _cameraController!.value.previewSize!.height,
          height: _cameraController!.value.previewSize!.width,
          child: CameraPreview(_cameraController!),
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
            Flexible(
              child: Text(
                _validationHint,
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.033,
                  color: _hintColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Progress bar + step label ────────────────────────────────────────────
  Widget _buildProgressBar(double sw, bool dark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (_, __) => LinearProgressIndicator(
                value: _progressAnimation.value,
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
                'Langkah ${_stepIndex + 1} dari ${FaceStep.values.length}',
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  color: styles.getSecondaryTextColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((_stepIndex + 1) / FaceStep.values.length * 100).toInt()}%',
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
    if (_captureState == CaptureState.done) return const SizedBox.shrink();

    return Column(
      children: [
        // Sim chips — HAPUS saat integrasi ML Kit
        Wrap(
          spacing: 7,
          runSpacing: 7,
          alignment: WrapAlignment.center,
          children: [
            _SimChip(
                label: 'Tidak ada wajah',
                onTap: () => _simulateValidation(FaceValidation.noFace)),
            _SimChip(
                label: 'Terlalu dekat',
                onTap: () => _simulateValidation(FaceValidation.tooClose)),
            _SimChip(
                label: 'Terlalu jauh',
                onTap: () => _simulateValidation(FaceValidation.tooFar)),
            _SimChip(
                label: 'Tidak center',
                onTap: () => _simulateValidation(FaceValidation.notCentered)),
            _SimChip(
                label: '✓ Valid',
                onTap: () => _simulateValidation(FaceValidation.valid),
                isBlue: true),
          ],
        ),

        SizedBox(height: sh * 0.02),

        // ── Tombol Batal dengan background ───────────────────────────────
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.18,
              vertical: sw * 0.03,
            ),
            decoration: BoxDecoration(
              color: blueColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: blueColor.withOpacity(0.3)),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontSize: sw * 0.04,
                fontWeight: FontWeight.w500,
                color: blueColor,
              ),
            ),
          ),
        ),
      ],
    );
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
