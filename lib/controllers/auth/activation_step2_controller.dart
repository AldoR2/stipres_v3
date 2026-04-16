import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/activation_account_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ActivationStep2Controller extends GetxController {
  final Logger log = Logger();
  final delayedSnackbar = 1;
  final isSnackbarOpen = false.obs;
  var isButtonEnabled = true.obs;
  final storedEmail = ''.obs;
  var textKirim = 'Kirim'.obs;

  final GetStorage _box = GetStorage();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nimController = TextEditingController();

  late StopWatchTimer resendTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromMinute(5));

  final ActivationAccountService activationAccountService =
      ActivationAccountService();

  String maskedEmail() {
    final email = _box.read("email_otp");
    log.d(email);
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    final visiblePart =
        username.length >= 4 ? username.substring(0, 4) : username;
    final masked = visiblePart + '*' * (username.length - visiblePart.length);

    return '$masked@$domain';
  }

  void startTimer() async {
    log.d("Starting timer...");
    log.d(resendTimer);

    if (!isButtonEnabled.value) return;
    isButtonEnabled.value = false;

    resendTimer.onResetTimer();
    resendTimer.onStartTimer();

    resendTimer.rawTime.listen((rawTime) {
      final remainingTime = StopWatchTimer.getDisplayTime(rawTime,
          milliSecond: false, hours: false);
      textKirim.value = remainingTime;
    });

    await Future.delayed(Duration(minutes: 5));
    isButtonEnabled.value = true;
    textKirim.value = "Kirim";
  }

  void send() async {
    final email = _box.read("email_otp");
    if (isButtonEnabled.value == true) {
      log.d("resend otp");
      showLoading();
      await reSendOtp(email);
      startTimer();
    }
  }

  Future<void> reSendOtp(String email) async {
    try {
      final result = await activationAccountService.sendOtpActivate(email);
      if (result.status == "success") {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Berhasil", "OTP baru telah dikirim ke $email",
            duration: Duration(seconds: delayedSnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", result.message,
            duration: Duration(seconds: delayedSnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
    } catch (e) {
      Get.back();
      isSnackbarOpen.value = true;
      Get.snackbar("Error", e.toString(),
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
    }
  }

  Future<void> checkOtp() async {
    final email = _box.read("email_otp");
    final otp = otpController.text.trim();
    final nim = nimController.text.trim();
    log.d("Kode otp: $otp");

    if (otp.length < 4) {
      isSnackbarOpen.value = true;
      Get.snackbar("Error", "OTP harus lengkap",
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }
    if (nim.isEmpty) {
      isSnackbarOpen.value = true;
      Get.snackbar("Error", "Nim harus diisi",
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }

    try {
      showLoading();
      final result = await activationAccountService.checkOtp(email, nim, otp);

      if (result.status == "success") {
        Get.back();
        Get.offNamed("auth/activation/step3", arguments: nim);
        log.d(nim);
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", result.message);
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
      isSnackbarOpen.value = true;
      Get.snackbar("Error", e.toString(),
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
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
