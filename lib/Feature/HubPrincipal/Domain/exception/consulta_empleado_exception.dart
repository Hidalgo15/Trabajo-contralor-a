
/// Error de dominio de la consulta Verifica CGR.
///
/// [mensaje] ya viene redactado para mostrarse al ciudadano. [detalle] es para
/// logs y NO debe mostrarse: puede traer el stack trace del backend.
class ConsultaEmpleadoException implements Exception {
  const ConsultaEmpleadoException(this.mensaje, {this.codigo, this.detalle});

  final String mensaje;
  final int? codigo;
  final String? detalle;

  @override
  String toString() =>
      'ConsultaEmpleadoException($codigo): $mensaje${detalle == null ? '' : ' | $detalle'}';
}
