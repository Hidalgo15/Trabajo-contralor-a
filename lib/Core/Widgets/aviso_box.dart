import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/chip_icono.dart';

/// Recuadro de aviso azul suave con un chip de ícono a la izquierda y, de forma
/// opcional, un título en negrita sobre el texto. Se usa al pie de las fichas de
/// consulta ("Información importante", "Tu información está segura", etc.).
class AvisoBox extends StatelessWidget {
  const AvisoBox({
    super.key,
    this.titulo,
    required this.texto,
    this.icono = Icons.info_outline,
  });

  final String? titulo;
  final String texto;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      padding: const EdgeInsets.all(AppDimens.md + 2),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          c.azul.withValues(alpha: 0.07),
          c.superficie,
        ),
        border: Border.all(color: c.azul.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChipIcono(icono, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titulo != null) ...[
                  Text(
                    titulo!,
                    style: TextStyle(
                      fontFamily: AppTypography.display,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: c.azul,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  texto,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: c.tintaSuave,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
