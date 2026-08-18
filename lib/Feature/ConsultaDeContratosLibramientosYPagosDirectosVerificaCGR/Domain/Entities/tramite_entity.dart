import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

import 'estado_tramite.dart';

/// Un libramiento o un pago directo.
///
/// Ambos llegan mezclados en el mismo arreglo `libramientos` de la respuesta;
/// la separacion es responsabilidad del cliente y se hace mirando la columna
/// `sistema` (ver [esLibramiento] / [esPagoDirecto]).
///
/// Las llaves NO son estables: el backend arma estas filas como `dynamic` desde
/// el `DataReader`, asi que son los nombres de columna del stored procedure con
/// su casing original. Por eso todo se lee via [JsonRow] con varios candidatos.
class TramiteEntity {
  const TramiteEntity({
    required this.datos,
    this.institucion,
    this.beneficiario,
    this.documento,
    this.periodo,
    this.numeroOrdenPago,
    this.certificacion,
    this.monto,
    this.moneda,
    this.fechaRegistro,
    this.sistema,
    this.estadoTexto,
  });

  /// Fila cruda, por si el stored procedure agrega columnas nuevas.
  final JsonRow datos;

  final String? institucion;
  final String? beneficiario;
  final String? documento;

  /// Año presupuestario. Llega como entero.
  final String? periodo;
  final String? numeroOrdenPago;

  /// Codigo de la certificacion (p. ej. `ALBS-0067805-2026`). No lo muestra el
  /// portal web en la tabla, pero viene en la respuesta y sirve para el PDF.
  final String? certificacion;

  final num? monto;
  final String? moneda;
  final DateTime? fechaRegistro;
  final String? sistema;
  final String? estadoTexto;

  factory TramiteEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);
    return TramiteEntity(
      datos: row,
      institucion: row.texto(['Institucion']),
      beneficiario: row.texto(['beneficiario']),
      documento: row.texto(['documento']),
      periodo: row.texto(['Periodo']),
      numeroOrdenPago: row.texto(['NumeroOrdenPago']),
      certificacion: row.texto(['certificacion', 'codigo']),
      monto: row.numero(['monto']),
      moneda: row.texto(['moneda']),
      fechaRegistro: row.fecha(['fecha_registro', 'Fecha_Registro']),
      sistema: row.texto(['Sistema']),
      estadoTexto: row.texto(['EstadoTramite', 'estadotramite']),
    );
  }

  EstadoTramite get estado => EstadoTramite.evaluar(estadoTexto);

  bool get esLibramiento =>
      (sistema ?? '').toLowerCase().contains('libramiento');

  bool get esPagoDirecto =>
      (sistema ?? '').toLowerCase().contains('pago directo');
}
