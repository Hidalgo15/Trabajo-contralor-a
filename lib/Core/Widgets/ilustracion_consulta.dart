import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Ilustración plana de "documento + lupa" para el encabezado de las consultas.
/// Está armada con formas (no es un PNG), así que se ve nítida a cualquier
/// tamaño y sigue la paleta institucional.
class IlustracionConsulta extends StatelessWidget {
  const IlustracionConsulta({super.key, this.size = 74});

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

    Widget punto(Color color) => Container(
      width: s(5),
      height: s(5),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size * 1.14,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- Documento ----
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: s(56),
                height: s(74),
                decoration: BoxDecoration(
                  color: c.superficie,
                  borderRadius: BorderRadius.circular(s(8)),
                  border: Border.all(color: c.borde),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: s(12),
                      offset: Offset(0, s(4)),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(s(10), s(12), s(10), s(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: s(5),
                      width: s(26),
                      decoration: BoxDecoration(
                        color: c.azul,
                        borderRadius: BorderRadius.circular(s(3)),
                      ),
                    ),
                    SizedBox(height: s(9)),
                    Row(
                      children: [
                        punto(c.rojo),
                        SizedBox(width: s(5)),
                        barra(24),
                      ],
                    ),
                    SizedBox(height: s(7)),
                    Row(
                      children: [
                        punto(c.azul),
                        SizedBox(width: s(5)),
                        barra(18),
                      ],
                    ),
                    SizedBox(height: s(7)),
                    Row(
                      children: [
                        Icon(Icons.check, size: s(10), color: c.exito),
                        SizedBox(width: s(4)),
                        barra(20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ---- Lupa ----
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: s(34),
                height: s(34),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // mango
                    Positioned(
                      right: s(1),
                      bottom: s(1),
                      child: Transform.rotate(
                        angle: 0.785398, // 45°
                        child: Container(
                          width: s(4),
                          height: s(12),
                          decoration: BoxDecoration(
                            color: c.azulProfundo,
                            borderRadius: BorderRadius.circular(s(3)),
                          ),
                        ),
                      ),
                    ),
                    // lente
                    Container(
                      width: s(28),
                      height: s(28),
                      decoration: BoxDecoration(
                        color: c.superficie,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.azulProfundo,
                          width: s(2.4),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: s(15),
                        color: c.azul,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
