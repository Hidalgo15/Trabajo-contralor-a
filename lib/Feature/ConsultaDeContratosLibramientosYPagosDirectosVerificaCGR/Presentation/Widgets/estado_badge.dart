import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/estado_tramite.dart';

/// Pastilla de estado del trámite. Azul informativo, ámbar "requiere
/// información", rojo rechazado.
class EstadoBadge extends StatelessWidget {
  const EstadoBadge({super.key, required this.estado});

  final EstadoTramite estado;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    final (Color fondo, Color texto) = switch (estado.tipo) {
      TipoEstadoTramite.requiereInformacion => (c.avisoFondo, c.aviso),
      TipoEstadoTramite.rechazado => (c.rechazoFondo, c.rechazo),
      TipoEstadoTramite.normal => (
          Color.alphaBlend(c.azulEnlace.withValues(alpha: 0.14), c.superficie),
          c.azulEnlace,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(AppDimens.radioSm),
        border: Border.all(color: texto.withValues(alpha: 0.35)),
      ),
      child: Text(
        estado.mensaje,
        style: TextStyle(
          color: texto,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Aviso que acompaña a los trámites en RI o rechazados.
class AvisoRequiereInformacion extends StatelessWidget {
  const AvisoRequiereInformacion({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Container(
      margin: const EdgeInsets.only(top: AppDimens.md),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: 10),
      decoration: BoxDecoration(
        color: c.avisoFondo,
        border: Border.all(color: c.aviso.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(AppDimens.radioSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 20, color: c.aviso),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Text(
              'En caso de requerir información adicional, favor contactar con '
              'la institución contratante.',
              style: TextStyle(fontSize: 13, color: c.aviso, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
