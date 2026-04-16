import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/screens/reusable/upload_data_dialog.dart';

class NetworkController extends GetxController {
  final isConnected = true.obs;

  late StreamSubscription _subscription;
  bool _firstCheck = true;

  @override
  void onInit() {
    super.onInit();
    _monitorInternet();
  }

  void _monitorInternet() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      final hasInternet =
          await InternetConnectionChecker.instance.hasConnection;

      final oldStatus = isConnected.value;
      isConnected.value = hasInternet;

      if (!hasInternet && oldStatus != hasInternet) {
        // hanya tampilkan sekali saat status berubah
        if (!hasInternet && oldStatus != hasInternet) {
          // Tampilkan UploadDialog hanya sekali saat koneksi hilang
          Get.dialog(
            UploadDialog(
                title: "Tidak ada koneksi",
                subtitle: "Sambungkan ke internet untuk melanjutkan.",
                gifAssetPath: "assets/gif/failed_animation.gif",
                onOkPressed: () async {
                  // Tutup UploadDialog
                  Get.back();

                  // Tampilkan loading dialog
                  Get.dialog(
                    const LoadingPopup(),
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.3),
                  );

                  final timeoutDuration = Duration(seconds: 9);
                  final startTime = DateTime.now();

                  while (true) {
                    final hasInternet =
                        await InternetConnectionChecker.instance.hasConnection;

                    if (hasInternet) {
                      // Tutup loading dan keluar loop jika internet kembali
                      if (Get.isDialogOpen ?? false) Get.back();
                      break;
                    }

                    // Cek jika sudah timeout
                    final now = DateTime.now();
                    if (now.difference(startTime) > timeoutDuration) {
                      // Tutup loading popup jika masih terbuka
                      if (Get.isDialogOpen ?? false) Get.back();

                      // Tampilkan UploadDialog ulang (loop manual)
                      Get.dialog(
                        UploadDialog(
                          title: "Masih tidak ada koneksi",
                          subtitle: "Periksa koneksi Anda dan coba lagi.",
                          gifAssetPath: "assets/gif/failed_animation.gif",
                          onOkPressed: () {
                            // Panggil fungsi ini lagi untuk coba ulang
                            Get.back(); // Tutup dialog UploadDialog
                            _monitorInternet();
                          },
                        ),
                        barrierDismissible: false,
                      );
                      break;
                    }

                    await Future.delayed(const Duration(seconds: 2));
                  }
                }),
            barrierDismissible: false,
          );
        }

        _firstCheck = false;
      }
    });
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  void showNoConnectionDialog() {
    Get.defaultDialog(
      title: 'Tidak Ada Koneksi',
      content: const Text('Sambungkan ke internet untuk melanjutkan.'),
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () async {
          // Tampilkan loading dialog
          Get.dialog(
            const LoadingPopup(),
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.3),
          );

          // Loop sampai koneksi kembali
          while (true) {
            final hasInternet =
                await InternetConnectionChecker.instance.hasConnection;
            if (hasInternet) {
              Get.back(); // close loading dialog
              Get.back(); // close no connection dialog
              break;
            }

            await Future.delayed(const Duration(seconds: 2));
          }
        },
        child: const Text('Coba Lagi'),
      ),
      cancel: TextButton(
        onPressed: () {
          // Tutup app
          Get.back(); // close dialog
          // Close app programmatically
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.close(
                0); // or SystemNavigator.pop(); if not using GetMaterialApp
          });
        },
        child: const Text('Keluar'),
      ),
    );
  }
}
