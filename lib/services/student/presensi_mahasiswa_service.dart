import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/models/students/presensi_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/services/token_service.dart';

class PresensiMahasiswaService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}listview/getPresence";
  final tokenService = Get.find<TokenService>();
  final GetStorage _box = GetStorage();
  var log = Logger();

  Future<BaseResponse<List<PresensiModelApi>>> tampilPresensi(
      String mahasiswaId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl?mahasiswa_id=$mahasiswaId");
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
          return await tampilPresensi(mahasiswaId);
        }
      }

      return BaseResponse.fromJson(
        body,
        (dataJson) => (dataJson as List)
            .map((e) => PresensiModelApi.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }
}
