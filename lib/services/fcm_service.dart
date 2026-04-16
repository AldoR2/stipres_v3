import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/services/token_service.dart';

class FcmService extends GetxService {
  final String _baseUrl = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  var log = Logger();

  static Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    print("FCM Token: $token");
    return token;
  }

  Future<BasicResponse> sendFcmToken(String fcmToken) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${_baseUrl}auth/fcm-token");
      log.d(url);
      final response = await http.post(url, body: {
        'fcm_token': fcmToken,
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
          return await sendFcmToken(token);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }

  Future<BasicResponse> deleteFcmToken(String fcmToken) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("${_baseUrl}auth/fcm-token/delete");
      log.d(url);
      final response = await http.post(url, body: {
        'fcm_token': fcmToken,
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      log.d(response.statusCode);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await deleteFcmToken(token);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }
}
