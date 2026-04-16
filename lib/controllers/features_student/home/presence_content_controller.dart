import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:stipres/models/students/get_presence_model.dart';
import 'package:stipres/screens/reusable/failed_dialog.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/screens/reusable/success_dialog.dart';
import 'package:stipres/screens/reusable/upload_data_dialog.dart';
import 'package:stipres/services/student/presence_content_service.dart';

import 'package:timezone/timezone.dart' as tz;

enum StatusPresensi { hadir, ijin, sakit }

class PresenceContentController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final alasanController = TextEditingController();
  var jumlahKarakter = 0.obs;
  final int maksKarakter = 250;
  final isSnackbarOpen = false.obs;

  final statusAbsen = 0.obs;

  var status = Rxn<StatusPresensi>();
  var presence = GetPresenceApi().obs;
  final PresenceContentService presenceContentService =
      PresenceContentService();

  static const int maxSizeInBytes = 5 * 1024 * 1024;

  var presensiId = ''.obs;
  var presensisId = 0.obs;
  var errorMessage = ''.obs;

  final ImagePicker pickedImage = ImagePicker();

  final bukti = Rxn<File>();
  final buktiExtension = RxString('');

  var statusData = false.obs;

  @override
  void onInit() {
    super.onInit();
    alasanController.addListener(hitungKarakter);
    presensiId.value = Get.arguments[0];
    presensisId.value = Get.arguments[1] as int;
    log.d(presensiId);
    log.d(presensisId);
  }

  @override
  void onReady() {
    super.onReady();
    if (presensiId.value.isNotEmpty) {
      checkAttendanceTime();
    }
  }

  @override
  void onClose() {
    alasanController.dispose();
    super.onClose();
  }

  void hitungKarakter() {
    final text = alasanController.text;
    jumlahKarakter.value = text.length;

    if (jumlahKarakter > maksKarakter) {
      alasanController.text = text.substring(0, maksKarakter);
      alasanController.selection = TextSelection.fromPosition(
        TextPosition(offset: maksKarakter),
      );
    }
  }

  bool validate() {
    if (status.value == null) {
      Get.dialog(
          UploadDialog(
            title: "Validasi!",
            subtitle: "Silakan pilih status presensi terlebih dahulu",
            gifAssetPath: "assets/gif/upload_data_animation.gif",
          ),
          barrierDismissible: false);
      return false;
    }
    if ((status.value == StatusPresensi.ijin ||
            status.value == StatusPresensi.sakit) &&
        alasanController.text.trim().isEmpty) {
      Get.dialog(
          UploadDialog(
            title: "Validasi!",
            subtitle: "Silakan isi alasan ketidakhadiran",
            gifAssetPath: "assets/gif/upload_data_animation.gif",
          ),
          barrierDismissible: false);
      return false;
    }
    if ((status.value == StatusPresensi.ijin ||
            status.value == StatusPresensi.sakit) &&
        bukti() == null) {
      Get.dialog(
          UploadDialog(
            title: "Validasi!",
            subtitle: "Silakan upload bukti ketidakhadiran",
            gifAssetPath: "assets/gif/upload_data_animation.gif",
          ),
          barrierDismissible: false);
      return false;
    }

    return true;
  }

  void submitPresence() async {
    if (!validate()) return;

    showLoading();
    await uploadPresence();
  }

  Future<void> uploadPresence() async {
    try {
      var mahasiswaId = _box.read("mahasiswa_id");

      // Validasi waktu presensi sebelum upload
      if (presence.value.tglPresensi != null &&
          presence.value.durasiPresensi != null) {
        final isOnSchedule = await checkPresenceTime(
            presence.value.tglPresensi!, presence.value.durasiPresensi!);

        if (!isOnSchedule) {
          Get.back();
          isSnackbarOpen.value = true;
          Get.snackbar("Waktu Presensi Habis",
              "Anda tidak dapat melakukan presensi di luar jadwal yang ditentukan",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3));
          Future.delayed(
            Duration(seconds: 4),
            () => isSnackbarOpen.value = false,
          );
          return;
        }
      }

      if (status.value == StatusPresensi.hadir) {
        statusAbsen.value = 1;
      } else if (status.value == StatusPresensi.ijin) {
        statusAbsen.value = 2;
      } else if (status.value == StatusPresensi.sakit) {
        statusAbsen.value = 3;
      } else {
        statusAbsen.value = 0;
      }
      var waktuPresensi = await checkTime();

      waktuPresensi = formatWaktuPresensi(waktuPresensi);
      log.d("${statusAbsen.value}");
      log.d("$mahasiswaId");
      log.d("$waktuPresensi");
      log.d(alasanController.text);

      final alasan =
          alasanController.text.isEmpty ? null : alasanController.text.trim();

      final buktiFinal = bukti() == null ? null : bukti.value;

      log.d(bukti.value);
      log.d("Cek ext: ${buktiExtension.value}");

      final result = await presenceContentService.uploadPresence(
          mahasiswaId,
          presensisId,
          statusAbsen.value,
          waktuPresensi,
          alasan,
          buktiFinal,
          buktiExtension.value);

      if (result.status == "success") {
        Get.back();
        Get.offAllNamed("/");
        Get.dialog(
          SuccessDialog(
            title: 'Presensi berhasil diunggah!',
            subtitle: 'Data presensi berhasil ditambahkan',
            gifAssetPath: 'assets/gif/success_animation.gif',
            onDetailPressed: () => Get.toNamed("/student/notification-screen"),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.back();
        Get.dialog(FailedDialog(
            title: "Presensi gagal diunggah!",
            subtitle: "Data presensi gagal ditambahkan",
            gifAssetPath: "assets/gif/failed_animation.gif"));
      }
    } catch (e) {
      Get.back();
      log.d("Error: $e");
    }
  }

  Future<void> checkAttendanceTime() async {
    try {
      int mahasiswaId = _box.read('mahasiswa_id');
      log.d(mahasiswaId);
      log.d(presensisId);

      final result = await presenceContentService.getPresenceContent(
          mahasiswaId, presensisId.value);

      if (result.status == "success" && result.data != null) {
        final data = result.data!;
        log.d(data);

        presence.value = GetPresenceApi(
            durasiPresensi: data.durasiPresensi,
            tglPresensi: data.tglPresensi,
            namaMatkul: data.namaMatkul,
            kodeMatkul: data.kodeMatkul);

        final isOnSchedule =
            await checkPresenceTime(data.tglPresensi!, data.durasiPresensi!);
        log.d("hasil schedule: $isOnSchedule");
        if (!isOnSchedule) {
          log.d("tgl: ${data.tglPresensi}");
          log.d("durasi: ${data.durasiPresensi}");
          statusData.value = false;
          log.e(statusData.value);
        } else {
          statusData.value = true;
        }
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Error: $e");
    }
  }

  Future<bool> checkPresenceTime(
      DateTime tglPresensi, String durasiPresensi) async {
    try {
      final now = await checkTime();

      if (now.year != tglPresensi.year ||
          now.month != tglPresensi.month ||
          now.day != tglPresensi.day) {
        return false;
      }

      final times = durasiPresensi.split('-');
      if (times.length != 2) return false;

      final startTimeString = times[0].trim();
      final endTimeString = times[1].trim();

      final startParts = startTimeString.split(':');
      final endParts = endTimeString.split(':');

      log.d("startparts: $startParts");

      final startTime = DateTime(
        tglPresensi.year,
        tglPresensi.month,
        tglPresensi.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endTime = DateTime(
        tglPresensi.year,
        tglPresensi.month,
        tglPresensi.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );
      log.d("now: $now");
      log.d("startTime: $startTime");
      log.d("endTime: $endTime");

      if (now.isBefore(startTime) || now.isAfter(endTime)) {
        return false;
      }

      return true;
    } catch (e) {
      log.d("chekPresenceTime error: $e");
      return false;
    }
  }

  Future<dynamic> checkTime() async {
    var jakarta = tz.getLocation("Asia/Jakarta");
    var timeNow = tz.TZDateTime.now(jakarta);
    return timeNow;
  }

  String formatWaktuPresensi(DateTime waktu) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(waktu);
  }

  Future<void> getImageFromGallery() async {
    final XFile? image =
        await pickedImage.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      int fileSize = await file.length();

      if (fileSize > maxSizeInBytes) {
        isSnackbarOpen.value = true;
        Get.snackbar("Error", "Ukuran gambar melebihi 5MB",
            duration: Duration(seconds: 2));
        Future.delayed(
          Duration(seconds: 3),
          () => isSnackbarOpen.value = false,
        );
        return;
      }
      bukti.value = File(image.path);
      buktiExtension.value = p.extension(image.path).replaceFirst('.', '');
    }
  }

  Future<void> getImageFromCamera() async {
    try {
      final XFile? image =
          await pickedImage.pickImage(source: ImageSource.camera);
      if (image != null) {
        final file = File(image.path);
        int fileSize = await file.length();

        if (fileSize > maxSizeInBytes) {
          isSnackbarOpen.value = true;
          Get.snackbar("Error", "Ukuran gambar melebihi 5MB",
              duration: Duration(seconds: 2));
          Future.delayed(
            Duration(seconds: 3),
            () => isSnackbarOpen.value = false,
          );
          return;
        }

        bukti.value = File(image.path);
        buktiExtension.value = p.extension(image.path).replaceFirst('.', '');
      }
    } catch (e) {
      isSnackbarOpen.value = true;
      Get.snackbar("Gagal", "Kamera tidak tersedia: $e",
          duration: Duration(seconds: 2));
      Future.delayed(
        Duration(seconds: 3),
        () => isSnackbarOpen.value = false,
      );
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'docx']);

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      int fileSize = await file.length();
      final extension = result.files.single.extension?.toLowerCase();

      if (extension == null ||
          !['pdf', 'png', 'jpg', 'jpeg', 'docx'].contains(extension)) {
        isSnackbarOpen.value = true;
        Get.snackbar("Error", "Formal file tidak diizinkan",
            duration: Duration(seconds: 2));
        Future.delayed(
          Duration(seconds: 3),
          () => isSnackbarOpen.value = false,
        );
        return;
      }

      if (fileSize > maxSizeInBytes) {
        isSnackbarOpen.value = true;
        Get.snackbar("Error", "Ukuran file melebihi 5MB",
            duration: Duration(seconds: 2));
        Future.delayed(
          Duration(seconds: 3),
          () => isSnackbarOpen.value = false,
        );
        return;
      }

      bukti.value = file;
      buktiExtension.value = extension;
    }
  }

  void showFileOptions() {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Ambil Foto"),
            onTap: () async {
              Get.back();
              await getImageFromCamera();
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Pilih Gambar"),
            onTap: () async {
              Get.back();
              await getImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_file),
            title: Text("Pilih File"),
            onTap: () async {
              Get.back();
              await pickFile();
            },
          ),
        ],
      ),
    ));
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      // ignore: deprecated_member_use
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}
