import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stipres/services/biometric_auth_service.dart';
import 'package:stipres/services/fcm_service.dart';

class SettingsController extends GetxController {
  final biometricService = BiometricAuthService();
  final isNotifOn = true.obs;
  final GetStorage _box = GetStorage();
  final FcmService fcmService = FcmService();
  final isNotificationEnabled = false.obs;
  final Logger log = Logger();

  @override
  void onInit() {
    super.onInit();
    isNotificationEnabled.value = _box.read("isNotificationEnabled") ?? true;
  }

  void checkAvalaiblityBiometric() async {
    final canUse = await biometricService.isBiometricAvailable();

    if (canUse == true) {
      Get.toNamed("/student/biometric-screen");
    } else {
      Get.snackbar("Gagal",
          "Fitur biometrik / sidik jari tidak tersedia pada perangkat anda");
    }
  }

  void toggleNotification(bool value) async {
    isNotificationEnabled.value = value;
    _box.write('isNotificationEnabled', value);

    if (value == false) {
      await FirebaseMessaging.instance.deleteToken();
    } else {
      // Cek apakah user sudah memberi izin notifikasi
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await fcmService.sendFcmToken(token);
        }
      } else {
        // Tidak diberi izin => arahkan user ke pengaturan aplikasi
        Get.defaultDialog(
          title: "Izin Notifikasi",
          middleText:
              "Notifikasi masih belum diizinkan di perangkat ini. Silahkan aktifkan izin notifikasi di pengaturan aplikasi.",
          textConfirm: "Buka Pengaturan",
          textCancel: "Batal",
          onConfirm: () {
            openAppSettings(); // membuka pengaturan sistem
            Get.back();
          },
          onCancel: () {},
        );
        isNotificationEnabled.value = false;
        return;
      }
    }
  }
}
