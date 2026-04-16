import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/services/forget_password_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ForgetPasswordStep2Controller extends GetxController {
  var isButtonEnabled = true.obs;
  var isSnackbarOpen = false.obs;

  final otpController = TextEditingController();
  final forgetPasswordService = ForgetPasswordService();

  var isLoading = false.obs;
  final delaySnackbar = 1;

  late StopWatchTimer resendTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromMinute(5));

  var textKirim = 'Kirim'.obs;
  var statusMessage = ''.obs;

  final String email = GetStorage().read("email_otp");

  var logger = Logger();

  String maskedEmail() {
    logger.d(email);
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    final visiblePart =
        username.length >= 4 ? username.substring(0, 4) : username;
    final masked = visiblePart + '*' * (username.length - visiblePart.length);

    return '$masked@$domain';
  }

  void send() {
    if (isButtonEnabled.value == true && isLoading.value == false) {
      reSendOtp(email);
      startTimer();
    }
  }

  void startTimer() async {
    logger.d("Starting timer...");
    logger.d(resendTimer);

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

  Future<void> reSendOtp(String email) async {
    try {
      isLoading.value = true;

      showLoading();
      final result = await ForgetPasswordService().sendOtpSv(email);

      if (result.status == "success") {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Berhasil", "OTP baru telah dikirim ke $email",
            duration: Duration(seconds: delaySnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
    } catch (e) {
      Get.back();
      isSnackbarOpen.value = true;
      Get.snackbar("Error", e.toString(),
          duration: Duration(seconds: delaySnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
        isLoading.value = false;
      });
    }
  }

  Future<void> checkOtp() async {
    logger.d("checking");
    isLoading.value = true;

    final otp = otpController.text.trim();
    logger.d(otp);

    if (otp.length < 4) {
      isSnackbarOpen.value = true;
      Get.snackbar("Error", "OTP harus lengkap",
          duration: Duration(seconds: delaySnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
        isLoading.value = false;
      });
      return;
    }

    showLoading();
    bool success = await forgetPasswordService.checkOtp(email, otp);

    if (success) {
      Get.back();
      Get.offNamed(
        "/auth/forget-password/step3",
        arguments: {"fromProfile": false, "email": email},
      );
      logger.d(email);
    } else {
      Get.back();
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "OTP salah atau kadaluwarsa",
          duration: Duration(seconds: 1));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
        isLoading.value = false;
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
