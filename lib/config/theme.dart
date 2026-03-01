import 'package:flutter/material.dart';

/// Configuración visual centralizada de la aplicación.
/// Si quieres cambiar colores o estilos, solo modificas ESTE archivo.
class AppTheme {
  // ─── Colores principales ───
  static const Color primaryColor = Color(0xFF1565C0); // Azul
  static const Color primaryLight = Color(0xFF5E92F3); // Azul claro
  static const Color primaryDark = Color(0xFF003C8F); // Azul oscuro
  static const Color accentColor = Color(0xFFFF6F00); // Naranja

  // Fondos.
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;

  // Texto.
  static const Color textPrimary = Color(0xFF212121); // Casi negro
  static const Color textSecondary = Color(0xFF757575); // Gris

  // Estado.
  static const Color successColor = Color(0xFF4CAF50); // Verde
  static const Color errorColor = Color(0xFFE53935); // Rojo
  static const Color warningColor = Color(0xFFFFA000); // Ámbar

  // ─── ThemeData que se pasa al MaterialApp ───
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: scaffoldBackground,

      // AppBar: azul con texto blanco, sin sombra.
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Botón principal (ElevatedButton).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Botón secundario (OutlinedButton).
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Campos de texto (TextFormField).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),

      // Tarjetas (Card).
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
