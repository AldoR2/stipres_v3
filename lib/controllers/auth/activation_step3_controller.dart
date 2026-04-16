import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/activation_account_service.dart';

class ActivationStep3Controller extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ActivationAccountService activationAccountService =
      ActivationAccountService();

  var isSnackbarOpen = false.obs;
  final passwordErrorMessage = ''.obs;
  final confirmPasswordErrorMessage = ''.obs;
  final valuePassword = false.obs;
  final valueConfirmPassword = false.obs;
  final delaySnackbar = 1;
  var nim = ''.obs;

  final Logger log = Logger();
  Timer? passwordTypingTimer;
  Timer? confirmPasswordTypingTimer;

  int waktu = 1;

  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;

  @override
  void onInit() {
    super.onInit();
    nim.value = Get.arguments;
    log.d(nim.value);
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

  void validate() async {
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // bisa juga kasih warning user
      log.e("Password atau confirm password kosong/null");
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
    } else if (valuePassword.value == false &&
        valueConfirmPassword.value == false) {
      showLoading();
      await validateAccount(passwordController.text.trim().toString());
    }
  }

  Future<void> validateAccount(String password) async {
    log.d("Password: $password");
    log.d("nim: ${nim.value}");
    try {
      final result =
          await activationAccountService.activateAccount(password, nim.value);
      if (result.status == "success") {
        Get.back();
        Get.snackbar("Success", "Akun berhasil diaktivasi",
            duration: Duration(seconds: 2));
        Get.offAllNamed("/");
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", result.message,
            duration: Duration(seconds: delaySnackbar));
        Future.delayed(Duration(seconds: 2), () {
          isSnackbarOpen.value = false;
        });
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Error: $e",
          duration: Duration(seconds: delaySnackbar));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
    }
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
    );
  }
}
