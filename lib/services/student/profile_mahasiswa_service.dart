import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/students/full_student_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/services/token_service.dart';

class ProfileMahasiswaService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}activity/viewProfile";
  final global = ApiConstants.globalUrl;
  // final FlutterSecureStorage storage = FlutterSecureStorage();
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();

  var log = Logger();

  Future<BaseResponse<FullStudentModelApi>> tampilFullProfile(
      String nim) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseURL?nim=$nim");
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
          return await tampilFullProfile(nim);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              FullStudentModelApi.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<String>> sendImage(
      var mahasiswaId, File? profilePic) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}activity/upProfile");
      final request = http.MultipartRequest('POST', url)
        ..fields['role'] = "mahasiswa"
        ..fields['mahasiswa_id'] = mahasiswaId.toString();

      request.headers.addAll({
        'Accept': 'application/json', // Header Accept
        'Authorization': 'Bearer $token', // Header Authorization
      });

      if (profilePic != null) {
        var stream = http.ByteStream(profilePic.openRead());
        var length = await profilePic.length();
        var multipartFile = http.MultipartFile("file", stream, length,
            filename: path.basename(profilePic.path));
        request.files.add(multipartFile);
        log.d(profilePic);
      }

      final response = await request.send();
      final respStr = await http.Response.fromStream(response);
      log.d(respStr.body);

      final body = jsonDecode(respStr.body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await sendImage(mahasiswaId, profilePic);
        }
      }

      return BaseResponse<String>.fromJson(body, (data) => data['foto']);
    } catch (e) {
      log.e("Error: $e");
      return BaseResponse<String>(
          status: "error", message: "Terjadi kesalahan: $e");
    }
  }
}
