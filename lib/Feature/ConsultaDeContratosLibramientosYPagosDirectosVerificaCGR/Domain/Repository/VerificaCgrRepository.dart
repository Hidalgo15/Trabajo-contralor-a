import 'package:consultas_y_contrataciones/Core/GenericRepository/GenericRepository.dart';
import 'package:consultas_y_contrataciones/Core/Network/ApiClient.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/ConsultaResultadoEntity.dart';


class VerificaCgrRepository extends GenericRepository<ConsultaResultadoEntity> {
  
  VerificaCgrRepository(ApiClient apiClient) : super(apiClient);

  /// Realiza la consulta enviando el documento y mapea la respuesta a ConsultaResultadoEntity
  Future<ConsultaResultadoEntity> consultarPorDocumento(String documento) async {
    return await fetchOne(
      '/consultas/verifica-cgr', // Endpoint específico de esta consulta
      queryParams: {'documento': documento},
      fromJson: (json) => ConsultaResultadoEntity.fromJson(json),
    );
  }
}