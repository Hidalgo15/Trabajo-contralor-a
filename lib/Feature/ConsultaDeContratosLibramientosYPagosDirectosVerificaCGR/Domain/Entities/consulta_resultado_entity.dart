import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

import 'tramite_entity.dart';

class ConsultaResultadoEntity {
  final String rncCedula;
  final String nombreProveedor;
  final bool rpeInhabilitado;
  final List<TramiteEntity> libramientos;
  final List<TramiteEntity> pagosDirectos;
  final List<TramiteEntity> contratos;

  const ConsultaResultadoEntity({
    required this.rncCedula,
    required this.nombreProveedor,
    required this.rpeInhabilitado,
    required this.libramientos,
    required this.pagosDirectos,
    required this.contratos,
  });

  bool get estaVacio =>
      libramientos.isEmpty && pagosDirectos.isEmpty && contratos.isEmpty;

  factory ConsultaResultadoEntity.fromJson(Map<String, dynamic> json) {
    // 1. Extraer Proveedor
    final provRaw = json['proveedor'] as Map<String, dynamic>? ?? {};
    final provRow = JsonRow(provRaw);

    // 2. Extraer Listas
    List<TramiteEntity> mapearLista(String key) {
      final list = json[key] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((item) => TramiteEntity.fromJson(item))
          .toList();
    }

    return ConsultaResultadoEntity(
      rncCedula: provRow.texto(['rnc_cedula', 'rncCedula', 'rnc', 'cedula']),
      nombreProveedor: provRow.texto(['razon_social', 'nombreProveedor', 'nombre']),
      rpeInhabilitado: provRow.texto(['estado_rpe', 'estadoRpe']).toUpperCase() == 'INHABILITADO',
      libramientos: mapearLista('libramientos'),
      pagosDirectos: mapearLista('pagosDirectos'),
      contratos: mapearLista('contratos'),
    );
  }
}