import 'package:flutter/material.dart';

/// Paleta de la consulta Verifica CGR.
///
/// Los azules son los mismos que ya usan las demas pantallas de la app
/// (`azulMedianoche`, `azulBoton`); los colores de las pastillas de estado y de
/// los avisos vienen del CSS del portal web, para que un trámite en RI se vea
/// igual en el telefono que en la computadora.
class VerificaCgrColores {
  const VerificaCgrColores._();

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF1E6FCE);
  static const Color rojoCaribe = Color(0xFFEF3340);

  static const Color fondoPantalla = Color(0xFFF4F6F8);
  static const Color fondoSuave = Color(0xFFF8FBFF);
  static const Color fondoFila = Color(0xFFF0F4FF);
  static const Color borde = Color(0xFFD9E1EC);
  static const Color bordeSuave = Color(0xFFE0E6EF);

  static const Color texto = Color(0xFF2D3748);
  static const Color textoTenue = Color(0xFF4A5568);

  /// Estado normal (informativo).
  static const Color badgeNormalFondo = Color(0xFFE8F4FF);
  static const Color badgeNormalTexto = Color(0xFF003366);

  /// Estado "requiere información" (RI).
  static const Color badgeRiFondo = Color(0xFFFFF3CD);
  static const Color badgeRiTexto = Color(0xFF8A6D3B);
  static const Color badgeRiBorde = Color(0xFFFFEBBA);

  /// Estado rechazado.
  static const Color badgeRechazadoFondo = Color(0xFFFDECEA);
  static const Color badgeRechazadoTexto = Color(0xFF842029);
  static const Color badgeRechazadoBorde = Color(0xFFF5C2C7);

  /// Avisos (sin resultados, RI, RPE inhabilitado).
  static const Color avisoFondo = Color(0xFFFFF8E5);
  static const Color avisoBorde = Color(0xFFFFDD99);
  static const Color avisoAcento = Color(0xFFFFBF00);
  static const Color avisoTexto = Color(0xFF5F4500);
}
