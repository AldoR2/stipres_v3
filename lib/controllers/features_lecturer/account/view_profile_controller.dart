import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/controllers/features_lecturer/account/profile_controller.dart';
import 'package:stipres/controllers/features_lecturer/home/dashboard_controller.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/lecturer/profile_lecturer_service.dart';

class ViewProfileController extends GetxController {
  final storedFullName = ''.obs;
  final storedNip = ''.obs;
  final storedEmail = ''.obs;
  final storedJenisKelamin = ''.obs;
  final storedAgama = ''.obs;
  final storedTempatTglLahir = ''.obs;
  final storedAlamat = ''.obs;
  final storedProdi = ''.obs;
  final storedNoTelp = ''.obs;
  static const int maxSizeInBytes = 2 * 1024 * 1024;

  final _box = GetStorage();
  final log = Logger();
  final ImagePicker pickedImage = ImagePicker();
  final profilePic = Rxn<File>();
  var storedProfiles = ''.obs;
  final url = ApiConstants.path;

  final conDashboard = Get.find<DashboardController>();
  final conProfile = Get.find<ProfileController>();

  final ProfileLecturerService profileLecturerService =
      ProfileLecturerService();

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadHeader();
  }

  Future<void> loadHeader() async {
    String profile = _box.read('foto') ?? '';
    final profileUrl =
        "$url${profile}?v=${DateTime.now().millisecondsSinceEpoch}";
    storedProfiles.value = profileUrl;
    log.e("Profile: ${storedProfiles.value}");
  }

  void loadData() async {
    String nip = _box.read("user_nip");

    final result = await profileLecturerService.tampilFullProfile(nip);

    if (result.status == "success" && result.data != null) {
      final profile = result.data!;
      log.d(profile.agama);

      if (profile.jenisKelamin == "L") {
        storedJenisKelamin.value = "Laki-laki";
      } else {
        storedJenisKelamin.value = "Perempuan";
      }

      storedFullName.value = profile.nama;
      storedNip.value = profile.nip;
      storedEmail.value = profile.email;
      storedAgama.value = profile.agama;
      storedTempatTglLahir.value =
          "${profile.tempatLahir}, ${formatTanggal(profile.tglLahir)}";
      storedAlamat.value = profile.alamat;
      storedProdi.value = profile.namaProdi;
      storedNoTelp.value = profile.noTelp;
    }
  }

  String numberToBahasa(int number) {
    List<String> angka = [
      "",
      "Satu",
      "Dua",
      "Tiga",
      "Empat",
      "Lima",
      "Enam",
      "Tujuh",
      "Delapan",
      "Sembilan",
    ];

    if (number < 10) {
      return angka[number];
    } else if (number < 20) {
      return "${angka[number - 10]} Belas";
    } else {
      return number.toString();
    }
  }

  String formatTanggal(String tanggal) {
    final bulan = {
      '01': 'Januari',
      '02': 'Februari',
      '03': 'Maret',
      '04': 'April',
      '05': 'Mei',
      '06': 'Juni',
      '07': 'Juli',
      '08': 'Agustus',
      '09': 'September',
      '10': 'Oktober',
      '11': 'November',
      '12': 'Desember',
    };

    final parts = tanggal.split('-');
    if (parts.length != 3) return tanggal;

    final year = parts[0];
    final month = bulan[parts[1]] ?? parts[1];
    final day = parts[2];

    return "$day $month $year";
  }

  Future<void> getImageFromGallery() async {
    final XFile? image =
        await pickedImage.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final cropped = await cropImage(file);
      if (cropped == null) return;
      final compressed = await compressImage(cropped);

      int fileSize = await compressed.length();
      if (fileSize > maxSizeInBytes) {
        Get.snackbar("Error", "Ukuran gambar melebihi 2MB");
        return;
      }

      profilePic.value = compressed;
      uploadProfilePic(compressed);
    }
  }

  Future<void> getImageFromCamera() async {
    try {
      final XFile? image =
          await pickedImage.pickImage(source: ImageSource.camera);
      if (image != null) {
        final file = File(image.path);
        final cropped = await cropImage(file);
        if (cropped == null) return;
        final compressed = await compressImage(cropped);

        int fileSize = await compressed.length();
        if (fileSize > maxSizeInBytes) {
          Get.snackbar("Error", "Ukuran gambar melebihi 2MB");
          return;
        }

        profilePic.value = compressed;
        uploadProfilePic(compressed);
      }
    } catch (e) {
      Get.snackbar("Gagal", "Kamera tidak tersedia: $e");
    }
  }

  Future<File?> cropImage(File file) async {
    final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Pangkas Gambar",
              hideBottomControls: true,
              lockAspectRatio: true),
          IOSUiSettings(aspectRatioLockEnabled: true)
        ]);
    return cropped != null ? File(cropped.path) : null;
  }

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, 'temp.jpg');

    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70, format: CompressFormat.jpeg);

    if (compressedFile == null) {
      throw Exception("Gagal mengompresi gambar");
    }
    return File(compressedFile.path);
  }

  Future<void> uploadProfilePic(File? profilePicture) async {
    try {
      int dosenId = _box.read("dosen_id");
      showLoading();
      final result =
          await profileLecturerService.sendImage(dosenId, profilePicture);
      if (result.status == "success" && result.data != null) {
        String? foto = result.data;
        _box.write('foto', foto);
        log.f(foto);

        await conDashboard.loadHeader();
        await conProfile.loadHeader();
        await loadHeader();
        Get.back();
        Get.snackbar("Berhasil", result.message,
            duration: Duration(seconds: 1));
      } else {
        Get.back();
        Get.snackbar("Error", result.message);
      }
    } catch (e) {
      Get.back();
      log.e("Error: $e");
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
        ],
      ),
    ));
  }

  void showLoading() {
    Get.dialog(
      const LoadingPopup(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}
