import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class BiometricController extends GetxController {
  final GetStorage _box = GetStorage();
  final isBiometricEnabled = false.obs;
  final Logger log = Logger();

  @override
  void onInit() {
    super.onInit();
    isBiometricEnabled.value = _box.read("isBiometricEnabled") ?? true;
  }

  void toggleBiometric(bool value) {
    isBiometricEnabled.value = value;
    _box.write('isBiometricEnabled', value);
    log.d(isBiometricEnabled.value);
  }
}
