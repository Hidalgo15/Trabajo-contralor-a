import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Encabezado de sección: título a la izquierda y acción opcional a la derecha
/// ("Ver todos").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titulo,
    this.accionLabel,
    this.onAccion,
  });

  final String titulo;
  final String? accionLabel;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              titulo,
              style: const TextStyle(
                fontFamily: AppTypography.display,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (accionLabel != null)
          GestureDetector(
            onTap: onAccion,
            child: Text(
              accionLabel!,
              style: TextStyle(
                fontFamily: AppTypography.cuerpo,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
                color: c.azulEnlace,
              ),
            ),
          ),
      ],
    );
  }
}
