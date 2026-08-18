import 'package:flutter/foundation.dart';

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/sin_captcha.dart';
import 'package:consultas_y_contrataciones/Core/NetWork/api_client.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/fase_operacion.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Config/verifica_cgr_config.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Data/verifica_cgr_remote_data_source.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Exceptions/verifica_cgr_exception.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/Interface/iverifica_cgr_repository.dart';

/// Orquesta la consulta: primero la verificacion de seguridad (si esta
/// encendida) y luego la llamada a los datos.
class VerificaCgrRepository implements IVerificaCgrRepository {
  VerificaCgrRepository(
    this.dataSource, {
    this.config = const VerificaCgrConfig(),
    this.captchaProvider = const SinCaptcha(),
  });

  final VerificaCgrRemoteDataSource dataSource;
  final VerificaCgrConfig config;
  final CaptchaProvider captchaProvider;

  /// 9 digitos = RNC, 11 = cedula. Es la misma regla del portal web y evita
  /// gastar una llamada al servicio con un documento que no puede existir.
  static bool documentoValido(String documento) {
    final limpio = soloDigitos(documento);
    return limpio.length == 9 || limpio.length == 11;
  }

  static String soloDigitos(String texto) =>
      texto.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  Future<ConsultaResultadoEntity> consultarTramites(
    String documento, {
    void Function(FaseOperacion fase)? onFase,
  }) async {
    final limpio = soloDigitos(documento);
    if (!documentoValido(limpio)) {
      throw const VerificaCgrException(
        'Ingrese un RNC de 9 dígitos o una cédula de 11 dígitos válida.',
      );
    }

    if (config.validarCaptcha) {
      onFase?.call(FaseOperacion.seguridad);
    }
    await _validarCaptchaSiAplica();

    onFase?.call(FaseOperacion.cargandoDatos);

    final Map<String, dynamic> json;
    try {
      json = await dataSource.obtenerTramites(limpio);
    } on ApiException catch (e) {
      debugPrint(
        'Verifica CGR: fallo GetTramitesProveedor '
        '(HTTP ${e.codigo ?? "sin codigo"}) -> ${e.detalle ?? e.mensaje}',
      );
      throw VerificaCgrException(
        e.mensaje,
        codigo: e.codigo,
        detalle: e.detalle,
      );
    }

    final resultado = ConsultaResultadoEntity.fromJson(json);

    // Si el stored procedure agrega un tipo de sistema nuevo, los registros no
    // se pierden en silencio como en el portal web: quedan reportados aqui.
    if (resultado.sistemasDesconocidos.isNotEmpty) {
      debugPrint(
        'Verifica CGR: valores de "sistema" no reconocidos -> '
        '${resultado.sistemasDesconocidos.toSet().join(", ")}',
      );
    }

    return resultado;
  }

  /// Replica el interceptor de axios del portal web: obtiene un token de
  /// reCAPTCHA v3 y lo valida en el backend antes de dejar pasar la consulta.
  Future<void> _validarCaptchaSiAplica() async {
    if (!config.validarCaptcha) return;

    final token = await captchaProvider.obtenerToken();
    if (token == null || token.isEmpty) {
      // Causas tipicas: el script de Google no cargo (sin red, o la red
      // intercepta TLS y el WebView rechaza el certificado), el WebView no
      // estaba montado, o se agoto el timeout de 20 s.
      debugPrint(
        'Verifica CGR: el WebView no devolvio token de reCAPTCHA. '
        'Revisa que RecaptchaHost este montado y que el dispositivo alcance '
        'https://www.google.com/recaptcha/api.js',
      );
      throw const VerificaCgrException(
        'No se pudo completar la verificación de seguridad. '
        'Verifique su conexión e intente de nuevo.',
      );
    }

    final ResultadoCaptcha resultado;
    try {
      resultado = await dataSource.validarCaptcha(token);
    } on ApiException catch (e) {
      debugPrint(
        'Verifica CGR: fallo POST /validar '
        '(HTTP ${e.codigo ?? "sin codigo"}) -> ${e.detalle ?? e.mensaje}',
      );
      // El token ya viajo: se descarta para que el reintento pida uno nuevo.
      captchaProvider.invalidar();
      throw VerificaCgrException(
        'No se pudo validar la verificación de seguridad.',
        codigo: e.codigo,
        detalle: e.detalle,
      );
    }

    if (!resultado.valido) {
      // El motivo real (score bajo, invalid-input-response,
      // timeout-or-duplicate, browser-error...) solo sale por aqui: al
      // ciudadano se le muestra un mensaje generico a proposito.
      debugPrint(
        'Verifica CGR: reCAPTCHA rechazado por el backend -> '
        '${resultado.mensaje ?? "sin detalle"}',
      );
      // Un token consumido que se reenvia lo rechaza Google por
      // "timeout-or-duplicate", asi que hay que invalidarlo si o si.
      captchaProvider.invalidar();
      throw VerificaCgrException(
        'Su comportamiento fue detectado como inusual. '
        'Intente de nuevo más tarde.',
        detalle: resultado.mensaje,
      );
    }
  }
}
