import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Ilustración plana de "certificado + sello" para el encabezado de la consulta
/// de Certificación de Cargos. Está armada con formas (no es un PNG), así que se
/// ve nítida a cualquier tamaño y sigue la paleta institucional.
class IlustracionCertificacion extends StatelessWidget {
  const IlustracionCertificacion({super.key, this.size = 74});

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
            // ---- Documento ----
            Positioned(
              left: s(2),
              top: 0,
              child: Container(
                width: s(58),
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
                      width: s(30),
                      decoration: BoxDecoration(
                        color: c.azul,
                        borderRadius: BorderRadius.circular(s(3)),
                      ),
                    ),
                    SizedBox(height: s(4)),
                    barra(18, alpha: 0.18),
                    SizedBox(height: s(9)),
                    barra(34),
                    SizedBox(height: s(6)),
                    barra(28),
                    SizedBox(height: s(6)),
                    barra(34),
                  ],
                ),
              ),
            ),
            // ---- Sello de certificación ----
            Positioned(
              right: 0,
              bottom: s(2),
              child: Container(
                width: s(28),
                height: s(28),
                decoration: BoxDecoration(
                  color: c.superficie,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.azulProfundo, width: s(2.4)),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  size: s(16),
                  color: c.azul,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
