import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificaCgrRemoteDataSource {
  final String baseUrl;

  VerificaCgrRemoteDataSource({
    this.baseUrl = 'https://servicios.contraloria.gob.do/api/v1/consulta', // Reemplaza por la URL real
  });

  Future<Map<String, dynamic>> fetchConsulta(String documento) async {
    final response = await http.get(
      Uri.parse('$baseUrl?documento=$documento'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al conectar con la Contraloría (${response.statusCode})');
    }
  }
}