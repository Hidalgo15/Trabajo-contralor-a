import 'package:consultas_y_contrataciones/Core/NetWork/api_client.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Config/verifica_cgr_config.dart';

/// Acceso HTTP a la API de Verifica CGR. Es la unica clase de la consulta que
/// sabe de endpoints y de nombres de parametros.
class VerificaCgrRemoteDataSource {
  const VerificaCgrRemoteDataSource({
    required this.apiClient,
    this.config = const VerificaCgrConfig(),
  });

  final ApiClient apiClient;
  final VerificaCgrConfig config;

  /// `GET /api/Consulta/GetTramitesProveedor?nodocumento=...`
  ///
  /// El endpoint es anonimo (`[AllowAnonymous]`) y no pide encabezados.
  /// Responde 200 aunque el proveedor no tenga tramites o el documento no
  /// exista: eso NO es un error, es un resultado vacio legitimo.
  Future<Map<String, dynamic>> obtenerTramites(String documento) async {
    final respuesta = await apiClient.get(
      VerificaCgrConfig.endpointTramites,
      queryParams: {VerificaCgrConfig.parametroDocumento: documento},
    );

    if (respuesta is! Map<String, dynamic>) {
      throw const ApiException('El servicio devolvió una respuesta inesperada.');
    }

    return respuesta;
  }

  /// `POST /api/Consulta/validar` con `{ "token": "..." }`.
  ///
  /// El backend llama a Google con la clave secreta y devuelve
  /// `{ valido, success, score, errorCodes, mensaje }`. `valido` es `true`
  /// solo si Google respondio `success` Y el score es >= 0.5; es el unico
  /// campo que hay que leer.
  Future<ResultadoCaptcha> validarCaptcha(String token) async {
    final respuesta = await apiClient.post(
      VerificaCgrConfig.endpointValidarCaptcha,
      body: {'token': token},
    );

    if (respuesta is! Map) {
      return const ResultadoCaptcha(valido: false);
    }

    return ResultadoCaptcha(
      valido: respuesta['valido'] == true,
      mensaje: respuesta['mensaje']?.toString(),
    );
  }
}

class ResultadoCaptcha {
  const ResultadoCaptcha({required this.valido, this.mensaje});

  final bool valido;

  /// Detalle tecnico que devuelve el backend (score, error-codes). Solo para
  /// logs: al ciudadano se le muestra un mensaje generico.
  final String? mensaje;
}
