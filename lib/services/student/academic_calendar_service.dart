import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/calendar_model.dart';
import 'package:stipres/services/token_service.dart';

class AcademicCalendarService extends GetxService {
  final String _baseURL =
      "${ApiConstants.globalUrl}activity/getAcademicCalendar";
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  final global = ApiConstants.globalUrl;
  final Logger log = Logger();

  Future<BaseResponse<List<EventCalendar>>> fetchCalendar() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(_baseURL);
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
          return await fetchCalendar();
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => EventCalendar.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }
}
