import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/services/face_recognition/face_api_service.dart';

class RegisterSettingFaceController extends GetxController {
  final FaceApiService _faceApiService = FaceApiService();

  final RxInt mahasiswaId = 0.obs;
  final GetStorage _box = GetStorage();
  final Logger log = Logger();

  final RxBool isAvailable = false.obs;

  @override
  void onInit() async {
    super.onInit();
    mahasiswaId.value = _box.read("mahasiswa_id");

    await fetchEmbedding();
  }

  Future<void> fetchEmbedding() async {
    try {
      final result =
          await _faceApiService.getEmbedding(mahasiswaId: mahasiswaId.value);

      if (result.status == "success") {
        isAvailable.value = true;
      } else {
        isAvailable.value = false;
      }
    } catch (e) {
      log.e("Error: $e");
    }
  }
}
