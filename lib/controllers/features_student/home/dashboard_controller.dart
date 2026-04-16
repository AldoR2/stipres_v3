import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/jadwal_model.dart';
import 'package:stipres/services/student/dashboard_mahasiswa_service.dart';

class DashboardController extends GetxController {
  final storedName = ''.obs;
  final storedNim = ''.obs;
  var storedProfile = ''.obs;
  final storedKehadiran = 0.obs;
  final storedPresensi = 0.obs;
  final storedJadwal = 0.obs;
  final storedKalender = 0.obs;
  final storedPerkuliahanOnline = 0.obs;
  final url = ApiConstants.path;
  final hasNotification = false.obs;

  final _box = GetStorage();
  final statusOffline = false.obs;

  Logger log = Logger();
  var jadwalList = <JadwalModelApi>[].obs;
  var errorMessage = ''.obs;

  final DashboardMahasiswaService dashboardMahasiswaService =
      DashboardMahasiswaService();

  @override
  void onInit() async {
    super.onInit();
    loadHeader();
    final mahasiswaId = _box.read("mahasiswa_id").toString();
    await loadSummary(mahasiswaId);
    loadNotif(mahasiswaId);
  }

  Future<void> loadHeader() async {
    String? nama = _box.read("user_nama");
    String nim = _box.read("user_nim");
    String profile = _box.read("foto") ?? "";

    storedName.value = nama ?? "No name found";
    storedNim.value = nim;

    final profileUrl =
        "$url${profile}?v=${DateTime.now().millisecondsSinceEpoch}";

    storedProfile.value = profileUrl; // path relatif + base URL

    log.f("fetch header");
    log.d("Profile: ${storedProfile.value}");
    log.d("avalaible?: ${_box.read("isBiometricAvailable")}");
  }

  Future<void> loadSummary(String mahasiswaId) async {
    try {
      final result = await dashboardMahasiswaService.tampilSummary(mahasiswaId);

      if (result.status == "success" && result.data != null) {
        final summary = result.data;

        storedKehadiran.value = summary!.totalKehadiran;
        storedPresensi.value = summary.presensiBerlangsung;
        storedJadwal.value = summary.jumlahJadwalAktif;
        storedKalender.value = summary.jumlahKalenderAkademik;
        storedPerkuliahanOnline.value = summary.jumlahPresensiOnline;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<void> loadNotif(String mahasiswaId) async {
    try {
      bool hasNotif = await dashboardMahasiswaService
          .checkMahasiswaNotification(mahasiswaId);
      hasNotification.value = hasNotif;
      log.d("has ?? $hasNotif");
      log.d("has ?? ${hasNotification.value}");
    } catch (e) {
      log.f("Error: $e");
    }
  }

  String formatTanggal(String tanggal) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(tanggal);

      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      log.d("Error: $e");
      Get.snackbar("Error", "Terjadi error: $e");
      return tanggal;
    }
  }

  Future<void> fetchJadwal() async {
    var mahasiswaId = _box.read("mahasiswa_id").toString();
    log.d(mahasiswaId);
    final result =
        await dashboardMahasiswaService.tampilJadwalHariIni(mahasiswaId);
    log.d(result);

    if (result.status == "success" && result.data != null) {
      final List<JadwalModelApi> updatedList = result.data!.map((jadwal) {
        jadwal.waktu = ("${jadwal.waktu} WIB").toString();
        jadwal.durasiMatkul = ("${jadwal.durasiMatkul} Jam").toString();
        if (jadwal.lokasi == null) {
          jadwal.lokasi = "-";
          jadwal.keterangan = "Daring";
          statusOffline.value = false;
        } else {
          statusOffline.value = true;
          jadwal.keterangan = "Luring";
        }

        jadwal.tglPresensi = formatTanggal(jadwal.tglPresensi!);

        log.d("Status offline: ${statusOffline.value}");

        log.d(jadwal);
        return jadwal;
      }).toList();
      jadwalList.value = updatedList;
    } else {
      errorMessage.value = result.message;
    }
  }

  void buttonAction(JadwalModelApi jadwal) {
    if (jadwal.lokasi == "-") {
      Get.toNamed("/student/presence-content-screen",
          arguments: [jadwal.presensiId, jadwal.presensisId]);
    } else {
      Get.toNamed("/student/offline-screen");
    }
  }
}
