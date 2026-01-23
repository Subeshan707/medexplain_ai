import 'package:flutter/material.dart';

/// STRICT 5-COLOR MEDICAL DESIGN SYSTEM - BLUE THEME
class AppTheme {
  // ALLOWED COLORS ONLY
  static const Color darkBlue = Color(0xFF0D47A1); // Deep Navy Blue
  static const Color primaryBlue = Color(0xFF1976D2); // Material Blue 700
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color alertRed = Color(0xFFD32F2F);
  
  static const Color lightSurface = Color(0xFFE3F2FD); // Blue 50 - Light Blue Tint
  
  // Backward compatibility / Semantic Aliases
  static const Color neutralBlack = black;
  static const Color successBlue = primaryBlue; // Formerly successGreen
  static const Color primaryColor = primaryBlue;
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: darkBlue,
      surface: white,
      error: alertRed,
      onPrimary: white,
      onSecondary: white,
      onSurface: black,
      onError: white,
    ),
    
    scaffoldBackgroundColor: lightSurface,
    cardColor: white,
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: black),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: black),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: black),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: black),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: black),
      bodyLarge: TextStyle(fontSize: 16, color: black, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: black, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, color: black, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryBlue),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryBlue),
        foregroundColor: MaterialStateProperty.all(white),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(primaryBlue),
        side: MaterialStateProperty.all(
          const BorderSide(color: primaryBlue, width: 2),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: black),
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
    ),
    
    iconTheme: const IconThemeData(
      color: black,
      size: 24,
    ),
  );
  
  // Dark theme colors
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBlueAccent = Color(0xFF2196F3); // Brighter blue for dark mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  
  // Comprehensive Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: const ColorScheme.dark(
      primary: darkBlueAccent,
      secondary: primaryBlue,
      surface: darkCard,
      error: alertRed,
      onPrimary: white,
      onSecondary: white,
      onSurface: darkTextPrimary,
      onError: white,
    ),
    
    scaffoldBackgroundColor: darkSurface,
    cardColor: darkCard,
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextPrimary),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkTextPrimary),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkTextPrimary),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkTextPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: darkTextPrimary, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: darkTextPrimary, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, color: darkTextSecondary, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkBlueAccent),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCard,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkTextPrimary),
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(darkBlueAccent),
        foregroundColor: WidgetStateProperty.all(white),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(darkBlueAccent),
        side: WidgetStateProperty.all(
          const BorderSide(color: darkBlueAccent, width: 2),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkTextSecondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkTextSecondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBlueAccent, width: 2),
      ),
      labelStyle: const TextStyle(color: darkTextSecondary),
      hintStyle: const TextStyle(color: darkTextSecondary),
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: darkBlueAccent,
    ),
    
    iconTheme: const IconThemeData(
      color: darkTextPrimary,
      size: 24,
    ),
    
    cardTheme: const CardThemeData(
      color: darkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
    
    listTileTheme: const ListTileThemeData(
      textColor: darkTextPrimary,
      iconColor: darkBlueAccent,
    ),
    
    dividerTheme: const DividerThemeData(
      color: darkTextSecondary,
      thickness: 0.5,
    ),
    
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return darkBlueAccent;
        return darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          // darkBlueAccent with 50% opacity
          return const Color(0x802196F3);
        }
        // darkTextSecondary with 30% opacity
        return const Color(0x4DB0B0B0);
      }),
    ),
    
    dialogTheme: const DialogThemeData(
      backgroundColor: darkCard,
    ),
    
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: darkCard,
      contentTextStyle: TextStyle(color: darkTextPrimary),
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkCard,
    ),
  );
}
