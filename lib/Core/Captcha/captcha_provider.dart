

abstract class CaptchaProvider {
  Future<String?> obtenerToken();
  void invalidar();
}