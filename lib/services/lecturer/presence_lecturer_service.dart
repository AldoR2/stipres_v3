import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/models/lecturers/check_presence_model.dart';
import 'package:stipres/models/lecturers/presence_model.dart';
import 'package:stipres/services/token_service.dart';

class PresenceLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}listview";
  final global = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  Future<BaseResponse<List<PresensiDosenModel>>> fetchPresence(
      String dosenId) async {
    try {
      final token = await _box.read("auth_token");
      final url = Uri.parse("$_baseUrl/getPresenceLecturer?dosen_id=$dosenId");
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
          return await fetchPresence(dosenId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map(
                  (e) => PresensiDosenModel.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BasicResponse> updatePresence(
      String dosenId, String presensisId, String jamAwal, String jamAkhir) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/updatePresence");
      final response = await http.post(url, body: {
        'dosen_id': dosenId,
        'presensis_id': presensisId,
        'jam_awal': jamAwal,
        'jam_akhir': jamAkhir
      }, headers: {
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
          return await updatePresence(dosenId, presensisId, jamAwal, jamAkhir);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }

  Future<BaseResponse<CheckPresenceModel>> checkPresence(String dosenId,
      String presensisId, String jamAwal, String jamAkhir) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}activityLecturer/presence/check-edit");
      log.d(url);
      final response = await http.post(url, body: {
        "jam_awal": jamAwal,
        "dosen_id": dosenId,
        "jam_akhir": jamAkhir,
        "presensis_id": presensisId
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await checkPresence(dosenId, presensisId, jamAwal, jamAkhir);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              CheckPresenceModel.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BasicResponse> deletePresence(String presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/deletePresence");
      final response = await http.post(url, body: {
        'presensis_id': presensisId,
      }, headers: {
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
          return await deletePresence(presensisId);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }
}
