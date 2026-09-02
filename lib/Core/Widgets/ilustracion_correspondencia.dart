import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Ilustración plana de "sobre + seguimiento" para el encabezado de la consulta
/// de Correspondencia. Está armada con formas (no es un PNG), así que se ve
/// nítida a cualquier tamaño y sigue la paleta institucional.
class IlustracionCorrespondencia extends StatelessWidget {
  const IlustracionCorrespondencia({super.key, this.size = 74});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final escala = size / 74;
    double s(double v) => v * escala;

    Widget barra(double ancho, {double alpha = 0.28}) => Container(
      height: s(4),
      width: s(ancho),
      decoration: BoxDecoration(
        color: c.azul.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(s(3)),
      ),
    );

    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size * 1.14,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- Carta que asoma ----
            Positioned(
              left: s(13),
              top: 0,
              child: Container(
                width: s(44),
                height: s(30),
                decoration: BoxDecoration(
                  color: c.superficie,
                  borderRadius: BorderRadius.circular(s(4)),
                  border: Border.all(color: c.borde),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: s(8),
                      offset: Offset(0, s(3)),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: s(7),
                  vertical: s(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    barra(22),
                    SizedBox(height: s(5)),
                    barra(14),
                  ],
                ),
              ),
            ),
            // ---- Sobre ----
            Positioned(
              left: s(2),
              bottom: s(6),
              child: CustomPaint(
                size: Size(s(62), s(44)),
                painter: _SobrePainter(
                  relleno: Color.alphaBlend(
                    c.azul.withValues(alpha: 0.12),
                    c.superficie,
                  ),
                  linea: c.azul.withValues(alpha: 0.55),
                  trazo: s(1.6),
                  radio: s(6),
                ),
              ),
            ),
            // ---- Sello de seguimiento ----
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: s(24),
                height: s(24),
                decoration: BoxDecoration(
                  color: c.superficie,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.azulProfundo, width: s(2.2)),
                ),
                child: Icon(Icons.place, size: s(14), color: c.azul),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SobrePainter extends CustomPainter {
  _SobrePainter({
    required this.relleno,
    required this.linea,
    required this.trazo,
    required this.radio,
  });

  final Color relleno;
  final Color linea;
  final double trazo;
  final double radio;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radio));

    final fill = Paint()
      ..color = relleno
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = linea
      ..style = PaintingStyle.stroke
      ..strokeWidth = trazo
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, fill);
    canvas.drawRRect(rrect.deflate(trazo / 2), stroke);

    // solapa en "V"
    final flap = Path()
      ..moveTo(rect.left + trazo, rect.top + radio * 0.5)
      ..lineTo(size.width / 2, size.height * 0.5)
      ..lineTo(rect.right - trazo, rect.top + radio * 0.5);
    canvas.drawPath(flap, stroke);
  }

  @override
  bool shouldRepaint(_SobrePainter old) =>
      old.relleno != relleno ||
      old.linea != linea ||
      old.trazo != trazo ||
      old.radio != radio;
}
