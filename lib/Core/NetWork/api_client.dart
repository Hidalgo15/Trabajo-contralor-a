import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Error de red o de HTTP ya traducido a un mensaje mostrable al ciudadano.
///
/// [detalle] es solo para logs: el backend puede devolver el stack trace en el
/// cuerpo del 500 y eso no se le enseña al usuario.
class ApiException implements Exception {
  const ApiException(this.mensaje, {this.codigo, this.detalle});

  final String mensaje;

  /// Codigo HTTP cuando aplica.
  final int? codigo;

  /// Detalle tecnico. Nunca se muestra en pantalla.
  final String? detalle;

  @override
  String toString() =>
      'ApiException($codigo): $mensaje${detalle == null ? '' : ' | $detalle'}';
}

/// Cliente HTTP generico de la app.
///
/// [baseUrl] va SIN barra final y los endpoints se pasan con barra inicial
/// (`/api/Consulta/GetTramitesProveedor`). El armado normaliza ambos extremos
/// para que no se cuelen dobles barras.
///
/// Ojo con la subcarpeta `/verificacgr`: el sitio esta publicado bajo esa ruta
/// en IIS y la API cuelga de ahi, no de la raiz del dominio.
class ApiClient {
  ApiClient({
    this.baseUrl = 'https://consultas.contraloria.gob.do/verificacgr',
    this.timeout = const Duration(seconds: 60),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;

  /// El endpoint de tramites ejecuta tres consultas a SQL mas una por cada
  /// tramite encontrado: con proveedores grandes tarda. 60 s es el mismo
  /// timeout que usa el portal web.
  final Duration timeout;

  final http.Client _httpClient;

  Uri _construirUri(String endpoint, Map<String, String>? queryParams) {
    final base =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final ruta = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$base$ruta');

    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(queryParameters: queryParams);
  }

  /// GET generico. Devuelve el JSON deserializado (Map o List).
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _construirUri(endpoint, queryParams);

    final http.Response respuesta;
    try {
      respuesta = await _httpClient
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              ...?headers,
            },
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const ApiException(
        'La consulta tardó demasiado. Verifique su conexión e intente nuevamente.',
      );
    } catch (e) {
      throw ApiException(
        'No se pudo conectar con el servicio de consulta.',
        detalle: e.toString(),
      );
    }

    return _procesarRespuesta(respuesta);
  }

  /// POST generico con cuerpo JSON.
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _construirUri(endpoint, null);

    final http.Response respuesta;
    try {
      respuesta = await _httpClient
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              ...?headers,
            },
            body: jsonEncode(body ?? const <String, dynamic>{}),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const ApiException(
        'La solicitud tardó demasiado. Verifique su conexión e intente nuevamente.',
      );
    } catch (e) {
      throw ApiException(
        'No se pudo conectar con el servicio.',
        detalle: e.toString(),
      );
    }

    return _procesarRespuesta(respuesta);
  }

  dynamic _procesarRespuesta(http.Response respuesta) {
    final cuerpo = decodificar(respuesta);

    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw ApiException(
        'No se pudo completar la consulta, por favor intente nuevamente.',
        codigo: respuesta.statusCode,
        detalle: respuesta.body,
      );
    }

    return cuerpo;
  }

  /// Decodifica forzando UTF-8 en vez de confiar en el charset del header:
  /// IIS a veces lo omite y los acentos de "En Unidad de Auditoría" o
  /// "Requerimiento de Información" llegarian corruptos.
  static dynamic decodificar(http.Response respuesta) {
    if (respuesta.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(respuesta.bodyBytes));
    } catch (_) {
      return null;
    }
  }

  void cerrar() => _httpClient.close();
}
