import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/models/students/lecture_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/services/token_service.dart';

class LectureStudentService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}listview";
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  Future<BaseResponse<List<LectureModelApi>>> tampilZoom(String nim) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/lectureStudent?nim=$nim");
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
          return await tampilZoom(nim);
        }
      }

      return BaseResponse.fromJson(
        body,
        (dataJson) => (dataJson as List)
            .map((e) => LectureModelApi.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<LectureModelApi>> tampilZoomContent(
      int presensisId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/lectureContentStudent?presensis_id=$presensisId");
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
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }
}
