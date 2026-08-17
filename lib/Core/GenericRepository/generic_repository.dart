import 'package:consultas_y_contrataciones/Core/Network/api_client.dart';

abstract class GenericRepository<T> {
  final ApiClient apiClient;

  GenericRepository(this.apiClient);

  /// Método genérico para consultar un recurso por parámetros/filtros
  Future<T> fetchOne(
    String endpoint, {
    Map<String, String>? queryParams,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final response = await apiClient.get(endpoint, queryParams: queryParams);
    if (response is Map<String, dynamic>) {
      return fromJson(response);
    }
    throw Exception('Formato de respuesta inesperado');
  }

  /// Método genérico para consultar listas de recursos
  Future<List<T>> fetchList(
    String endpoint, {
    Map<String, String>? queryParams,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final response = await apiClient.get(endpoint, queryParams: queryParams);
    if (response is List) {
      return response.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Formato de lista de datos inesperado');
  }
}