import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/tramite_entity.dart';
import 'estado_badge.dart';
import 'fila_detalle.dart';

/// Tarjeta de un libramiento o pago directo. Los campos y sus etiquetas son
/// los mismos de la tabla del portal web.
class TramiteCard extends StatelessWidget {
  const TramiteCard({
    super.key,
    required this.tramite,
    this.onDescargar,
  });

  final TramiteEntity tramite;
  final VoidCallback? onDescargar;

  @override
  Widget build(BuildContext context) {
    final estado = tramite.estado;

    return TarjetaResultado(
      institucion: Formatos.oVacio(tramite.institucion),
      onDescargar: onDescargar,
      hijos: [
        FilaDetalle(
          etiqueta: 'Beneficiario',
          valor: Formatos.oVacio(tramite.beneficiario),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'No. Documento',
          valor: Formatos.oVacio(tramite.documento),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Período',
          valor: Formatos.oVacio(tramite.periodo),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'No. Orden de pago',
          valor: Formatos.oVacio(tramite.numeroOrdenPago),
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Monto',
          valor: Formatos.moneda(tramite.monto, tramite.moneda),
          enfatizarValor: true,
        ),
        const DivisorFila(),
        FilaDetalle(
          etiqueta: 'Fecha de registro en Contraloría',
          valor: Formatos.fecha(tramite.fechaRegistro),
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
