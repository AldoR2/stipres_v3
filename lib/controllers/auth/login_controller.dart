import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/dosen_model.dart';
import 'package:stipres/models/mahasiswa_model.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/biometric_auth_service.dart';
import 'package:stipres/services/login_service.dart';
import 'package:stipres/services/token_service.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isSnackbarOpen = false.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final GetStorage _box = GetStorage();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final Logger log = Logger();

  final mahasiswa = Rxn<Mahasiswa>();
  final dosen = Rxn<Dosen>();
  final tokenService = Get.find<TokenService>();
  final loginService = LoginService();
  final biometricService = BiometricAuthService();
  final isBiometricEnabled = false.obs;
  final isSaveLoginInfo = false.obs;

  void checkVisible() => isPasswordVisible.toggle();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkStatusLogin();
      isBiometricEnabled.value = _box.read('isBiometricEnabled') ?? false;
      checkBiometricAvailability();
    });
  }

  void checkBiometricAvailability() async {
    final isAvailable = await biometricService.isBiometricAvailable();

    if (!isAvailable) {
      _box.write("isBiometricAvailable", false);
      log.d("is? : $isAvailable");
      final iss = _box.read("isBiometricAvailable");
      log.d("iss? : $iss");
    }
  }

  Future<void> loginWithBiometric() async {
    final canUse = await biometricService.isBiometricAvailable();
    isBiometricEnabled.value = _box.read('isBiometricEnabled') ?? false;
    final enabled = isBiometricEnabled.value;
    isSaveLoginInfo.value = _box.read("isSaveLoginInfo") ?? false;

    log.d("canuse: $canUse");
    log.d("enabled: $enabled");

    if (!canUse || !enabled || !isSaveLoginInfo.value) {
      isSnackbarOpen.value = true;
      Get.snackbar("Biometrik tidak tersedia", "Pastikan fitur diaktifkan",
          duration: Duration(seconds: 1));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }

    final success = await biometricService.authenticate();
    if (!success) {
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Autentikasi biometrik gagal",
          duration: Duration(seconds: 1));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }

    final status = await tokenService.refreshToken();
    log.w("fetch value status: $status");

    final role = await storage.read(key: 'role');
    if (role != null && role == "dosen") {
      final dosenId = await storage.read(key: "dosen_id");
      if (dosenId != null) {
        showLoading();
        final result = await loginService.loginBiometricDosen(role, dosenId);
        if (result.status == "success") {
          Get.back();
          dosen.value = result.data!;
          _box.write("logged", true);
          _box.write("role", "dosen");
          Get.offAllNamed("/lecturer/base-screen");
          return;
        } else {
          Get.back();
          isSnackbarOpen.value = true;
          Get.snackbar("Gagal", result.message, duration: Duration(seconds: 2));
          Future.delayed(Duration(seconds: 3), () {
            isSnackbarOpen.value = false;
          });
        }
      }
    } else if (role != null && role == "mahasiswa") {
      try {
        final mahasiswaId = await storage.read(key: "mahasiswa_id");
        // log.d("check mahasiswa ID : $mahasiswaId");
        if (mahasiswaId != null) {
          showLoading();
          final result =
              await loginService.loginBiometricMahasiswa(role, mahasiswaId);
          if (result.status == "success") {
            Get.back();
            mahasiswa.value = result.data;
            log.d("nama log ${_box.read("user_name")}");
            _box.write("logged", true);
            _box.write("role", "mahasiswa");
            Get.offAllNamed("/student/base-screen");
          } else {
            Get.back();
            isSnackbarOpen.value = true;
            Get.snackbar("Gagal", result.message,
                duration: Duration(seconds: 2));
            Future.delayed(Duration(seconds: 3), () {
              isSnackbarOpen.value = false;
            });
          }
        }
      } catch (e) {
        log.f("error: $e");
      }
    }
  }

  void checkStatusLogin() {
    final statusUser = _box.read("logged");
    final statusUserRole = _box.read("role");

    if (statusUser == true) {
      if (statusUserRole == "mahasiswa") {
        Get.offAllNamed("/student/base-screen");
      } else if (statusUserRole == "dosen") {
        Get.offAllNamed("/lecturer/base-screen");
      }
    } else {}
  }

  void login() async {
    isLoading.value = true;

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      isSnackbarOpen.value = true;
      Get.snackbar("Error", "NIM dan Password tidak boleh kosong",
          duration: Duration(seconds: 1));
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      isLoading.value = false;
      return;
    }

    final pass = password.length;
    if (pass <= 7) {
      isSnackbarOpen.value = true;
      Get.snackbar(
        "Gagal",
        "Masukkan lebih dari 7 huruf password",
        duration: Duration(seconds: 1),
      );
      Future.delayed(Duration(seconds: 2), () {
        isSnackbarOpen.value = false;
      });
      return;
    }

    if (username.contains('@')) {
      showLoading();
      final result = await loginService.loginDosen(username, password);

      if (result.status == "success") {
        Get.back();
        dosen.value = result;
        _box.write("logged", true);
        _box.write("role", "dosen");
        Get.offAllNamed("/lecturer/base-screen");
        return;
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", result.message ?? "Login Gagal",
            duration: Duration(seconds: 2));
        Future.delayed(Duration(seconds: 3), () {
          isSnackbarOpen.value = false;
        });
      }

      isLoading.value = false;
    } else {
      showLoading();
      final result = await loginService.loginMahasiswa(username, password);

      if (result.status == "success") {
        Get.back();
        mahasiswa.value = result;
        log.d("nama log ${_box.read("user_name")}");
        _box.write("logged", true);
        _box.write("role", "mahasiswa");
        Get.offAllNamed("/student/base-screen");
      } else {
        Get.back();
        isSnackbarOpen.value = true;
        Get.snackbar("Gagal", result.message ?? "Login Gagal",
            duration: Duration(seconds: 2));
        Future.delayed(Duration(seconds: 3), () {
          isSnackbarOpen.value = false;
        });
      }

      isLoading.value = false;
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
