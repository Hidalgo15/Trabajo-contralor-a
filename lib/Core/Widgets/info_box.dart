import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';

enum InfoBoxKind { info, aviso }

/// Recuadro de aviso con ícono. Azul para información, ámbar para advertencias.
class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.texto,
    this.kind = InfoBoxKind.info,
    this.icono,
  });

  final String texto;
  final InfoBoxKind kind;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final esAviso = kind == InfoBoxKind.aviso;

    final fondo = esAviso
        ? c.avisoFondo
        : Color.alphaBlend(c.azul.withValues(alpha: 0.08), c.superficie);
    final borde = esAviso
        ? c.aviso.withValues(alpha: 0.4)
        : c.azul.withValues(alpha: 0.22);
    final acento = esAviso ? c.aviso : c.azul;
    final textoColor = esAviso ? c.aviso : c.tintaSuave;

    return Container(
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: fondo,
        border: Border.all(color: borde),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icono ?? (esAviso ? Icons.warning_amber_rounded : Icons.info_outline),
            size: 16,
            color: acento,
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textoColor, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
