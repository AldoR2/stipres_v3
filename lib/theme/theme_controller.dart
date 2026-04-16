import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeController() {
    // Inisialisasi langsung saat instance dibuat
    themeMode.value = _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get currentTheme => themeMode.value;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _saveThemeToBox(mode == ThemeMode.dark);
    Get.changeThemeMode(mode);
  }
}
