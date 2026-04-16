import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/controllers/auth/login_controller.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/fcm_service.dart';

class ProfileController extends GetxController {
  final storedName = ''.obs;
  final storedNim = ''.obs;
  final storedEmail = ''.obs;
  final storedProdi = ''.obs;
  final storedNamaProdi = ''.obs;
  var storedProfile = ''.obs;

  final url = ApiConstants.path;
  final isBiometricAvailable = false.obs;
  final isBiometricEnabled = false.obs;
  final isNotificationEnabled = false.obs;
  final saveLoginInfo = true.obs;

  final _box = GetStorage();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final FcmService fcmService = FcmService();

  final log = Logger();

  @override
  void onInit() {
    super.onInit();
    loadHeader();
  }

  Future<void> loadHeader() async {
    String? nama = _box.read("user_nama");
    String? nim = _box.read("user_nim");
    String? email = _box.read("user_email");
    String? namaProdi = _box.read("nama_prodi");
    int? idProdi = _box.read("id_prodi");
    String? profile = _box.read("foto");

    storedName.value = nama ?? 'No name found';
    storedNim.value = nim ?? 'No nim found';
    storedEmail.value = email ?? 'No email found';
    storedNamaProdi.value = namaProdi ?? 'No name prodi found';
    storedProdi.value = idProdi.toString();
    final profileUrl =
        "$url${profile}?v=${DateTime.now().millisecondsSinceEpoch}";
    storedProfile.value = profileUrl;
  }

  Future<void> checkBiometric() async {
    isBiometricAvailable.value = _box.read("isBiometricAvailable") ?? true;
    isBiometricEnabled.value = _box.read("isBiometricEnabled") ?? true;
    isNotificationEnabled.value = _box.read("isNotificationEnabled") ?? true;
    log.d("status biometric: $isBiometricAvailable");
    log.d("status Enabledc: $isBiometricEnabled");
    log.d("status notification: $isNotificationEnabled");
  }

  void changePassword() async {
    String? email = _box.read("user_email");
    Get.toNamed(
      "/auth/forget-password/step3",
      arguments: {"fromProfile": true, "email": email},
    );
  }

  void logout() async {
    showLoading();
    final tokenfcm = await FcmService.getToken();
    log.d(tokenfcm);
    await fcmService.deleteFcmToken(tokenfcm!);
    _box.erase();
    Get.delete<LoginController>();
    Get.offAllNamed("/");
    if (saveLoginInfo.value) {
      Get.back();
      _box.write("isBiometricEnabled", isBiometricEnabled.value);
      _box.write("isNotificationEnabled", isNotificationEnabled.value);
      _box.write("isSaveLoginInfo", saveLoginInfo.value);
      log.d("isBiometricEnabled: ${isBiometricEnabled.value}");
      log.d("isSaveLoginInfo: ${saveLoginInfo.value}");
      log.d("isNotificationEnabled: ${isNotificationEnabled.value}");
      final mahasiswaId = await storage.read(key: "mahasiswa_id");
      log.f("check logout mahasiswaId: ${mahasiswaId}");
    } else {
      Get.back();
      await storage.deleteAll();
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
