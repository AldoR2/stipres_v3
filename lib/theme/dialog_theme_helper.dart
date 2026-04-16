import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customLightDialogTheme(Color primaryColor) {
  return ThemeData.light().copyWith(
    dialogBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      onSurface: Colors.black,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      titleLarge: GoogleFonts.poppins(color: Colors.black),
      bodyMedium: GoogleFonts.poppins(color: Colors.black87),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),
    unselectedWidgetColor: primaryColor,
  );
}

ThemeData customDarkDialogTheme(Color primaryColor) {
  return ThemeData.dark().copyWith(
    dialogBackgroundColor: Color(0xFF1E1E1E),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme:
        GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge: GoogleFonts.poppins(color: Colors.white),
      bodyMedium: GoogleFonts.poppins(color: Colors.white70),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),
    unselectedWidgetColor: primaryColor,
  );
}
