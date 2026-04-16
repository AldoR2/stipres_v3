import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/lecturers/detail_student_presence_model.dart';
import 'package:stipres/models/lecturers/list_detail_biodata.model.dart';
import 'package:stipres/models/lecturers/list_detail_presence_model.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/lecturer/presence_detail_lecturer_service.dart';

class PresenceDetailController extends GetxController {
  final errorMessage = ''.obs;
  final storedProdi = ''.obs;
  final storedMatkul = ''.obs;
  int? presensisId;
  final storedDurasiPresensi = ''.obs;
  final isButtonEnabled = true.obs;

  Logger log = Logger();
  final url = ApiConstants.path;

  var studentList = <ListDetailPresensi>[].obs;
  Rxn<ListDetailBiodata> biodata = Rxn<ListDetailBiodata>();
  Rxn<DetailMahasiswaPresensi> detail = Rxn<DetailMahasiswaPresensi>();
  final PresenceDetailLecturerService presenceDetailLecturerService =
      PresenceDetailLecturerService();

  @override
  void onInit() {
    super.onInit();
    presensisId = Get.arguments;
    fetchCourseDetail(presensisId.toString());
    fetchListStudent(presensisId.toString());
  }

  void fetchCourseDetail(String presensisId) async {
    try {
      final result =
          await presenceDetailLecturerService.fetchHeader(presensisId);

      if (result.status == "success") {
        final header = result.data!;
        storedMatkul.value = header.namaMatkul;
        storedProdi.value = header.namaProdi;
        storedDurasiPresensi.value = "${header.durasiPresensi} WIB";
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  void fetchListStudent(String presensisId) async {
    try {
      final result =
          await presenceDetailLecturerService.fetchStudent(presensisId);

      if (result.status == "success" && result.data != null) {
        final List<ListDetailPresensi> updatedList =
            result.data!.map((student) {
          int status = student.status!;
          switch (status) {
            case 1:
              (student.keterangan = "hadir");
              break;
            case 2:
              (student.keterangan = "izin");
              break;
            case 3:
              (student.keterangan = "sakit");
              break;
            default:
              (student.keterangan = "alpa");
              break;
          }
          return student;
        }).toList();
        studentList.assignAll(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<void> fetchBiodata(String nim) async {
    try {
      showLoading();
      biodata.value = null;
      final result = await presenceDetailLecturerService.fetchBiodata(nim);

      if (result.status == "success" && result.data != null) {
        if (result.data!.foto != null) {
          result.data!.foto = "${ApiConstants.path}${result.data!.foto}";
        }
        Get.back();
        biodata.value = result.data;
      } else {
        Get.back();
        errorMessage.value = result.message;
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
    }
  }

  Future<void> fetchDetailMahasiswa(String nim) async {
    try {
      showLoading();
      detail.value = null;
      final result = await presenceDetailLecturerService.fetchDetailStudent(
          nim, presensisId.toString());

      if (result.status == "success" && result.data != null) {
        final data = result.data;

        int status = data!.status!;
        switch (status) {
          case 1:
            (data.keterangan = "Hadir");
            break;
          case 2:
            (data.keterangan = "Izin");
            break;
          case 3:
            (data.keterangan = "Sakit");
            break;
          default:
            (data.keterangan = "Alpa");
            break;
        }

        if (data.waktuPresensi != null) {
          data.waktu = "${DateFormat.Hm().format(data.waktuPresensi!)} WIB";
        } else {
          data.waktu = "-";
        }

        detail.value = result.data;
        Get.back();
      } else {
        Get.back();
        errorMessage.value = result.message;
      }
    } catch (e) {
      Get.back();
      log.f("Error: $e");
    }
  }

  void openBukti(String buktiPath) async {
    log.d(buktiPath);
    final ext = buktiPath.toLowerCase();
    if (ext.endsWith('.png') || ext.endsWith('.jpg') || ext.endsWith('.jpeg')) {
      final buktiUrl = "${ApiConstants.path}$buktiPath";
      openBuktiByImage(buktiUrl);
    } else if (ext.endsWith('.pdf')) {
      final jenis = "pdf";
      final buktiUrl = "${ApiConstants.path}$buktiPath";
      log.d("BuktiPath $buktiUrl");
      openBuktiFile(buktiUrl, jenis);
    } else if (ext.endsWith('.docx')) {
      final jenis = "docx";
      final buktiUrl = "${ApiConstants.path}$buktiPath";
      log.d("BuktiPath $buktiUrl");
      openBuktiFile(buktiUrl, jenis);
    }
  }

  void openBuktiByImage(String buktiUrl) async {
    try {
      log.d("open bukti image");
      showLoading();

      final fileName = Uri.parse(buktiUrl).pathSegments.last;
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/$fileName";

      final file = File(filePath);

      if (!await file.exists()) {
        final response = await http.get(Uri.parse(buktiUrl));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          Get.back();
          isButtonEnabled.value = false;
          Get.snackbar("Gagal", "Tidak bisa mengunduh gambar",
              duration: Duration(seconds: 1));
          Future.delayed(
            Duration(seconds: 2),
            () => isButtonEnabled.value = true,
          );
          return;
        }
      }

      Get.back();

      // ✅ Tampilkan gambar dalam dialog transparan fullscreen
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              // Image di tengah layar (tanpa rounded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Image.file(
                    file,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Tombol close
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      log.f("Error buka gambar: $e");
      Get.back();
      isButtonEnabled.value = false;
      Get.snackbar("Gagal", "Terjadi kesalahan $e",
          duration: Duration(seconds: 1));
      Future.delayed(
        Duration(seconds: 2),
        () => isButtonEnabled.value = true,
      );
    }
  }

  void openBuktiFile(String buktiUrl, String jenis) async {
    try {
      log.d("open bukti");
      showLoading();

      final fileName = Uri.parse(buktiUrl).pathSegments.last;
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/$fileName";

      final file = File(filePath);

      if (!await file.exists()) {
        final response = await http.get(Uri.parse(buktiUrl));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          Get.back();
          isButtonEnabled.value = false;
          Get.snackbar("Gagal", "Tidak bisa mengunduh file",
              duration: Duration(seconds: 1));
          Future.delayed(
            Duration(seconds: 2),
            () => isButtonEnabled.value = true,
          );
          return;
        }
      }
      Get.back();
      await OpenFilex.open(file.path, type: getMimeType(jenis));
    } catch (e) {
      log.f("Error: $e");
      Get.back();
      isButtonEnabled.value = false;
      Get.snackbar("Gagal", "Terjadi kesalahan $e",
          duration: Duration(seconds: 1));
      Future.delayed(
        Duration(seconds: 2),
        () => isButtonEnabled.value = true,
      );
    }
  }

  String getMimeType(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
      case 'docs':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return '*/*'; // fallback
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
