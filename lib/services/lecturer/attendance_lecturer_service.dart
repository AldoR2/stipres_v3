import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/models/lecturers/attendance_model.dart';
import 'package:stipres/services/token_service.dart';

class AttendanceLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}activityLecturer";
  final String globalUrl = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  Future<BaseResponse<List<DataProdi>>> fetchDataProdi() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/getMajor");
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
          return await fetchDataProdi();
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => DataProdi.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Error: $e");
    }
  }

  Future<BaseResponse<List<DataMahasiswa>>> fetchMahasiswa(
      String semester, String prodiId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/getStudent?semester=$semester&prodi_id=$prodiId");
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
          return await fetchMahasiswa(semester, prodiId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => DataMahasiswa.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Error: $e");
    }
  }
}
