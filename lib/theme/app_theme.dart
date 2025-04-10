import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryRed = Color(0xFFFF2D55); // Apple Music red
  static const Color secondaryRed =
      Color(0xFFFF375F); // Lighter red for accents
  static const Color darkBackground =
      Color(0xFF000000); // Pure black background
  static const Color darkSurface = Color(0xFF1C1C1E); // Apple Music card color
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF98989D); // Apple Music gray text
  static const Color dividerColor = Color(0xFF2C2C2E); // Apple Music divider

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryRed, secondaryRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryRed,
      secondary: secondaryRed,
      background: darkBackground,
      surface: darkSurface,
      onSurface: textPrimary,
      error: primaryRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkBackground,
      selectedItemColor: primaryRed,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 17,
        letterSpacing: -0.5,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 15,
        letterSpacing: -0.5,
      ),
    ),
    iconTheme: const IconThemeData(
      color: textPrimary,
      size: 24,
    ),
    cardTheme: CardTheme(
      color: darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 0.5,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryRed,
      inactiveTrackColor: darkSurface,
      thumbColor: primaryRed,
      trackHeight: 2.0,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6.0,
      ),
      overlayColor: primaryRed.withOpacity(0.2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
  );
}
