
import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';

class SinCaptcha implements CaptchaProvider {
  const SinCaptcha();

  @override
  Future<String?> obtenerToken() async => null;

  @override
  void invalidar() {}
}