import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/lecturers/all_schedule_model.dart';
import 'package:stipres/services/token_service.dart';

class LecturerAllSchedulesService extends GetxService {
  final String _baseUrl =
      "${ApiConstants.globalUrl}activity/AllScheduleLecturer";
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  final Logger log = Logger();

  Future<BaseResponse<List<LecturerAllScheduleModel>>> fetchSchedule(
      String dosenId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl?&dosen_id=$dosenId");
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
          return await fetchSchedule(dosenId);
        }
      }

      return BaseResponse.fromJson(
        body,
        (dataJson) => (dataJson as List)
            .map((e) =>
                LecturerAllScheduleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }
}
