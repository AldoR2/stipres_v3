import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/basic_response.dart';

class ActivationAccountService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}auth/activationAccount";
  final GetStorage _box = GetStorage();
  final global = ApiConstants.globalUrl;

  final Logger log = Logger();

  Future<BasicResponse> sendOtpActivate(String email) async {
    try {
      log.d("sendservice");
      final response = await http.post(Uri.parse("$_baseURL/otp/send"),
          body: {'email': email}, headers: {"Accept": "application/json"});
      log.d(_baseURL);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          _box.write("email_otp", email);
          log.d(body);

          return BasicResponse(
              status: body['status'], message: body['message']);
        } else {
          return BasicResponse(
              status: body['status'], message: body['message']);
        }
      } else {
        final body = jsonDecode(response.body);
        return BasicResponse(status: body['status'], message: body['message']);
      }
    } catch (e) {
      log.e("Error during sending OTP: $e");
      throw Exception("Failed to send OTP: $e");
    }
  }

  Future<BasicResponse> checkOtp(String email, String nim, String otp) async {
    try {
      final response = await http.post(Uri.parse("$_baseURL/otp/check"),
          body: {'email': email, 'nim': nim, 'otp': otp, 'action': 'checkOTP'},
          headers: {"Accept": "application/json"});
      log.d(_baseURL);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "success") {
          _box.write("email_otp", email);
          log.d(body);
          return BasicResponse(
              status: body['status'], message: body['message']);
        } else {
          return BasicResponse(
              status: body['status'], message: body['message']);
        }
      } else {
        final body = jsonDecode(response.body);
        return BasicResponse(status: body['status'], message: body['message']);
      }
    } catch (e) {
      log.f("Error during checking OTP: $e");
    }
    return BasicResponse(
        status: "error", message: "Terjadi kesalahan saat memeriksa kode otp");
  }

  Future<BasicResponse> activateAccount(String password, String nim) async {
    try {
      final response = await http.post(Uri.parse("$_baseURL/validate"),
          body: {'password': password, 'nim': nim},
          headers: {"Accept": "application/json"});
      log.d(_baseURL);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "success") {
          log.d(body);
          return BasicResponse(
              status: body['status'], message: body['message']);
        } else {
          return BasicResponse(
              status: body['status'], message: body['message']);
        }
      } else {
        final body = jsonDecode(response.body);
        return BasicResponse(status: body['status'], message: body['message']);
      }
    } catch (e) {
      log.f("Error during activation: $e");
    }
    return BasicResponse(
        status: "error", message: "Terjadi kesalahan saat aktivasi");
  }
}
