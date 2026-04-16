import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/constants/styles.dart';
import 'theme_controller.dart';

// Ambil theme dari ThemeController (kalau pakai GetX)
bool isDarkMode(BuildContext context) {
  final controller = Get.find<ThemeController>();
  return controller.currentTheme == ThemeMode.dark;
}

// Warna utama biru
Color getBlueColor(BuildContext context) {
  return isDarkMode(context)
      ? const Color.fromARGB(255, 0, 0, 0)
      : const Color(0xFF1E88E4);
}

// Warna latar belakang utama (misalnya scaffold)
Color getMainColor(BuildContext context) {
  return isDarkMode(context) ? Color(0xFF0A0E11) : Color(0xFFEDEBFB);
}

Color getTextColor(BuildContext context) {
  return isDarkMode(context) ? Colors.white : Colors.black;
}

Color getTextColor2(BuildContext context) {
  return isDarkMode(context) ? blueColor : whiteColor;
}

Color getTextDialog(BuildContext context) {
  return isDarkMode(context) ? whiteColor : Color(0xFF083663);
}

Color getSecondaryTextColor(BuildContext context) {
  return isDarkMode(context)
      ? const Color(0xFFBBBBBB)
      : const Color.fromARGB(255, 161, 161, 161);
}

Color getCircleColor(BuildContext context) {
  return isDarkMode(context) ? Color(0xFF0A0E11) : Color(0xFFEDEBFB);
}

Color getItemSelected(BuildContext context) {
  return isDarkMode(context) ? whiteColor : blueColor;
}

Color getTextField(BuildContext context) {
  return isDarkMode(context) ? blackColor : whiteColor;
}

Color getOutlined(BuildContext context) {
  return isDarkMode(context) ? greyColor : Color.fromARGB(255, 79, 176, 255);
}

Image getLogoImage(BuildContext context) {
  return isDarkMode(context)
      ? Image.asset("assets/images/stipres_logo_dark.png",
          width: 150, height: 150)
      : Image.asset("assets/images/stipres_logo_light.png",
          width: 150, height: 150);
}

Image getLogoImage2(BuildContext context) {
  return isDarkMode(context)
      ? Image.asset("assets/images/stipres_logo_dark.png",
          width: 200, height: 200)
      : Image.asset("assets/images/stipres_logo_light.png",
          width: 200, height: 200);
}
