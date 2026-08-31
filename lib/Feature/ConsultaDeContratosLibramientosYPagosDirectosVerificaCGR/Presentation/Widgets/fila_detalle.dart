import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Fila etiqueta/valor apilada (etiqueta arriba en azul, valor debajo).
class FilaDetalle extends StatelessWidget {
  const FilaDetalle({
    super.key,
    required this.etiqueta,
    this.valor,
    this.contenido,
    this.enfatizarValor = false,
  }) : assert(
          valor != null || contenido != null,
          'FilaDetalle necesita un valor o un contenido',
        );

  final String etiqueta;
  final String? valor;
  final Widget? contenido;
  final bool enfatizarValor;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              fontFamily: AppTypography.cuerpo,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.azul,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          contenido ??
              Text(
                valor!,
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: enfatizarValor ? 15 : 14,
                  fontWeight:
                      enfatizarValor ? FontWeight.w700 : FontWeight.normal,
                  color: c.tinta,
                  height: 1.35,
                ),
              ),
        ],
      ),
    );
  }
}

/// Divisor tenue entre filas.
class DivisorFila extends StatelessWidget {
  const DivisorFila({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: context.colores.borde);
}

/// Envoltura común de las tarjetas de resultado: franja azul a la izquierda,
/// encabezado con la institución y botón de descarga.
class TarjetaResultado extends StatelessWidget {
  const TarjetaResultado({
    super.key,
    required this.institucion,
    required this.hijos,
    this.onDescargar,
  });

  final String institucion;
  final List<Widget> hijos;
  final VoidCallback? onDescargar;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border.all(color: c.borde),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 4, child: ColoredBox(color: c.azul)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                    decoration: BoxDecoration(
                      color: c.superficieAlt,
                      border: Border(bottom: BorderSide(color: c.borde)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            institucion,
                            style: TextStyle(
                              fontFamily: AppTypography.cuerpo,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: c.azul,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (onDescargar != null)
                          IconButton(
                            onPressed: onDescargar,
                            icon: const Icon(Icons.download_rounded),
                            color: c.azulEnlace,
                            tooltip: 'Descargar PDF',
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: hijos,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
