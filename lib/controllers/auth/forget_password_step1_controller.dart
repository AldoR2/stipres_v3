import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/forget_password_service.dart';

class ForgetPasswordStep1Controller extends GetxController {
  var statusMessage = ''.obs;
  var logger = Logger();
  final delayedSnackbar = 1;
  var isSnackbarOpen = false.obs;


  Future<void> sendOtp(String email) async {
    try {
      logger.d("email masuk: $email");

      if (email.isEmpty) {
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", "Email tidak boleh kosong",
            duration: Duration(seconds: delayedSnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
        logger.d("Email is empty");
        return;
        // return Get.offNamed("/auth/forget-password/step1");
      } else if (!email.contains("@") || !email.isEmail) {
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", "Email tidak valid",
            duration: Duration(seconds: delayedSnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
        logger.d("Email is not valid");
        return;
        // return Get.offNamed("/auth/forget-password/step1");
      }

      showLoading();
      BaseResponse result = await ForgetPasswordService().sendOtpSv(email);

      if (result.status == "success") {
        Get.back();
        Get.offNamed("/auth/forget-password/step2");
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", "Email tidak valid",
            duration: Duration(seconds: delayedSnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
    } catch (e) {
      Get.back();
      isSnackbarOpen.value = true;
      Get.snackbar("Error", "Error ; $e",
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
