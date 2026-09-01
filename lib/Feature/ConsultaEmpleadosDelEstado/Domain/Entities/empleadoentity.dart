
import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

class EmpleadoEntity {
  const EmpleadoEntity({
    required this.datos,
    required this.cedula,
    required this.nombre,
    required this.institucion,
    required this.funcion,
    required this.salario,
    required this.fechaPeriodo,
    required this.cuenta,
    required this.descripcionCuenta,

  });

  final String? cedula;
  final String? nombre;
  final String? institucion;
  final String? funcion;
 // final num? salario;
  final String? fechaPeriodo;
  final String? cuenta;
  final String? descripcionCuenta;

  final double? salario;  

  final JsonRow datos;
  
  factory EmpleadoEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);
    return EmpleadoEntity(
      datos: row,
      cedula: row.texto(['cedula']),
      nombre: row.texto(['nombre']),
      institucion: row.texto(['institucion']),
      funcion: row.texto(['funcion']),
      salario: row.decimal(['salario']),
      fechaPeriodo: row.texto(['fecha']),
      cuenta: row.texto(['cuenta']),
      descripcionCuenta: row.texto(['descripcion_cuenta']),
    );

  }
}