/// Escala de espaciado, radios y medidas fijas del rediseño.
///
/// Una sola escala para toda la app: nada de "8 aquí, 10 allá". Si un valor no
/// está en esta lista, probablemente no debería usarse.
class AppDimens {
  const AppDimens._();

  // Espaciado (múltiplos de 4).
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Radios de esquina.
  static const double radioSm = 10;
  static const double radioMd = 12;
  static const double radioLg = 16;
  static const double radioPastilla = 999;

  /// Alto mínimo de controles táctiles (inputs y botones). >= 48 por
  /// accesibilidad.
  static const double alturaControl = 52;

  /// Ancho máximo del contenido centrado en pantallas anchas (tablet / web).
  static const double anchoContenido = 1100;

  /// Ancho al que un formulario deja de crecer.
  static const double anchoFormulario = 480;

  /// Punto donde el layout pasa de una a dos columnas.
  static const double puntoAncho = 768;
}
