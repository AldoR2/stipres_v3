import 'package:flutter/material.dart';

class AppColors {
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFEDEBFB);

  static Color header(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF90CAF9)
          : const Color(0xFF1E88E4);
}
