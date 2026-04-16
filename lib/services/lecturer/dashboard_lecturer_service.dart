import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/jadwal_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/lecturers/lecturer_summary_model.dart';
import 'package:stipres/services/token_service.dart';

class DashboardLecturerService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}listview/getLessonLecturer";
  final global = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();

  var log = Logger();

  Future<BaseResponse<List<JadwalModelApi>>> tampilJadwalHariIni(
      int dosenId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseURL?dosen_id=$dosenId");
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
          return await tampilJadwalHariIni(dosenId);
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

  Future<BaseResponse<DosenDashboardModel>> tampilSummary(
      String dosenId) async {
    try {
      final token = await _box.read("auth_token");

      final url =
          Uri.parse("${global}activity/presensi-summary/dosen/$dosenId");
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
          return await tampilSummary(dosenId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              DosenDashboardModel.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<bool> checkDosenNotification(String dosenId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "${global}activityLecturer/checkNotificationDosen?dosen_id=$dosenId");
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      log.d(url);

      if (response.statusCode == 401) {
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await checkDosenNotification(dosenId);
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
