import 'package:flutter/material.dart';

class MyAppTheme {
  MyAppTheme._();
  // --- LIGHT COLORS ---
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color(0xFFA8D5BA),
    primary: const Color(0xFFA8D5BA),
    onPrimary: const Color(0xFF1B3322),
    secondary: const Color(0xFFFF8C42),
    onSecondary: Colors.white,
    tertiary: const Color.fromARGB(255, 48, 126, 57),
    error: const Color(0xFFE63946),
    surface: const Color(0xFFE8F2EA),
    surfaceContainer: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF045322),
    onSurfaceVariant: const Color.fromARGB(255, 122, 145, 123),
    outline: const Color(0xFFD1D1D1),
  );
  // --- DARK COLORS ---
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF2E7D4F),
    primary: const Color(0xFF2E7D4F),
    onPrimary: const Color(0xFFFFFFFF),
    secondary: const Color(0xFFFF9F43),
    onSecondary: const Color(0xFF111111),
    tertiary: const Color(0xFF7FD69B),
    onTertiary: const Color(0xFF121212),
    error: const Color(0xFFFF6B6B),
    surface: const Color(0xFF101010),
    surfaceContainer: const Color(0xFF1C1C1E),
    onSurface: const Color(0xFFF5F5F5),
    onSurfaceVariant: const Color(0xFFB8B8B8),
    outline: const Color(0xFF3A3A3C),
  );
  // -- LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
      ),

      // Card
      cardTheme: CardThemeData(
        color: lightColorScheme.surfaceContainer,
        margin: const EdgeInsets.all(10),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // TextTheme
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightColorScheme.tertiary,
        ),
        titleMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightColorScheme.tertiary,
        ),
        titleSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightColorScheme.tertiary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: lightColorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: lightColorScheme.onSurface),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: lightColorScheme.onSurfaceVariant,
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              lightColorScheme.primary, // Sostituito container mancante
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(color: lightColorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // TextField / Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.outline),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.secondary,
        foregroundColor: Colors.white,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightColorScheme.surface,
        selectedItemColor: lightColorScheme.secondary,
        unselectedItemColor: lightColorScheme.tertiary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
      ),

      // Card 
      cardTheme: CardThemeData(
        color: darkColorScheme.surfaceContainer,
        margin: const EdgeInsets.all(10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: darkColorScheme.outline,
          ), 
        ),
      ),

      // TextTheme
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkColorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkColorScheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkColorScheme.onSurface,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: darkColorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: darkColorScheme.onSurface),
        bodySmall: TextStyle(
          fontSize: 12,
          color: darkColorScheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkColorScheme.onSurfaceVariant,
        ),
      ),

      // Bottoni 
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // SearchBar / Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: darkColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: darkColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorScheme.primary),
        ),
        hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.secondary,
        foregroundColor: darkColorScheme.onSecondary,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkColorScheme.surfaceContainer,
        selectedItemColor: darkColorScheme.secondary,
        unselectedItemColor: darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
