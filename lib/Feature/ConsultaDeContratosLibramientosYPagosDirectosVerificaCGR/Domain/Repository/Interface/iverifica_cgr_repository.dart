import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';

/// Etapas de la consulta, para que la pantalla pueda decirle al usuario en qué
/// va. La verificación de seguridad puede tardar varios segundos (WebView +
/// Google + backend), así que dejarla sin explicar se siente como un cuelgue.
enum FaseConsulta {
  verificandoSeguridad,
  consultandoTramites,
}

abstract class IVerificaCgrRepository {
  /// Lanza `VerificaCgrException` con un mensaje ya listo para mostrar.
  ///
  /// Que el resultado venga vacío NO es un error: significa que el proveedor
  /// no tiene trámites pendientes.
  Future<ConsultaResultadoEntity> consultarTramites(
    String documento, {
    void Function(FaseConsulta fase)? onFase,
  });
}
