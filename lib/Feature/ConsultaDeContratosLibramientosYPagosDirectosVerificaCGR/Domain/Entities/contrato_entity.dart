import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

import 'estado_tramite.dart';

/// Un contrato registrado en Contraloria.
///
/// Se diferencia del libramiento en tres campos: No. Certificado en vez de
/// orden de pago, vigencia (rango de fechas) y concepto. Ademas usa una columna
/// de moneda distinta a la de los pagos (`contrato_moneda`).
///
/// El documento de prueba disponible no tenia contratos, asi que estos nombres
/// de columna vienen de leer el frontend web y el backend, no de una respuesta
/// capturada. [JsonRow] acepta varios candidatos por campo justo por eso; si
/// aparece un contrato y algun dato sale vacio, revisar `datos.raw`.
class ContratoEntity {
  const ContratoEntity({
    required this.datos,
    this.institucion,
    this.beneficiario,
    this.documento,
    this.codigo,
    this.monto,
    this.moneda,
    this.concepto,
    this.fechaInicio,
    this.fechaFin,
    this.fechaRegistro,
    this.estadoTexto,
  });

  final JsonRow datos;

  final String? institucion;
  final String? beneficiario;
  final String? documento;

  /// No. de certificado del contrato.
  final String? codigo;
  final num? monto;
  final String? moneda;
  final String? concepto;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final DateTime? fechaRegistro;
  final String? estadoTexto;

  factory ContratoEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);
    return ContratoEntity(
      datos: row,
      institucion: row.texto(['Institucion']),
      beneficiario: row.texto(['beneficiario']),
      documento: row.texto(['documento']),
      codigo: row.texto(['codigo', 'certificacion']),
      monto: row.numero(['monto', 'Monto']),
      // Los contratos usan una columna de moneda distinta a la de los pagos.
      moneda: row.texto(['contrato_moneda', 'moneda']),
      concepto: row.texto(['concepto']),
      fechaInicio: row.fecha(['Fecha_inicio', 'fecha_inicio']),
      fechaFin: row.fecha(['Fecha_fin', 'fecha_fin']),
      fechaRegistro: row.fecha(['fecha_registro', 'Fecha_Registro']),
      estadoTexto: row.texto(['EstadoTramite', 'estadotramite']),
    );
  }

  EstadoTramite get estado => EstadoTramite.evaluar(estadoTexto);
}
