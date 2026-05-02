import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class SecurityLocationService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<bool> isRooted() async {
    return await FlutterJailbreakDetection.jailbroken;
  }

  Future<bool> isEmulator() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return !info.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return !info.isPhysicalDevice;
    }
    return false;
  }
}
