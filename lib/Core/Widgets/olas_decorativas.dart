import 'package:flutter/material.dart';

/// Degradado de fondo azul institucional para pantallas oscuras a pantalla
/// completa (splash, overlay de carga). Mismo look en todas partes.
const BoxDecoration fondoOscuroDecoracion = BoxDecoration(
  gradient: RadialGradient(
    center: Alignment(-0.1, -0.4),
    radius: 1.15,
    colors: [Color(0xFF17427E), Color(0xFF0C2551), Color(0xFF060F24)],
    stops: [0.0, 0.55, 1.0],
  ),
);

/// Ondas de fondo: una clara y tenue arriba y unas bandas de azul profundo
/// apiladas abajo, con una leve deriva animada según [fase] (0..1, típicamente
/// de un `AnimationController` en loop `reverse: true`).
class OlasDecorativasPainter extends CustomPainter {
  const OlasDecorativasPainter({required this.fase});

  final double fase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final d = (fase - 0.5) * 26; // deriva en px

    // Onda clara superior.
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.16)
        ..cubicTo(w * 0.30, h * 0.02 + d, w * 0.55, h * 0.20 - d, w, h * 0.06)
        ..lineTo(w, 0)
        ..lineTo(0, 0)
        ..close(),
      Paint()..color = Colors.white.withValues(alpha: 0.035),
    );

    // Trazo diagonal fino.
    canvas.drawPath(
      Path()
        ..moveTo(-20, h * 0.34)
        ..cubicTo(
          w * 0.25,
          h * 0.24 + d,
          w * 0.62,
          h * 0.44 - d,
          w + 20,
          h * 0.28,
        ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Dos líneas onduladas abajo, mismo estilo que las de arriba.
    canvas.drawPath(
      Path()
        ..moveTo(-20, h * 0.80)
        ..cubicTo(
          w * 0.35,
          h * 0.70 + d,
          w * 0.68,
          h * 0.90 - d,
          w + 20,
          h * 0.76,
        ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.09)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    canvas.drawPath(
      Path()
        ..moveTo(-20, h * 0.90)
        ..cubicTo(
          w * 0.32,
          h * 0.82 - d,
          w * 0.66,
          h * 0.98 + d,
          w + 20,
          h * 0.87,
        ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );
  }

  @override
  bool shouldRepaint(covariant OlasDecorativasPainter old) =>
      old.fase != fase;
}
