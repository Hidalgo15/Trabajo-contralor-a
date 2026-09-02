import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Ilustración plana de "carnet de servidor público" para el encabezado de la
/// consulta de Empleados del Estado. Está armada con formas (no es un PNG), así
/// que se ve nítida a cualquier tamaño y sigue la paleta institucional.
class IlustracionEmpleados extends StatelessWidget {
  const IlustracionEmpleados({super.key, this.size = 74});

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
        height: s(84),
        child: Center(
          child: SizedBox(
            width: s(56),
            height: s(80),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ---- Carnet ----
                Positioned.fill(
                  child: Container(
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
                    padding: EdgeInsets.fromLTRB(s(9), s(10), s(9), s(9)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // pinza superior del carnet
                        Container(
                          height: s(4),
                          width: s(16),
                          decoration: BoxDecoration(
                            color: c.azulProfundo,
                            borderRadius: BorderRadius.circular(s(3)),
                          ),
                        ),
                        SizedBox(height: s(7)),
                        // foto
                        Container(
                          width: s(24),
                          height: s(24),
                          decoration: BoxDecoration(
                            color: Color.alphaBlend(
                              c.azul.withValues(alpha: 0.16),
                              c.superficie,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: s(16),
                            color: c.azul,
                          ),
                        ),
                        SizedBox(height: s(9)),
                        barra(26),
                        SizedBox(height: s(6)),
                        barra(16),
                      ],
                    ),
                  ),
                ),
                // ---- Sello, pegado a la esquina inferior derecha ----
                Positioned(
                  right: s(1),
                  bottom: s(1),
                  child: Container(
                    width: s(18),
                    height: s(18),
                    decoration: BoxDecoration(
                      color: c.superficie,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.azul, width: s(1.8)),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: s(11),
                      color: c.azul,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
