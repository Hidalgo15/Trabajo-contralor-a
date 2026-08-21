import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/empleadoentity.dart';

class ConsultaEmpleadoResponseModel {
  const ConsultaEmpleadoResponseModel({
    this.cedula,
    this.nombre,
    required this.detalles,
  });

  final String? cedula;
  final String? nombre;
  final List<EmpleadoEntity> detalles;


  factory ConsultaEmpleadoResponseModel.fromJson(Map<String, dynamic> json) {
    final rawDetalles = json['Detalle'] as List<dynamic>? ?? [];
    return ConsultaEmpleadoResponseModel(
      cedula: json['Cedula'] as String?,
      nombre: json['Nombre'] as String?,
      detalles: rawDetalles
          .map((e) => EmpleadoEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}