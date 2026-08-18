enum FaseConsulta {
  verificandoSeguridad,
  consultandoTramites,
}

  /// Lanza `VerificaCgrException` con un mensaje ya listo para mostrar.
abstract class IVerificaCgrRepository <T> {
  ///
  /// Que el resultado venga vacío NO es un error: significa que el proveedor
  /// no tiene trámites pendientes.
  Future<T> consultarTramites(
    String documento, {
    void Function(FaseConsulta fase)? onFase,
  });
}