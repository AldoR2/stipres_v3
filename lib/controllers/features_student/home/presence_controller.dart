import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/presensi_model.dart';
import 'package:stipres/services/student/presensi_mahasiswa_service.dart';

class PresenceController extends GetxController {
  final _box = GetStorage();
  Logger log = Logger();

  final errorMessage = ''.obs;

  var presenceList = <PresensiModelApi>[].obs;
  final PresensiMahasiswaService presensiMahasiswaService =
      PresensiMahasiswaService();

  @override
  void onReady() {
    super.onReady();
    fetchPresence();
  }

  void fetchPresence() async {
    try {
      String mahasiswaId = _box.read("mahasiswa_id").toString();
      log.d(mahasiswaId);
      final result = await presensiMahasiswaService.tampilPresensi(mahasiswaId);
      log.d(result.data);

      if (result.status == "success" && result.data != null) {
        final List<PresensiModelApi> updatedList = result.data!.map((presence) {
          if (presence.namaRuangan == null) {
            presence.namaRuangan = "Online";
          } else {
            presence.namaRuangan = presence.namaRuangan;
          }

          log.d(presence.presensiId);

          return presence;
        }).toList();
        presenceList.assignAll(updatedList);
        log.d(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Error: $e");
    }
  }
}
