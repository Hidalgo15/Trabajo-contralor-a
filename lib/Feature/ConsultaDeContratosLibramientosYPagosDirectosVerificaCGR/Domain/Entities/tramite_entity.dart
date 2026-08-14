import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

enum TipoEstadoTramite { requiereInformacion, rechazado, normal }

class TramiteEntity {
  final String numero;
  final String concepto;
  final String fecha;
  final String estado;
  final double monto;
  final String institucion;
  final TipoEstadoTramite tipoEstado;

  const TramiteEntity({
    required this.numero,
    required this.concepto,
    required this.fecha,
    required this.estado,
    required this.monto,
    required this.institucion,
    required this.tipoEstado,
  });

  factory TramiteEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);
    final estadoTexto = row.texto(['estado', 'estado_tramite', 'estatus'], defecto: 'En proceso');

    return TramiteEntity(
      numero: row.texto(['num_tramite', 'numero', 'numtramite', 'secuencial']),
      concepto: row.texto(['concepto', 'concepto_pago', 'detalle', 'objeto_contratacion']),
      fecha: row.texto(['fecha_registro', 'fecha', 'fecha_ingreso']),
      estado: estadoTexto,
      monto: row.monto(['monto', 'monto_bruto', 'monto_contrato', 'valor']),
      institucion: row.texto(['institucion', 'nombre_institucion', 'capitulo']),
      tipoEstado: _evaluarEstado(estadoTexto),
    );
  }

  static TipoEstadoTramite _evaluarEstado(String texto) {
    final mayus = texto.toUpperCase();
    if (RegExp(r'\bRI\b').hasMatch(mayus)) {
      return TipoEstadoTramite.requiereInformacion;
    }
    if (mayus.contains('RECHAZADO') || mayus.contains('RECHAZO DE TRÁMITE')) {
      return TipoEstadoTramite.rechazado;
    }
    return TipoEstadoTramite.normal;
  }
}