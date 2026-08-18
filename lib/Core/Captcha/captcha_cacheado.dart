

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';

/// Envoltura que evita disparar varias ejecuciones simultaneas del captcha
/// cuando el usuario toca "Buscar" repetidamente: todos los llamadores que
/// lleguen mientras hay una ejecucion en vuelo esperan la misma.
///
/// **Ojo con [duracion].** Un token de reCAPTCHA v3 es de UN SOLO USO y expira
/// a los 2 minutos: Google solo lo acepta en una llamada a `siteverify`, y
/// cualquier reintento con el mismo token responde `success: false` con
/// `timeout-or-duplicate`. Por eso el valor por defecto es cero: reutilizar un
/// token no es una optimizacion, es un fallo garantizado.
///
/// El portal web cachea 5 minutos (`api.js`), asi que arrastra ese mismo
/// problema en su segunda consulta seguida. No se replico a proposito.
class CaptchaCacheado implements CaptchaProvider {
  CaptchaCacheado(
    this._interno, {
    this.duracion = Duration.zero,
  });

  final CaptchaProvider _interno;
  final Duration duracion;

  String? _token;
  DateTime? _obtenidoEn;
  Future<String?>? _enVuelo;

  @override
  Future<String?> obtenerToken() {
    final token = _token;
    final obtenidoEn = _obtenidoEn;
    if (token != null &&
        obtenidoEn != null &&
        DateTime.now().difference(obtenidoEn) < duracion) {
      return Future.value(token);
    }

    final enVuelo = _enVuelo;
    if (enVuelo != null) return enVuelo;

    final futuro = _interno.obtenerToken().then((nuevo) {
      _token = nuevo;
      _obtenidoEn = DateTime.now();
      return nuevo;
    }).whenComplete(() {
      _enVuelo = null;
    });

    _enVuelo = futuro;
    return futuro;
  }

  @override
  void invalidar() {
    _token = null;
    _obtenidoEn = null;
    _interno.invalidar();
  }
}