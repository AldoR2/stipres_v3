import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFEDEBFB), // mainColorLight
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xFF1E88E4)), // blueColorLight
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1E88E4),
      secondary: const Color(0xFFFAFF00),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xFF90CAF9)), // blueColorDark
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF90CAF9),
      secondary: const Color(0xFFFAFF00),
    ),
  );
}
