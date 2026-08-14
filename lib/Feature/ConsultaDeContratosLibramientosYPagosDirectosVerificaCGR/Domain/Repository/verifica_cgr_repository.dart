import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/sin_captcha.dart';
import 'package:consultas_y_contrataciones/Core/Network/ApiClient.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';


class VerificaCgrRepository {
  final ApiClient apiClient;
  final CaptchaProvider captchaProvider;

  VerificaCgrRepository(
    this.apiClient, {
    this.captchaProvider = const SinCaptcha(), // Default como indica la guía
  });

  Future<ConsultaResultadoEntity> consultarTramites(String documento) async {
    // 1. Obtener token del proveedor (si es SinCaptcha devuelve null, si es Recaptcha devuelve el token o lo busca en cache)
    final token = await captchaProvider.obtenerToken();

    // 2. Realizar la petición
    // Nota: Como explica la guía, GetTramitesProveedor responde directamente
    final response = await apiClient.get(
      '/Consulta/GetTramitesProveedor',
      queryParams: {'rncCedula': documento},
      // headers: token != null ? {'X-Captcha-Token': token} : null,
    );

    return ConsultaResultadoEntity.fromJson(response);
  }
}