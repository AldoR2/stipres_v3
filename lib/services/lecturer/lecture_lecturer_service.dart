import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/models/students/lecture_model.dart';
import 'package:stipres/services/token_service.dart';

class LectureLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}listview";
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  Future<BaseResponse<List<LectureModelApi>>> tampilZoom(String dosenId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/lectureLecturer?dosen_id=$dosenId");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await tampilZoom(dosenId);
        }
      }

      // Cek null atau kunci yang tidak valid
      if (body == null || body['data'] == null) {
        return BaseResponse(
            status: "error", message: "Data tidak valid", data: null);
      }

      try {
        return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => LectureModelApi.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } catch (parseError) {
        log.d("Error parsing data: $parseError");
        return BaseResponse(
            status: "error",
            message: "Gagal memproses data: $parseError",
            data: null);
      }
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<LectureModelApi>> tampilZoomContent(
      String presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/lectureContentLecturer?presensis_id=$presensisId");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await tampilZoomContent(presensisId);
        }
      }

      return BaseResponse.fromJson(
        body,
        (dataJson) =>
            LectureModelApi.fromJson(dataJson as Map<String, dynamic>),
      );
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BasicResponse> updateLecture(
      String presensisId, String linkZoom) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/updateLecture");
      final response = await http.post(url, body: {
        'presensis_id': presensisId,
        'link_zoom': linkZoom,
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      log.d(url);
      log.d(presensisId);
      log.d(linkZoom);

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await updateLecture(presensisId, linkZoom);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }
}
