import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/forget_password_service.dart';

class ForgetPasswordStep3Controller extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final forgetPasswordService = ForgetPasswordService();

  var isSnackbarOpen = false.obs;

  final passwordErrorMessage = ''.obs;
  final confirmPasswordErrorMessage = ''.obs;
  final valuePassword = false.obs;
  final valueConfirmPassword = false.obs;
  final delaySnackbar = 1;

  final email = ''.obs;

  Logger logger = Logger();
  final fromProfile = false.obs;

  Timer? passwordTypingTimer;
  Timer? confirmPasswordTypingTimer;

  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;

  int waktu = 2;

  get isLoading => null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    final success = args['fromProfile'];
    email.value = args['email'];

    logger.d("From profile: $success");

    if (success) {
      fromProfile.value = true;
    } else {
      fromProfile.value = false;
    }
  }

  void checkVisible() => isPasswordVisible.toggle();
  void checkVisible2() => isPasswordVisible2.toggle();

  void validatePassword(String value) {
    if (passwordController.text.length <= 7) {
      valuePassword.value = true;
      passwordErrorMessage.value = "Masukkan password lebih dari 7 huruf";
    } else {
      valuePassword.value = false;
    }
  }

  void validateConfirmPassword(String value) {
    if (confirmPasswordController.text.length <= 7) {
      valueConfirmPassword.value = true;
      confirmPasswordErrorMessage.value =
          "Masukkan confirm password lebih dari 7 huruf";
    } else if (confirmPasswordController.text != passwordController.text) {
      valueConfirmPassword.value = true;
      confirmPasswordErrorMessage.value =
          "Konfirmasi password tidak sesuai dengan password";
    } else {
      valueConfirmPassword.value = false;
    }
  }

  void startTimerPassword() {
    valuePassword.value = false;

    passwordTypingTimer?.cancel();
    passwordTypingTimer = Timer(Duration(seconds: waktu), () {
      validatePassword(passwordController.value.text);
    });
  }

  void startTimerConfirmPassword() {
    valueConfirmPassword.value = false;

    confirmPasswordTypingTimer?.cancel();
    confirmPasswordTypingTimer = Timer(Duration(seconds: waktu), () {
      validateConfirmPassword(confirmPasswordController.value.text);
    });
  }

  Future<void> changePassword() async {
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      logger.e("Password atau confirm password kosong/null");
      return;
    }

    if (valuePassword.value == true || valueConfirmPassword.value == true) {
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Penuhi validasi terlebih dahulu",
          duration: Duration(seconds: delaySnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }

    if (valuePassword.value == false && valueConfirmPassword.value == false) {
      logger.d(email.value);
      logger.d(passwordController.text);

      showLoading();
      BasicResponse response = await forgetPasswordService.changePasswordSv(
          email.value, passwordController.text);

      logger.d(response.message);

      if (response.status == "success") {
        Get.back();
        Get.snackbar("Success", "Password berhasil diubah",
            duration: Duration(seconds: 2));
        Get.offAllNamed("/");
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", response.message,
            duration: Duration(seconds: delaySnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
      return;
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
