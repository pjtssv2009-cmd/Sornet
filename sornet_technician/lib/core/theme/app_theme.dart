import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette - Strict Light Mode Only
  static const Color primary = Color(0xFF155EEF); // Royal Blue
  static const Color primaryBlue = Color(0xFF155EEF);
  static const Color primaryDark = Color(0xFF0040C1);
  static const Color primaryLight = Color(0xFFEFF4FF);
  static const Color primarySurface = Color(0xFFE0EAFF);

  static const Color secondary = Color(0xFF38BDF8); // Sky Blue
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color secondaryDark = Color(0xFF0284C7);
  static const Color secondaryLight = Color(0xFFF0F9FF);

  static const Color accentNavy = Color(0xFF0A2540); // Dark Navy
  static const Color darkNavy = Color(0xFF0A2540);

  // Backgrounds & Canvas (Light Only)
  static const Color background = Color(0xFFF8FAFC); // Soft Slate/Ice Blue Canvas
  static const Color backgroundSoft = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textMuted = Color(0xFF64748B);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Functional & Status Accents
  static const Color success = Color(0xFF12B76A); // Emerald Green
  static const Color accentGreen = Color(0xFF12B76A);
  static const Color successBg = Color(0xFFECFDF3);
  static const Color successText = Color(0xFF027A48);

  static const Color warning = Color(0xFFF79009); // Amber
  static const Color accentOrange = Color(0xFFF79009);
  static const Color warningBg = Color(0xFFFEF0C7);
  static const Color warningText = Color(0xFFB54708);

  static const Color error = Color(0xFFF04438); // Crimson Red
  static const Color accentRed = Color(0xFFF04438);
  static const Color errorBg = Color(0xFFFEF3F2);
  static const Color errorText = Color(0xFFB42318);

  static const Color info = Color(0xFF0BA5EC); // Sky Info
  static const Color infoBg = Color(0xFFF0F9FF);
  static const Color infoText = Color(0xFF026AA2);

  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleBg = Color(0xFFF4EBFF);
  static const Color purpleText = Color(0xFF6927DA);

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFEEF2F6);

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get cardShadowHover => [
        BoxShadow(
          color: const Color(0xFF155EEF).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get primaryButtonShadow => [
        BoxShadow(
          color: const Color(0xFF155EEF).withValues(alpha: 0.28),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF155EEF), Color(0xFF0040C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF155EEF), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient trustScoreGradient = LinearGradient(
    colors: [Color(0xFF0A2540), Color(0xFF155EEF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ThemeData Definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textTertiary,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
