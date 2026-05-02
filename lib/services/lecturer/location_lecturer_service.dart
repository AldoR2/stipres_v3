import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/location_model.dart';
import 'package:stipres/services/token_service.dart';

class LocationLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}location";
  final Logger log = Logger();
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();

  Future<BaseResponse<List<LocationModel>>> fetchLocationAvailable() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/");
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
          return await fetchLocationAvailable();
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Error: $e");
    }
  }

  Future<BaseResponse<LocationModel>> storeLocation(
      String nama, String latitude, String longitude, String radius) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/");
      final response = await http.post(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'nama': nama,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });
      log.d(url);

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await storeLocation(nama, latitude, longitude, radius);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              LocationModel.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(status: "Error", message: "Error: $e");
    }
  }
}
