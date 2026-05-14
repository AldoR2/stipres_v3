import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/models/base_response.dart';
import 'package:stipres/services/token_service.dart';

class FaceApiService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}faceEmbedding";
  final GetStorage _box = GetStorage();
  final global = ApiConstants.globalUrl;
  final tokenService = Get.find<TokenService>();

  final Logger log = Logger();

  Future<BaseResponse> saveEmbedding(
      {required int mahasiswaId, required List<double> embedding}) async {
    try {
      final token = await _box.read("auth_token");
      log.d(token);
      log.d("Mahasiswa id : $mahasiswaId");
      log.d("embedding : $embedding");
      log.d("embedding length: ${embedding.length}");

      final url = Uri.parse("$_baseURL/store");
      log.d("URL: $url");

      final response = await http.post(url,
          body:
              jsonEncode({'mahasiswa_id': mahasiswaId, 'embedding': embedding}),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });

      final body = jsonDecode(response.body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await saveEmbedding(
              mahasiswaId: mahasiswaId, embedding: embedding);
        }
      }
      log.d("Status code: ${response.statusCode}");
      log.d("Response body: ${response.body}");

      return BaseResponse(
        status: body['status'] ?? "success",
        message: body['message'] ?? "",
      );
    } catch (e) {
      log.f("Error during save embedding: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan: $e", data: null);
    }
  }
}
