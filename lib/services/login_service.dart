import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/dosen_model.dart';
import 'package:stipres/models/mahasiswa_model.dart';
import 'package:stipres/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/services/fcm_service.dart';
import 'package:stipres/services/token_service.dart';

class LoginService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}auth/login";
  final String global = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  final FlutterSecureStorage _secure = FlutterSecureStorage();
  final FcmService fcmService = FcmService();
  final Logger log = Logger();

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  Future<Mahasiswa> loginMahasiswa(String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseURL),
        body: {'nim': nim, 'password': password, 'role': "mahasiswa"},
      );
      logger.d(_baseURL);

      logger.d("Response status: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final token = body['token'];
          final tokenType = body['token_type'];
          final expiresIn = body['expires_in'];
          final refreshToken = body['refresh_token'];

          await _box.write("auth_token", token);
          await _box.write("auth_token_type", tokenType);
          await _secure.write(key: "refresh_token", value: refreshToken);
          final expirationTime =
              DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
          await _box.write("auth_expires_in", expirationTime.toString());

          logger.d("Token: $token");
          logger.d("Refresh Token: $refreshToken");
          logger.d("Token Type: $tokenType");
          logger.d("Expires In: $expiresIn");

          final data = body['data'];
          logger.d(data);

          _box.write("user_nim", data['nim']);
          _box.write("mahasiswa_id", data['mahasiswa_id']);
          _box.write("user_nama", data['nama']);
          _box.write("user_email", data['email']);
          _box.write("id_prodi", data['prodi_id']);
          _box.write("nama_prodi", data['nama_prodi']);
          _box.write("semester", data['semester']);
          _box.write("foto", data['foto']);
          _box.write("role", "mahasiswa");

          await _secure.write(key: "role", value: "mahasiswa");
          await _secure.write(
              key: "mahasiswa_id", value: data['mahasiswa_id'].toString());

          log.f(
              "Check mahasiswa idddddddd: ${data['mahasiswa_id'].toString()}");

          final tokenfcm = await FcmService.getToken();
          log.d(tokenfcm);
          await fcmService.sendFcmToken(tokenfcm!);

          return Mahasiswa.fromJson({
            ...data,
            'status': body['status'],
            'message': body['message'],
          });
        } else {
          return Mahasiswa(
            nim: '',
            nama: '',
            email: '',
            idProdi: 0,
            semester: 0,
            status: body['status'],
            message: body['message'],
          );
        }
      } else {
        final body = jsonDecode(response.body);

        return Mahasiswa(
          nim: '',
          nama: '',
          email: '',
          idProdi: 0,
          semester: 0,
          status: body['status'],
          message: body['message'],
        );
      }
    } catch (e) {
      logger.e("Error during login: $e");
      return Mahasiswa(
        nim: '',
        nama: '',
        email: '',
        idProdi: 0,
        semester: 0,
        status: "error",
        message: "Terjadi kesalahan $e",
      );
    }
  }

  Future<Dosen> loginDosen(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(_baseURL),
          body: {'email': email, 'password': password, 'role': 'dosen'});

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final token = body['token'];
          final tokenType = body['token_type'];
          final expiresIn = body['expires_in'];
          final refreshToken = body['refresh_token'];

          await _box.write("auth_token", token);
          await _box.write("auth_token_type", tokenType);
          await _secure.write(key: "refresh_token", value: refreshToken);
          final expirationTime =
              DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
          await _box.write("auth_expires_in", expirationTime.toString());

          logger.d("Token: $token");
          logger.d("Refresh Token: $refreshToken");
          logger.d("Token Type: $tokenType");
          logger.d("Expires In: $expiresIn");

          final data = body['data'];

          _box.write("user_nip", data['nip']);
          _box.write("dosen_id", data['dosen_id']);
          _box.write("user_nama", data['nama']);
          _box.write("user_email", data['email']);
          _box.write("foto", data['foto']);
          _box.write("role", 'dosen');

          await _secure.write(key: "role", value: "dosen");
          await _secure.write(
              key: "dosen_id", value: data['dosen_id'].toString());

          final tokenfcm = await FcmService.getToken();
          log.d(tokenfcm);
          await fcmService.sendFcmToken(tokenfcm!);

          logger.d(body);

          return Dosen.fromJson({
            ...data,
            'status': body['status'],
            'message': body['message'],
          });
        } else {
          return Dosen(
            nip: '',
            nama: '',
            email: '',
            status: body['status'],
            message: body['message'],
          );
        }
      } else {
        final body = jsonDecode(response.body);

        return Dosen(
          nip: '',
          nama: '',
          email: '',
          status: body['status'],
          message: body['message'],
        );
      }
    } catch (e) {
      logger.e('Error during login: $e');
      return Dosen(
        nip: '',
        nama: '',
        email: '',
        status: "error",
        message: "Gagal terjadi kesalahan $e",
      );
    }
  }

  Future<BaseResponse<Dosen>> loginBiometricDosen(
      String role, String id) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}auth/loginByBiometric");
      log.d(url);

      final response = await http.post(url, body: {
        'role': role,
        'dosen_id': id
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await loginBiometricDosen(role, id);
        }
      }

      final data = body['data'];

      _box.write("user_nip", data['nip']);
      _box.write("dosen_id", data['dosen_id']);
      _box.write("user_nama", data['nama']);
      _box.write("user_email", data['email']);
      _box.write("foto", data['foto']);
      _box.write("role", 'dosen');

      final tokenfcm = await FcmService.getToken();
      log.d(tokenfcm);
      await fcmService.sendFcmToken(tokenfcm!);

      return BaseResponse.fromJson(
          body, (dataJson) => Dosen.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<Mahasiswa>> loginBiometricMahasiswa(
      String role, String id) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${global}auth/loginByBiometric");
      log.d(url);

      final response = await http.post(url, body: {
        'role': role,
        'mahasiswa_id': id
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await loginBiometricMahasiswa(role, id);
        }
      }

      final data = body['data'];

      log.d("data 1: ${data['nim']}");
      log.d("data 1: ${data['mahasiswa_id']}");
      log.d("data 1: ${data['nama']}");
      log.d("data 1: ${data['email']}");
      log.d("data 1: ${data['prodi_id']}");
      log.d("data 1: ${data['nama_prodi']}");
      log.d("data 1: ${data['semester']}");

      _box.write("user_nim", data['nim']);
      _box.write("mahasiswa_id", data['mahasiswa_id']);
      _box.write("user_nama", data['nama']);
      _box.write("user_email", data['email']);
      _box.write("id_prodi", data['prodi_id']);
      _box.write("nama_prodi", data['nama_prodi']);
      _box.write("semester", data['semester']);
      _box.write("foto", data['foto']);
      _box.write("role", "mahasiswa");

      final tokenfcm = await FcmService.getToken();
      log.d(tokenfcm);
      await fcmService.sendFcmToken(tokenfcm!);

      return BaseResponse.fromJson(body,
          (dataJson) => Mahasiswa.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }
}
