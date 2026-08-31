import 'package:flutter/material.dart';

/// Paleta de la consulta Verifica CGR.
///
/// Alineada al rediseño: azul y rojo institucionales de la Contraloría. Las
/// pastillas de estado conservan su semántica (azul informativo, ámbar
/// "requiere información", rojo rechazado). Si el resto de la app ya migró a
/// `context.colores`, esto son los mismos valores para no romper los widgets
/// de resultados mientras se terminan de migrar.
class VerificaCgrColores {
  const VerificaCgrColores._();

  static const Color azulMedianoche = Color(0xFF003876);
  static const Color azulBoton = Color(0xFF1160B4);
  static const Color rojoCaribe = Color(0xFFED1C24);

  static const Color fondoPantalla = Color(0xFFEEF2F8);
  static const Color fondoSuave = Color(0xFFF4F7FC);
  static const Color fondoFila = Color(0xFFEEF3F9);
  static const Color borde = Color(0xFFDBE3EE);
  static const Color bordeSuave = Color(0xFFE4EAF2);

  static const Color texto = Color(0xFF10233B);
  static const Color textoTenue = Color(0xFF5C6E88);

  /// Estado normal (informativo).
  static const Color badgeNormalFondo = Color(0xFFE6EFF9);
  static const Color badgeNormalTexto = Color(0xFF002B5B);

  /// Estado "requiere información" (RI).
  static const Color badgeRiFondo = Color(0xFFFBEED6);
  static const Color badgeRiTexto = Color(0xFF895A12);
  static const Color badgeRiBorde = Color(0xFFEAD3A6);

  /// Estado rechazado.
  static const Color badgeRechazadoFondo = Color(0xFFFBE4E6);
  static const Color badgeRechazadoTexto = Color(0xFFA81B2B);
  static const Color badgeRechazadoBorde = Color(0xFFF1C4C8);

  /// Avisos (sin resultados, RI, RPE inhabilitado).
  static const Color avisoFondo = Color(0xFFFBEED6);
  static const Color avisoBorde = Color(0xFFEAD3A6);
  static const Color avisoAcento = Color(0xFFC98A1F);
  static const Color avisoTexto = Color(0xFF5F4500);
}
