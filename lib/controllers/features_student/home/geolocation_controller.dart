import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/validation_step_model.dart';
import 'package:stipres/screens/reusable/failed_dialog.dart';
import 'package:stipres/screens/reusable/location_dialog.dart';
import 'package:stipres/screens/reusable/success_dialog.dart';
import 'package:stipres/services/location_permission_service.dart';
import 'package:stipres/services/security_location_service.dart';
import 'package:stipres/services/student/location_student_service.dart';

class GeolocationController extends GetxController {
  final RxList<ValidationStepModel> steps = <ValidationStepModel>[
    ValidationStepModel(
        title: 'Deteksi Emulator', description: 'Memeriksa perangkat virtual'),
    ValidationStepModel(
        title: 'Deteksi Root / Jailbreak',
        description: 'Memerika integritas sistem'),
    ValidationStepModel(
        title: 'Mock Location', description: 'Memverifikasi manipulasi GPS'),
    ValidationStepModel(
        title: 'Validation Location',
        description: 'Memverifikasi Lokasi Absensi'),
  ].obs;

  LocationPermissionService locationPermissionService =
      LocationPermissionService();
  LocationStudentService locationStudentService = LocationStudentService();
  final security = SecurityLocationService();

  final Logger log = Logger();

  final RxDouble progress = 0.0.obs;
  final Rxn<LatLng> userLocation = Rxn<LatLng>();
  final RxBool isInsideRadius = false.obs;

  final errorMessage = ''.obs;

  late double targetLat;
  late double targetLng;
  late double radiusMeter;

  @override
  void onInit() {
    super.onInit();
    initPage();
  }

  Future<void> initPage() async {
    final lokasiId = Get.arguments[1] as int;
    await fetchLocation(lokasiId);
    await _getCurrentLocation();
    await loadValidation();
  }

  Future<void> fetchLocation(int lokasiId) async {
    try {
      bool ready = await ensureLocationReady();
      if (!ready) return;
      final result = await locationStudentService.showLocation(lokasiId);

      if (result.status == "success" && result.data != null) {
        final summary = result.data;

        targetLat = summary!.latitude;
        targetLng = summary.longitude;
        radiusMeter = summary.radius!.toDouble();
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<bool> ensureLocationReady() async {
    bool serviceEnabled =
        await locationPermissionService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showEnableGPSDialog();
      return false;
    }

    LocationPermission permission =
        await locationPermissionService.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      showPermissionDeniedDialog();
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled =
        await locationPermissionService.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission =
        await locationPermissionService.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await locationPermissionService.requestPermission();
    }

    final position = await locationPermissionService.getCurrentLocation();

    userLocation.value = LatLng(position.latitude, position.longitude);

    if (position.accuracy > 20) {
      Get.snackbar("Absensi Gagal", "Akurasi rendah");
      return;
    }

    _validateRadius(position);
  }

  Future<void> loadValidation() async {
    final result = await runValidation();

    if (result == true) {
      Get.dialog(SuccessDialog(
          title: "Presensi berhasil",
          subtitle: "Data presensi berhasil ditambahkan",
          gifAssetPath: "assets/gif/success_animation.gif"));
    } else {
      Get.dialog(FailedDialog(
          title: "Presensi gagal",
          subtitle: errorMessage.value.isNotEmpty
              ? errorMessage.value
              : "Data presensi gagal ditambahkan",
          gifAssetPath: "assets/gif/failed_animation.gif"));
    }
  }

  void _validateRadius(Position position) async {
    final distance = await locationPermissionService.distanceBetween(
        position.latitude, position.longitude, targetLat, targetLng);

    isInsideRadius.value = distance <= radiusMeter;
    log.d("Inside? ${isInsideRadius.value}");
  }

  Future<bool> runValidation() async {
    bool emulatorValid = await validateStep(
        index: 0,
        validator: () async {
          return !(await security.isEmulator());
        });
    if (!emulatorValid) return false;

    bool rootValid = await validateStep(
        index: 1,
        validator: () async {
          return !(await security.isRooted());
        });
    if (!rootValid) return false;

    final possition = await locationPermissionService.getCurrentLocation();

    bool mockValid = await validateStep(
        index: 2,
        validator: () async {
          return !(await security.isMockLocation(possition));
        });
    if (!mockValid) return false;

    if (possition.accuracy > 20) {
      errorMessage.value = 'Akurasi gps rendah';
      return false;
    }

    bool isInside = await validateStep(
        index: 3,
        validator: () async {
          return (isInsideRadius.value);
        });
    if (!isInside) return false;

    return true;
  }

  Future<bool> validateStep(
      {required int index, required Future<bool> Function() validator}) async {
    steps[index].status = ValidationStatus.checking;
    steps.refresh();

    progress.value = (index + 0.5) / steps.length;

    await Future.delayed(const Duration(milliseconds: 800));

    final result = await validator();

    if (!result) {
      steps[index].status = ValidationStatus.failed;
      steps.refresh();

      return false;
    }

    steps[index].status = ValidationStatus.success;
    steps.refresh();

    progress.value = (index + 1) / steps.length;

    return true;
  }
}
