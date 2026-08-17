import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/estado_tramite.dart';
import 'verifica_cgr_colores.dart';

/// Pastilla de estado del trámite. Los colores comunican la misma semántica
/// que el portal web: azul informativo, amarillo requiere información, rojo
/// rechazado.
class EstadoBadge extends StatelessWidget {
  const EstadoBadge({super.key, required this.estado});

  final EstadoTramite estado;

  @override
  Widget build(BuildContext context) {
    final (fondo, texto, borde) = switch (estado.tipo) {
      TipoEstadoTramite.requiereInformacion => (
          VerificaCgrColores.badgeRiFondo,
          VerificaCgrColores.badgeRiTexto,
          VerificaCgrColores.badgeRiBorde,
        ),
      TipoEstadoTramite.rechazado => (
          VerificaCgrColores.badgeRechazadoFondo,
          VerificaCgrColores.badgeRechazadoTexto,
          VerificaCgrColores.badgeRechazadoBorde,
        ),
      TipoEstadoTramite.normal => (
          VerificaCgrColores.badgeNormalFondo,
          VerificaCgrColores.badgeNormalTexto,
          VerificaCgrColores.badgeNormalFondo,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borde),
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

/// Aviso que acompaña a los trámites en RI o rechazados. El texto es el mismo,
/// palabra por palabra, que el del portal web.
class AvisoRequiereInformacion extends StatelessWidget {
  const AvisoRequiereInformacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: VerificaCgrColores.avisoFondo,
        border: Border.all(color: VerificaCgrColores.avisoBorde),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: VerificaCgrColores.avisoAcento,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'En caso de requerir información adicional, favor contactar con '
              'la institución contratante.',
              style: TextStyle(
                fontSize: 13,
                color: VerificaCgrColores.avisoTexto,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
