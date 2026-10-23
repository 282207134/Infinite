import 'package:flutter/material.dart';

abstract final class Palette {
  static const top = Color(0xFF435461), bottom = Color(0xFF28343A);
  static const panel = Color(0xFF3A4A54), muted = Color(0xFFAEBECE);
  static const blue = Color(0xFF92CAFB), blueDark = Color(0xFF559CD9);
  static const orange = Color(0xFFE97B60), green = Color(0xFF77E965);
  static const gold = Color(0xFFFFDD86), line = Color(0x20AEBECE);
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  );
  static const blueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue, blueDark],
  );
  static const greenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8CFD97), Color(0xFF4ECB5A)],
  );
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bottom,
    colorScheme: const ColorScheme.dark(
      primary: blue,
      secondary: green,
      surface: panel,
    ),
    dividerTheme: const DividerThemeData(color: line, thickness: .5),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12, color: muted),
    ),
    dividerColor: line,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: panel,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: muted, fontSize: 13),
    ),
  );
}
