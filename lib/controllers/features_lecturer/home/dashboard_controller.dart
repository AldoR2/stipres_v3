import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/jadwal_model.dart';
import 'package:stipres/services/lecturer/dashboard_lecturer_service.dart';

class DashboardController extends GetxController {
  final storedName = ''.obs;
  final storedNip = ''.obs;
  var storedProfile = ''.obs;
  final storedKehadiran = 0.obs;
  final storedPresensi = 0.obs;
  final storedJadwal = 0.obs;
  final storedKalender = 0.obs;
  final storedPerkuliahanOnline = 0.obs;
  final _box = GetStorage();
  final hasNotification = false.obs;

  final statusOffline = false.obs;
  Logger log = Logger();
  var jadwalList = <JadwalModelApi>[].obs;
  var errorMessage = ''.obs;

  final url = ApiConstants.path;

  final DashboardLecturerService dashboardLecturerService =
      DashboardLecturerService();

  @override
  void onInit() {
    super.onInit();
    loadHeader();
    final dosenId = _box.read("dosen_id").toString();
    loadSummary(dosenId);
    loadNotif(dosenId);
  }

  Future<void> loadHeader() async {
    String? nama = _box.read("user_nama");
    String? nip = _box.read("user_nip");
    String profile = _box.read("foto") ?? "";

    storedName.value = nama ?? "No name found";
    storedNip.value = nip ?? "No name found";

    final profileUrl =
        "$url${profile}?v=${DateTime.now().millisecondsSinceEpoch}";

    storedProfile.value = profileUrl; // path relatif + base URL

    log.f("fetch header");
    log.d("Profile: ${storedProfile.value}");
  }

  Future<void> loadSummary(String dosenId) async {
    try {
      final result = await dashboardLecturerService.tampilSummary(dosenId);

      if (result.status == "success" && result.data != null) {
        final summary = result.data;

        storedKehadiran.value = summary!.jumlahMahasiswa;
        storedPresensi.value = summary.presensiHariIni;
        storedJadwal.value = summary.jumlahJadwalAktif;
        storedKalender.value = summary.jumlahKalenderAkademik;
        storedPerkuliahanOnline.value = summary.perkuliahanOnlineHariIni;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  Future<void> loadNotif(String dosenId) async {
    try {
      bool hasNotif =
          await dashboardLecturerService.checkDosenNotification(dosenId);
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

  Future<void> fetchSchedule() async {
    try {
      int dosenId = _box.read("dosen_id");
      log.d(dosenId);

      final result =
          await dashboardLecturerService.tampilJadwalHariIni(dosenId);
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

          log.d(jadwal);
          return jadwal;
        }).toList();
        jadwalList.value = updatedList;
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.e("Erroreee: $e");
    }
  }

  void buttonAction(JadwalModelApi jadwal) {
    if (jadwal.lokasi == '-') {
      Get.toNamed("/lecturer/presence-detail-screen",
          arguments: jadwal.presensisId);
    } else {
      Get.toNamed("/lecturer/offline-screen");
    }
  }
}
