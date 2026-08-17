import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({
    this.baseUrl = 'https://consultas.contraloria.gob.do/verificacgr/api/Consulta/',
    //Prueba de url especifica con rnc de claro
    //this.baseUrl = 'https://consultas.contraloria.gob.do/verificacgr/api/Consulta/GetTramitesProveedor?nodocumento=101001577',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();



  /// Método GET genérico que retorna un JSON deserializado (Map o List)
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
   // 2. Concatenamos base + endpoint y pasamos los queryParams a Uri.https / Uri.parse
    final baseUri = Uri.parse('$baseUrl$endpoint');
    final uri = queryParams != null && queryParams.isNotEmpty
        ? baseUri.replace(queryParameters: queryParams)
        : baseUri;

    try {
      final response = await _httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      );

      return _procesarRespuesta(response);
    } catch (e) {
      throw Exception('Error de red/conexión al servidor: $e');
    }
  }

  /// Método POST genérico
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );

      return _procesarRespuesta(response);
    } catch (e) {
      throw Exception('Error de red/conexión al servidor: $e');
    }
  }

  dynamic _procesarRespuesta(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}