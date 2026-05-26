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
  seedColor: const Color(0xFFA8D5BA),
  primary: const Color(0xFF1B3322),
  onPrimary: const Color(0xFFE8F2EA),
  secondary: const Color(0xFFFF8C42),
  onSecondary: const Color(0xFF1A1A1A),
  tertiary: const Color(0xFFA8D5BA),
  error: const Color(0xFFFF6B6B),
  surface: const Color(0xFF0F1812),
  surfaceContainer: const Color(0xFF1A241D),
  onSurface: const Color(0xFFE8F2EA),
  onSurfaceVariant: const Color(0xFFAEBCAF),
  outline: const Color(0xFF4A5A4D),
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
        elevation:
            0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: darkColorScheme.outline.withAlpha(1),
          ), 
        ),
      ),

      // TextTheme
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkColorScheme.tertiary,
        ),
        titleMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkColorScheme.tertiary,
        ),
        titleSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkColorScheme.tertiary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: darkColorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: darkColorScheme.onSurface),
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
            color: darkColorScheme.outline.withAlpha(3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: darkColorScheme.outline.withAlpha(3),
          ),
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
