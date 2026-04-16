import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/students/rekap_model.dart';
import 'package:stipres/services/student/rekap_mahasiswa_service.dart';

class RekapController extends GetxController {
  final _box = GetStorage();

  Logger log = Logger();

  var rekapList = <RekapModelApi>[].obs;

  final persentase = ''.obs;

  var errorMessage = ''.obs;

  String? nim;

  final RekapMahasiswaService rekapMahasiswaService = RekapMahasiswaService();

  @override
  void onInit() {
    super.onInit();
    if (_box.read("user_nim") != null) {
      nim = _box.read('user_nim');
    } else {
      nim = Get.arguments;
    }
    fetchRekap(nim);
  }

  void fetchRekap(String? nim) async {
    try {
      log.d(nim);
      final result = await rekapMahasiswaService.tampilRekap(nim);
      log.d(result);

      if (result.status == "success" && result.data != null) {
        Map<String, RekapModelApi> groupedData = {};

        for (var rekap in result.data!) {
          String kode = rekap.kodeMatkul ?? '';

          if (!groupedData.containsKey(kode)) {
            groupedData[kode] = RekapModelApi(
                mahasiswaId: rekap.mahasiswaId,
                nim: rekap.nim,
                namaMatkul: rekap.namaMatkul,
                kodeMatkul: rekap.kodeMatkul,
                status: rekap.status,
                semester: rekap.semester);
          }

          final statusPresensi = rekap.status;

          switch (statusPresensi) {
            case 1:
              groupedData[kode]!.hadir = (groupedData[kode]!.hadir ?? 0) + 1;
              break;
            case 2:
              groupedData[kode]!.izin = (groupedData[kode]!.izin ?? 0) + 1;
              break;
            case 3:
              groupedData[kode]!.sakit = (groupedData[kode]!.sakit ?? 0) + 1;
              break;
            case 0:
            default:
              groupedData[kode]!.alpa = (groupedData[kode]!.alpa ?? 0) + 1;
              break;
          }
        }

        List<RekapModelApi> updatedList = groupedData.values.map((rekap) {
          final totalPertemuan = (rekap.hadir ?? 0) +
              (rekap.izin ?? 0) +
              (rekap.sakit ?? 0) +
              (rekap.alpa ?? 0);

          double persentase = 0;

          log.d(totalPertemuan);

          if (totalPertemuan > 0) {
            persentase = ((rekap.hadir ?? 0) / totalPertemuan) * 100;
          }

          if (persentase % 1 == 0) {
            rekap.persentase = "${persentase.toInt()}";
          } else {
            rekap.persentase = "${persentase.toStringAsFixed(1)}";
          }

          log.d(rekap.persentase);

          log.d(rekap);

          return rekap;
        }).toList();
        rekapList.assignAll(updatedList);
        log.d(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.d("Errorr: $e");
    }
  }
}
