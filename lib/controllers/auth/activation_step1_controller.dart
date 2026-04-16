import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/activation_account_service.dart';

class ActivationStep1Controller extends GetxController {
  final Logger log = Logger();
  final delayedSnackbar = 1;
  final isSnackbarOpen = false.obs;

  TextEditingController emailController = TextEditingController();
  final ActivationAccountService activationAccountService =
      ActivationAccountService();

  void checkEmail() async {
    final email = emailController.text;
    if (email.isEmpty) {
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Email tidak boleh kosong",
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
    } else if (!email.contains('@') || !email.isEmail) {
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Email tidak valid",
          duration: Duration(seconds: delayedSnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
    } else {
      showLoading();
      await sendOtp(email);
    }
  }

  Future<void> sendOtp(String email) async {
    log.d("fetch otp");
    try {
      final result = await activationAccountService.sendOtpActivate(email);

      if (result.status == "success") {
        Get.back();
        Get.offNamed("/auth/activation/step2");
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
      log.f(e);
      Get.back();
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Error: $e",
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
