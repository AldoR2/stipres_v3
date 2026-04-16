import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/models/students/get_presence_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/services/token_service.dart';

class PresenceContentService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}activity/getTransaction";
  final global = ApiConstants.globalUrl;
  final tokenService = Get.find<TokenService>();
  final GetStorage _box = GetStorage();
  var log = Logger();

  Future<BaseResponse<GetPresenceApi>> getPresenceContent(
      int mahasiswaId, dynamic presensiId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseURL?presensi_id=$presensiId&mahasiswa_id=$mahasiswaId");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      log.e(url);

      final body = jsonDecode(response.body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await getPresenceContent(mahasiswaId, presensiId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              GetPresenceApi.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.d("Error: $e");
      return BaseResponse(
          status: "error", message: "Terjadi kesalahan: $e", data: null);
    }
  }

  Future<BasicResponse> uploadPresence(
      var mahasiswaId,
      var presensiId,
      int status,
      String waktuPresensi,
      String? alasan,
      File? bukti,
      String? ext) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}activity/presenceActivity");
      log.d(url);
      log.d("Mahasiswa ID: $mahasiswaId, Presensi ID: $presensiId");

      final request = http.MultipartRequest('POST', url)
        ..fields['mahasiswa_id'] = mahasiswaId.toString()
        ..fields['presensi_id'] = presensiId.toString()
        ..fields['status'] = status.toString()
        ..fields['waktu_presensi'] = waktuPresensi;

      request.headers.addAll({
        'Accept': 'application/json', // Header Accept
        'Authorization': 'Bearer $token', // Header Authorization
      });

      if (alasan != null && alasan.isNotEmpty) {
        request.fields['alasan'] = alasan;
      }

      if (bukti != null && ext != null && ext.isNotEmpty) {
        final contentType = getContentTypeFromExtension(ext);
        var multipartFile = await http.MultipartFile.fromPath(
            'bukti', bukti.path,
            filename: path.basename(bukti.path), contentType: contentType);
        request.files.add(multipartFile);
      }

      log.d(bukti);

      final response = await request.send();

      final respStr = await http.Response.fromStream(response);
      log.d(respStr.body);

      final body = jsonDecode(respStr.body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await uploadPresence(mahasiswaId, presensiId, status,
              waktuPresensi, alasan, bukti, ext);
        }
      }

      return BasicResponse.fromJson(
        body,
      );
    } catch (e) {
      log.d("Error: $e");
      return BasicResponse(status: "error", message: "Terjadi kesalahan: $e");
    }
  }

  MediaType? getContentTypeFromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'docx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      default:
        return null;
    }
  }
}
