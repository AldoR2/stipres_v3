import 'package:get_storage/get_storage.dart';
import 'package:stipres/services/biometric_auth_service.dart';
import 'package:stipres/services/login_service.dart';

class BiometricLoginService {
  final _box = GetStorage();
  final BiometricAuthService biometricService;
  final LoginService loginService;

  BiometricLoginService({
    required this.biometricService,
    required this.loginService,
  }); 

  Future<bool> loginWithBiometric() async {
    final canUse = await biometricService.isBiometricAvailable();
    final enabled = _box.read('isBiometricEnabled') ?? false;
    final isSaveLoginInfo = _box.read('isSaveLoginInfo') ?? false;

    if (!canUse || !enabled || !isSaveLoginInfo) return false;

    final authenticated = await biometricService.authenticate();
    if (!authenticated) return false;

    // final refreshToken = await biometricService.getBiometricToken();
    // if (refreshToken == null) return false;

    // Ambil role
    final role = _box.read("role");
    if (role == "mahasiswa") {
      final nim = _box.read("user_nim");
      final password = _box.read("password");
      if (nim != null && password != null) {
        await loginService.loginMahasiswa(nim, password);
        return true;
      }
    } else if (role == "dosen") {
      final email = _box.read("user_email");
      final password = _box.read("password");
      if (email != null && password != null) {
        await loginService.loginDosen(email, password);
        return true;
      }
    }

    return false;
  }
}
