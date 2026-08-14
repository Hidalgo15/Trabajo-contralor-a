

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';

class CaptchaCacheado implements CaptchaProvider {
  CaptchaCacheado(
    this._interno, {
    this.duracion = const Duration(minutes: 5),
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