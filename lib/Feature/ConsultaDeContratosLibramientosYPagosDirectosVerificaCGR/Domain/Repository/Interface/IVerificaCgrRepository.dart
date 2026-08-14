import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/ConsultaResultadoEntity.dart';

abstract class IVerificaCgrRepository {
  Future<ConsultaResultadoEntity> consultarTramites(String documento);
}