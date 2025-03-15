import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static const _neonPurple = Color(0xFF9B00FF);
  static const _neonPink = Color(0xFFFF00E5);
  static const _darkBlack = Color(0xFF1A1A1A);

  static ThemeData get neonPurpleTheme => ThemeData(
        scaffoldBackgroundColor: _darkBlack,
        textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _neonPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _neonPink),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _neonPink),
          ),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.black), // Ensure text is visible
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(_darkBlack), // Match background
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
      );

  static ThemeData get darkBlueTheme => ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
          menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
        ),
      );

  static Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
  }

  static Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme') ?? 'neonPurple';
  }
}