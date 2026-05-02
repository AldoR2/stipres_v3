import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/services/location_permission_service.dart';

void showEnableGPSDialog() {
  Get.dialog(
    AlertDialog(
      title: Text("Aktifkan Lokasi"),
      content: Text("GPS harus aktif untuk menggunakan fitur ini"),
      actions: [
        TextButton(onPressed: Get.back, child: Text("Batal")),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await LocationPermissionService().openLocationSetting();
          },
          child: Text("Aktifkan"),
        ),
      ],
    ),
  );
}

void showPermissionDeniedDialog() {
  Get.dialog(
    AlertDialog(
      title: Text("Izinkan Lokasi"),
      content: Text("Silahkan aktifkan izin lokasi di pengaturan"),
      actions: [
        TextButton(onPressed: Get.back, child: Text("Batal")),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await LocationPermissionService().openAppSetting();
          },
          child: Text("Buka Pengaturan"),
        ),
      ],
    ),
  );
}
