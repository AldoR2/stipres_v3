import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stipres/constants/api.dart';
import 'package:stipres/models/base_response.dart';
import 'package:stipres/models/basic_response.dart';
import 'package:stipres/models/lecturers/active_school_year_model.dart';
import 'package:stipres/models/lecturers/check_presence_model.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/models/lecturers/disabled_pertemuan_model.dart';
import 'package:stipres/models/lecturers/matkul_model.dart';
import 'package:stipres/models/lecturers/presence_id_model.dart';
import 'package:stipres/models/lecturers/presence_request_model.dart';
import 'package:stipres/services/token_service.dart';

class AddPresenceLecturerService extends GetxService {
  final String _baseUrl = "${ApiConstants.globalUrl}activityLecturer";
  final global = ApiConstants.globalUrl;
  final GetStorage _box = GetStorage();
  final tokenService = Get.find<TokenService>();
  final Logger log = Logger();

  Future<BaseResponse<List<MatkulModel>>> fetchMatkul(
      String prodiId, String semester) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/presence/matkuls?prodi_id=$prodiId&semester=$semester");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await fetchMatkul(prodiId, semester);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => MatkulModel.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<List<DataProdi>>> fetchProdi() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/presence/majors");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await fetchProdi();
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) => DataProdi.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<TahunAjaranAktif>> fetchTahunAjaran() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/presence/tahunAjarans");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await fetchTahunAjaran();
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              TahunAjaranAktif.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<List<DisabledPertemuansModel>>> fetchDisabledPertemuans(
      int prodiId, int semester, int matkulId, int tahunAjaranId) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse(
          "$_baseUrl/presence/disabledPertemuans?prodi_id=$prodiId&semester=$semester&matkul_id=$matkulId&tahun_ajaran_id=$tahunAjaranId");
      log.d(url);

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await fetchDisabledPertemuans(
              prodiId, semester, matkulId, tahunAjaranId);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) => (dataJson as List)
              .map((e) =>
                  DisabledPertemuansModel.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<CheckPresenceModel>> checkPresence(
      String dosenId,
      int prodiId,
      int semester,
      String jamAwal,
      String jamAkhir,
      String tglPresensi,
      int pertemuan,
      String status,
      int matkulId,
      int tahunAjaran
      ) async {
    try {
      final token = await _box.read("auth_token");
      log.d("Param : $prodiId");
      log.d("Param : $semester");
      log.d("Param : $jamAwal");
      log.d("Param : $jamAkhir");
      log.d("Param : $tglPresensi");
      log.d("Param : $pertemuan");
      log.d("Param : $status");
      log.d("Param : $matkulId");
      log.d("Param : $tahunAjaran");
      final url = Uri.parse("$_baseUrl/presence/check-upload");
      log.d(url);
      final response = await http.post(url, body: {
        'dosen_id': dosenId,
        "jam_awal": jamAwal,
        "jam_akhir": jamAkhir,
        "tgl_presensi": tglPresensi,
        "prodi_id": prodiId.toString(),
        "semester": semester.toString(),
        "pertemuan_ke": pertemuan.toString(),
        "status": status.toLowerCase(),
        "matkul_id": matkulId.toString(),
        "tahun_ajaran_id": tahunAjaran.toString()
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
          return await checkPresence(dosenId, prodiId, semester, jamAwal,
              jamAkhir, tglPresensi, pertemuan, status, matkulId, tahunAjaran);
        }
      }

      return BaseResponse.fromJson(
          body,
          (dataJson) =>
              CheckPresenceModel.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BaseResponse<PresensiId>> getPresensiId() async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/presence/lastIncrement");
      log.d(url);
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await getPresensiId();
        }
      }

      return BaseResponse.fromJson(body,
          (dataJson) => PresensiId.fromJson(dataJson as Map<String, dynamic>));
    } catch (e) {
      log.f("Error: $e");
      return BaseResponse(
          status: "Error", message: "Terjadi kesalahan $e", data: null);
    }
  }

  Future<BasicResponse> uploadPresensi(PresenceRequest presensiRequest) async {
    try {
      final token = await _box.read("auth_token");

      final url = Uri.parse("$_baseUrl/presence/uploadPresence");
      log.d(url);
      final response = await http.post(url,
          body: presensiRequest.toJson(),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      final body = jsonDecode(response.body);
      log.d(body);

      if (response.statusCode == 401) {
        log.f("Response 401");
        final refreshSuccess = await tokenService.refreshToken();
        if (refreshSuccess) {
          return await uploadPresensi(presensiRequest);
        }
      }

      return BasicResponse.fromJson(body);
    } catch (e) {
      log.f("Error: $e");
      return BasicResponse(status: "Error", message: "Terjadi kesalahan $e");
    }
  }
}
