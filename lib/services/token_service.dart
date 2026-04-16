import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:http/http.dart' as http;

class TokenService extends GetxService {
  final String global = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final FlutterSecureStorage _secure = FlutterSecureStorage();

  var logger = Logger(printer: PrettyPrinter(methodCount: 0));

  Future<bool> refreshToken() async {
    final refreshToken = await _secure.read(key: "refresh_token");
    logger.d(refreshToken);

    final url = Uri.parse("${global}auth/refresh");
    logger.d("URl token refresh: $url");

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    logger.d(response.statusCode);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final newToken = body['token'];
      final newExpires = body['expires_in'];

      await _box.write("auth_token", newToken);
      await _box.write(
        "auth_expires_in",
        (DateTime.now().millisecondsSinceEpoch + (newExpires * 1000))
            .toString(),
      );
      return true;
    } else {
      await _secure.deleteAll();
      _box.erase();
      Get.offAllNamed("/");
      return false;
    }
  }

  Future<void> prepareToken() async {
    final expiresInStr = await _box.read("auth_expires_in");
    final expiresIn = int.tryParse(expiresInStr ?? "0") ?? 0;

    if (DateTime.now().millisecondsSinceEpoch > expiresIn) {
      await refreshToken();
    }
  }
}
