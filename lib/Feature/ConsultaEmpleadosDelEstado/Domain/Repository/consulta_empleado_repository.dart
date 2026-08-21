

import 'dart:convert';

import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/consulta_empleado_response_model.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Repository/Interfaces/iconsulta_empleado_respository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/exception/consulta_empleado_exception.dart';
import 'package:http/http.dart' as http;

class ConsultaEmpleadoRepository implements IconsultaEmpleadoRespository {
  ConsultaEmpleadoRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl =
      'https://consultas.contraloria.gob.do/consultawscgr/api/consulta/GetConsultaEmpleado';

  @override
  Future<ConsultaEmpleadoResponseModel> obtenerEmpleado(String cedula) async {
    try {
      final uri = Uri.parse('$_baseUrl?cedula=${cedula.trim()}');
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        // La API a veces devuelve un JSON serializado dentro de un String directo
        final dynamic rawBody = jsonDecode(response.body);
        final Map<String, dynamic> jsonMap =
            rawBody is String ? jsonDecode(rawBody) : rawBody;

        final model = ConsultaEmpleadoResponseModel.fromJson(jsonMap);

        if (model.detalles.isEmpty) {
          throw const ConsultaEmpleadoException(
            'No se encontraron registros de empleados para la cédula ingresada.',
            codigo: 404,
          );
        }

        return model;
      } else {
        throw ConsultaEmpleadoException(
          'Error en el servidor de Contraloría (${response.statusCode}).',
          codigo: response.statusCode,
        );
      }
    } on ConsultaEmpleadoException {
      rethrow;
    } catch (e) {
      throw ConsultaEmpleadoException(
        'Ocurrió un fallo de conexión al consultar el empleado.',
        detalle: e.toString(),
      );
    }
  }
}