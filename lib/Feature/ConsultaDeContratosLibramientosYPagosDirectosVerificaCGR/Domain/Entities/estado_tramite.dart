/// Clasificacion del texto libre que devuelve la columna `EstadoTramite`.
///
/// El backend no devuelve un codigo de estado: devuelve la descripcion que
/// arma el stored procedure `usp_consulta_estado_del_tramite`. Valores reales
/// observados: "En Unidad de Auditoría", "En sede Contraloría", "En proceso de
/// evaluación", "Requerimiento de Información (RI)", "Devuelto a la institución
/// por requerimiento de información (RI)" y `null`.
///
/// La logica replica la del portal web (`evaluarEstadoTramite` en
/// `ConsultaInicio.vue`): si cambia una, hay que cambiar la otra.
enum TipoEstadoTramite {
  /// Estado informativo, sin alerta.
  normal,

  /// Requiere informacion: el texto contiene "RI" como palabra aislada.
  requiereInformacion,

  /// Rechazado o rechazo de tramite.
  rechazado,
}

class EstadoTramite {
  const EstadoTramite(this.tipo, this.mensaje);

  final TipoEstadoTramite tipo;

  /// El texto original tal cual lo manda el backend. No se traduce ni se
  /// normaliza: es lo que el ciudadano debe ver.
  final String mensaje;

  /// `RI` como palabra completa. El `\b` es intencional: sin el, un estado
  /// como "REGISTRADO" daria falso positivo de RI.
  static final RegExp _patronRi = RegExp(r'\bRI\b');

  factory EstadoTramite.evaluar(String? estado) {
    final original = estado?.trim() ?? '';
    if (original.isEmpty) {
      return const EstadoTramite(TipoEstadoTramite.normal, '—');
    }

    final texto = original.toUpperCase();

    if (_patronRi.hasMatch(texto)) {
      return EstadoTramite(TipoEstadoTramite.requiereInformacion, original);
    }
    if (texto.contains('RECHAZADO') || texto.contains('RECHAZO DE TRÁMITE')) {
      return EstadoTramite(TipoEstadoTramite.rechazado, original);
    }
    return EstadoTramite(TipoEstadoTramite.normal, original);
  }

  /// Cuando es `true` la tarjeta muestra el aviso de contactar a la
  /// institucion contratante.
  bool get requiereContactarInstitucion => tipo != TipoEstadoTramite.normal;
}
