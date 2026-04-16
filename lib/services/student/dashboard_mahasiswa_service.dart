import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/jadwal_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/students/student_summary_model.dart';
import 'package:stipres/services/token_service.dart';

class DashboardMahasiswaService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}listview/getLesson";
  final global = ApiConstants.globalUrl;
  // final FlutterSecureStorage storage = FlutterSecureStorage();
  final GetStorage _box = GetStorage();

  final tokenService = Get.find<TokenService>();

  var log = Logger();

  Future<BaseResponse<List<JadwalModelApi>>> tampilJadwalHariIni(
      var mahasiswaId) async {
    try {
      final token = await _box.read("auth_token");
      final mahasiswasId = mahasiswaId.toString();

      log.d(token);
      final url = Uri.parse("$_baseURL?mahasiswa_id=$mahasiswasId");
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      log.d(url);

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await tampilJadwalHariIni(mahasiswaId);
        }
      }

      return BaseResponse.fromJson(
        body,
        (dataJson) => (dataJson as List)
            .map((e) => JadwalModelApi.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<MahasiswaDashboardModel>> tampilSummary(
      String mahasiswaId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}activity/presensi-summary/$mahasiswaId");
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      log.d(url);

      final body = jsonDecode(response.body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await tampilSummary(mahasiswaId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => MahasiswaDashboardModel.fromJson(
              dataJson as Map<String, dynamic>));
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<bool> checkMahasiswaNotification(String mahasiswaId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "${global}activityLecturer/checkNotificationMahasiswa?mahasiswa_id=$mahasiswaId");
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      log.d(url);

      if (response.statusCode == 401) {
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await checkMahasiswaNotification(mahasiswaId);
        } else {
          return false;
        }
      }

      final body = jsonDecode(response.body);
      return body["hasNotification"] == true;
    } catch (e) {
      log.d("Error: $e");
      return false;
    }
  }
}
