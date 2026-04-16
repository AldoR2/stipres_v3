import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/constants/api.dart';

class ForgetPasswordService extends GetxService {
  final String _baseURL = "${ApiConstants.globalUrl}auth/";
  final GetStorage _box = GetStorage();
  final global = ApiConstants.globalUrl;

  var logger = Logger();

  Future<BaseResponse> sendOtpSv(String email) async {
    try {
      final response = await http.post(
          Uri.parse("${_baseURL}forgetPassword/otp/send"),
          body: {'email': email},
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          _box.write("email_otp", email);
          logger.d(body);

          return BaseResponse(status: body['status'], message: body['message']);
        } else {
          return BaseResponse(status: body['status'], message: body['message']);
        }
      }
    } catch (e) {
      logger.e("Error during sending OTP: $e");
      throw Exception("Failed to send OTP: $e");
    }

    return BaseResponse(status: "error", message: "Gagal mengirim OTP");
  }

  Future<bool> checkOtp(String email, String otp) async {
    try {
      final response = await http.post(
          Uri.parse("${_baseURL}forgetPassword/otp/check"),
          body: {'email': email, 'otp': otp},
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "success") {
          logger.d(body);
          return true;
        }
      }
    } catch (e) {
      logger.e("Error during checking OTP: $e");
    }
    return false;
  }

  Future<BasicResponse> changePasswordSv(String email, String password) async {
    try {
      final String newUrl = "changePassword";

      final response = await http.post(Uri.parse("$_baseURL$newUrl"),
          body: {'email': email, 'new_password': password},
          headers: {"Accept": "application/json"});

      logger.d(response.statusCode);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        logger.d(body);

        return BasicResponse.fromJson(body);
      }
    } catch (e) {
      logger.d("Error during change password: $e");
    }
    return BasicResponse(
        status: "error", message: "Terjadi kesalahan saat mengganti password");
  }
}
