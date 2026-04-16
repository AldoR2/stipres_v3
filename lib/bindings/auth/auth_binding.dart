import 'package:get/get.dart';
import 'package:stipres/services/token_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TokenService>(TokenService(), permanent: true);
  }
}
