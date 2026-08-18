import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/contrato_entity.dart';
import 'estado_badge.dart';
import 'fila_detalle.dart';
import 'verifica_cgr_colores.dart';

/// Tarjeta de un contrato.
///
/// Se diferencia de `TramiteCard` en tres campos: No. Certificado en vez de
/// orden de pago, vigencia (rango de fechas) y concepto, que es texto largo y
/// se colapsa a 2 líneas con un "Ver más".
class ContratoCard extends StatelessWidget {
  const ContratoCard({
    super.key,
    required this.contrato,
    this.onDescargar,
    this.onVerConcepto,
  });

  final ContratoEntity contrato;
  final VoidCallback? onDescargar;

  /// Abre el diálogo con el concepto completo.
  final void Function(String concepto)? onVerConcepto;

  @override
  Widget build(BuildContext context) {
    final estado = contrato.estado;
    final concepto = contrato.concepto?.trim() ?? '';
    final conceptoLargo = concepto.length > 80;

    return TarjetaResultado(
      institucion: Formatos.oVacio(contrato.institucion),
      onDescargar: onDescargar,
      hijos: [
        FilaDetalle(
          etiqueta: 'Beneficiario',
          valor: Formatos.oVacio(contrato.beneficiario),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'No. Documento',
          valor: Formatos.oVacio(contrato.documento),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'No. Certificado',
          valor: Formatos.oVacio(contrato.codigo),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Monto',
          valor: Formatos.moneda(contrato.monto, contrato.moneda),
          enfatizarValor: true,
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Vigencia',
          valor: Formatos.rango(contrato.fechaInicio, contrato.fechaFin),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Fecha de registro en Contraloría',
          valor: Formatos.fecha(contrato.fechaRegistro),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Concepto',
          contenido: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatos.capitalizar(concepto),
                maxLines: conceptoLargo ? 2 : null,
                overflow: conceptoLargo ? TextOverflow.ellipsis : null,
                style: const TextStyle(
                  fontSize: 14,
                  color: VerificaCgrColores.texto,
                  height: 1.35,
                ),
              ),
              if (conceptoLargo && onVerConcepto != null)
                InkWell(
                  onTap: () => onVerConcepto!(concepto),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Ver más',
                      style: TextStyle(
                        fontSize: 13,
                        color: VerificaCgrColores.azulBoton,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Estatus',
          contenido: Align(
            alignment: Alignment.centerLeft,
            child: EstadoBadge(estado: estado),
          ),
        ),
        if (estado.requiereContactarInstitucion)
          const AvisoRequiereInformacion(),
      ],
    );
  }
}
