import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';

abstract class IVerificaCgrRepository {
  Future<ConsultaResultadoEntity> consultarTramites(String documento);
}