import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/lecturers/detail_student_presence_model.dart';
import 'package:stipres/models/lecturers/header_detail_presence_model.dart';
import 'package:stipres/models/lecturers/list_detail_biodata.model.dart';
import 'package:stipres/models/lecturers/list_detail_presence_model.dart';
import 'package:stipres/services/token_service.dart';

class PresenceDetailLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}activityLecturer";
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  Future<BaseResponse<HeaderDetailPresensi>> fetchHeader(
      String presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url =
          Uri.parse("$_baseUrl/presence/header?presensis_id=$presensisId");
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
          return await fetchHeader(presensisId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              HeaderDetailPresensi.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<List<ListDetailPresensi>>> fetchStudent(
      String presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url =
          Uri.parse("$_baseUrl/presence/detail?presensis_id=$presensisId");
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
          return await fetchStudent(presensisId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map(
                  (e) => ListDetailPresensi.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<ListDetailBiodata>> fetchBiodata(String nim) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/student/information?nim=$nim");
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
          return await fetchBiodata(nim);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              ListDetailBiodata.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }

  Future<BaseResponse<DetailMahasiswaPresensi>> fetchDetailStudent(
      String nim, String presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/student/detail?nim=$nim&presensis_id=$presensisId");
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
          return await fetchDetailStudent(nim, presensisId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => DetailMahasiswaPresensi.fromJson(
              dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }
}
