import 'TramiteEntity.dart';

class ConsultaResultadoEntity {
  final String rncCedula;
  final String nombreProveedor;
  final List<TramiteEntity> tramites;

  const ConsultaResultadoEntity({
    required this.rncCedula,
    required this.nombreProveedor,
    required this.tramites,
  });

  factory ConsultaResultadoEntity.fromJson(Map<String, dynamic> json) {
    var list = json['tramites'] as List? ?? [];
    List<TramiteEntity> tramitesList =
        list.map((i) => TramiteEntity.fromJson(i)).toList();

    return ConsultaResultadoEntity(
      rncCedula: json['rnc_cedula'] ?? '',
      nombreProveedor: json['nombre_proveedor'] ?? '',
      tramites: tramitesList,
    );
  }
}