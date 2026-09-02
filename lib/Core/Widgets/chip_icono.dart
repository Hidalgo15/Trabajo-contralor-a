import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Círculo celeste con un ícono azul. Se usa a la izquierda de campos, filas de
/// ayuda y avisos en las pantallas de consulta.
class ChipIcono extends StatelessWidget {
  const ChipIcono(this.icono, {super.key, this.size = 44});

  final IconData icono;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          c.azul.withValues(alpha: 0.12),
          c.superficie,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(icono, size: size * 0.45, color: c.azul),
    );
  }
}
