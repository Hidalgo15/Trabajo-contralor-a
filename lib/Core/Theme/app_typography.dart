import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tres roles tipográficos del rediseño:
///
/// - **display**: Bricolage Grotesque, titulares con carácter, uso contenido.
/// - **cuerpo**: IBM Plex Sans, texto de lectura y de interfaz.
/// - **mono**: IBM Plex Mono, para datos que deben alinear: RNC, cédula,
///   números de orden, montos.
class AppTypography {
  const AppTypography._();

  static const String display = 'Bricolage Grotesque';
  static const String cuerpo = 'IBM Plex Sans';
  static const String mono = 'IBM Plex Mono';

  /// [TextTheme] completo derivado de la [AppColors] activa.
  static TextTheme textTheme(AppColors c) {
    return TextTheme(
      // Titulares (Bricolage).
      displaySmall: TextStyle(
        fontFamily: display,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: c.tinta,
      ),
      headlineMedium: TextStyle(
        fontFamily: display,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.2,
        color: c.tinta,
      ),
      headlineSmall: TextStyle(
        fontFamily: display,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.25,
        color: c.tinta,
      ),
      titleLarge: TextStyle(
        fontFamily: display,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.3,
        color: c.tinta,
      ),

      // Subtítulos y etiquetas de interfaz (Plex Sans).
      titleMedium: TextStyle(
        fontFamily: cuerpo,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: c.tinta,
      ),
      titleSmall: TextStyle(
        fontFamily: cuerpo,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: c.tintaSuave,
      ),

      // Texto de lectura.
      bodyLarge: TextStyle(
        fontFamily: cuerpo,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: c.tinta,
      ),
      bodyMedium: TextStyle(
        fontFamily: cuerpo,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: c.tintaSuave,
      ),
      bodySmall: TextStyle(
        fontFamily: cuerpo,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: c.tenue,
      ),

      // Botones y micro-etiquetas.
      labelLarge: TextStyle(
        fontFamily: cuerpo,
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.2,
        color: c.tinta,
      ),
      labelMedium: TextStyle(
        fontFamily: cuerpo,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.2,
        color: c.tintaSuave,
      ),
      labelSmall: TextStyle(
        fontFamily: mono,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        height: 1.2,
        color: c.tenue,
      ),
    );
  }

  /// Estilo monoespaciado para datos. Se usa suelto, no vive en el [TextTheme].
  static TextStyle datos({
    required Color color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: mono,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.2,
      color: color,
    );
  }
}
