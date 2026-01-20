import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildParchmentTheme() {
  const parchmentBackground = Color(0xFFF5F0E6); // 羊皮纸米黄色
  const parchmentCardColor = Color(0xFFFFFFFB);
  const parchmentBorderColor = Color(0xFFE8E6E1);
  const parchmentTextDark = Color(0xFF2C2C2C);
  const parchmentTextMedium = Color(0xFF1A1A1A);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: parchmentBackground,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: Color(0xFF8B7355),
      secondary: Color(0xFFA68A6D),
      surface: parchmentCardColor,
      background: parchmentBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: parchmentTextDark,
      onBackground: parchmentTextDark,
    ),

    // Text Theme
    textTheme: TextTheme(
      // Body text - Lora
      bodyLarge: GoogleFonts.lora(
        fontSize: 18,
        height: 1.6,
        color: parchmentTextDark,
      ),
      bodyMedium: GoogleFonts.lora(
        fontSize: 16,
        height: 1.6,
        color: parchmentTextDark,
      ),
      bodySmall: GoogleFonts.lora(
        fontSize: 14,
        height: 1.5,
        color: parchmentTextDark,
      ),

      // Headlines - Frank Ruhl Libre (Claude-like serif)
      headlineLarge: GoogleFonts.frankRuhlLibre(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: parchmentTextMedium,
      ),
      headlineMedium: GoogleFonts.frankRuhlLibre(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),
      headlineSmall: GoogleFonts.frankRuhlLibre(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),

      // Titles
      titleLarge: GoogleFonts.frankRuhlLibre(
        fontSize: 20, // Slightly larger for readability
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),
      titleMedium: GoogleFonts.frankRuhlLibre(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),
      titleSmall: GoogleFonts.frankRuhlLibre(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),

      // Labels - Keep Inter for UI elements for legibility
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: parchmentTextDark,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: parchmentTextDark,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: parchmentCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: parchmentBorderColor, width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: parchmentBackground,
      foregroundColor: parchmentTextMedium,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: parchmentTextMedium,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: Color(0xFF8B7355),
      size: 24,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFFF0EDE8),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        color: Color(0xFF5D4E3C),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: parchmentBorderColor,
      thickness: 1,
      space: 1,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: parchmentBackground,
      selectedItemColor: Color(0xFF8B7355),
      unselectedItemColor: Color(0xFF9E9E9E),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}