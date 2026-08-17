import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

/// Datos del proveedor.
///
/// A diferencia de los tramites, este SI es un objeto tipado en el backend, asi
/// que ASP.NET le aplica su politica camelCase y las llaves son estables:
/// `documento`, `rpe`, `nombre`, `tipoDocumento`, `fechaUltimaActualizacion`,
/// `estadoRpe`, `motivoInhabilitacion`.
///
/// Un documento inexistente no es un error: la API responde 200 con estos
/// campos en nulos.
class ProveedorEntity {
  const ProveedorEntity({
    this.documento,
    this.rpe,
    this.nombre,
    this.tipoDocumento,
    this.fechaUltimaActualizacion,
    this.estadoRpe,
    this.motivoInhabilitacion,
  });

  final String? documento;
  final String? rpe;
  final String? nombre;
  final String? tipoDocumento;
  final String? fechaUltimaActualizacion;
  final String? estadoRpe;
  final String? motivoInhabilitacion;

  factory ProveedorEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);
    return ProveedorEntity(
      documento: row.texto(['documento']),
      rpe: row.texto(['rpe']),
      nombre: row.texto(['nombre']),
      tipoDocumento: row.texto(['tipoDocumento']),
      fechaUltimaActualizacion: row.texto(['fechaUltimaActualizacion']),
      estadoRpe: row.texto(['estadoRpe']),
      motivoInhabilitacion: row.texto(['motivoInhabilitacion']),
    );
  }

  /// El RPE inhabilitado no bloquea la consulta: solo agrega un aviso cuando
  /// ademas no hay ningun tramite que mostrar.
  bool get rpeInhabilitado => estadoRpe?.trim().toLowerCase() == 'inhabilitado';

  /// "RNC" o "Cédula" segun el largo, igual que en el portal web.
  String get tipoDocumentoInferido =>
      (documento?.trim().length ?? 0) == 9 ? 'RNC' : 'Cédula';
}
