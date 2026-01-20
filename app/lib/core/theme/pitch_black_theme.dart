import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildPitchBlackTheme() {
  const pitchBlackBackground = Color(0xFF0A0A0A);
  const pitchBlackCardColor = Color(0xFF161616);
  const pitchBlackBorderColor = Color(0xFF2A2A2A);
  const pitchBlackTextLight = Color(0xFFF5F5F5);
  const pitchBlackTextMedium = Color(0xFFE5E5E5);
  const pitchBlackTextDim = Color(0xFFB0B0B0);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: pitchBlackBackground,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFB8B8B8),
      secondary: Color(0xFF909090),
      surface: pitchBlackCardColor,
      background: pitchBlackBackground,
      onPrimary: pitchBlackBackground,
      onSecondary: pitchBlackBackground,
      onSurface: pitchBlackTextMedium,
      onBackground: pitchBlackTextMedium,
    ),

    // Text Theme
    textTheme: TextTheme(
      // Body text - Lora
      bodyLarge: GoogleFonts.lora(
        fontSize: 18,
        height: 1.6,
        color: pitchBlackTextMedium,
      ),
      bodyMedium: GoogleFonts.lora(
        fontSize: 16,
        height: 1.6,
        color: pitchBlackTextMedium,
      ),
      bodySmall: GoogleFonts.lora(
        fontSize: 14,
        height: 1.5,
        color: pitchBlackTextDim,
      ),

      // Headlines - Inter
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: pitchBlackTextLight,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: pitchBlackTextLight,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: pitchBlackTextLight,
      ),

      // Titles
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: pitchBlackTextLight,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: pitchBlackTextLight,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: pitchBlackTextMedium,
      ),

      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: pitchBlackTextMedium,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: pitchBlackTextDim,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: pitchBlackCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: pitchBlackBorderColor, width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: pitchBlackBackground,
      foregroundColor: pitchBlackTextLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: pitchBlackTextLight,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: Color(0xFFB8B8B8),
      size: 24,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF252525),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        color: pitchBlackTextMedium,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: pitchBlackBorderColor,
      thickness: 1,
      space: 1,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: pitchBlackBackground,
      selectedItemColor: Color(0xFFE0D4C8),
      unselectedItemColor: Color(0xFF666666),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}