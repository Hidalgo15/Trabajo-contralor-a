/// Configuracion de la consulta Verifica CGR.
///
/// La pantalla crea una instancia y se la pasa al repositorio. Si algun dia
/// hace falta apuntar a otro ambiente basta con construir otra config.
class VerificaCgrConfig {
  const VerificaCgrConfig({
    this.baseUrl = produccion,
    this.recaptchaSiteKey = siteKeyPublica,
    this.validarCaptcha = false,
    this.timeout = const Duration(seconds: 60),
  });

  /// Produccion. El sitio esta publicado bajo la subcarpeta `/verificacgr` en
  /// IIS y la API cuelga de ahi, NO de la raiz del dominio. Olvidar esa
  /// subcarpeta es el error mas comun al integrar.
  static const String produccion =
      'https://consultas.contraloria.gob.do/verificacgr';

  /// Servidor interno. Solo alcanzable desde la red de la CGR o por VPN, no
  /// sirve para un APK instalado fuera de la institucion. Ademas es HTTP en
  /// claro: Android 9+ lo bloquea sin un `network_security_config`.
  static const String interno = 'http://192.168.3.95/verificacgr';

  /// Clave PUBLICA de reCAPTCHA v3, la misma que usa el portal web. Es publica
  /// por diseño: viaja en el HTML de cualquier sitio que use reCAPTCHA, asi
  /// que puede vivir en el APK.
  ///
  /// La clave SECRETA jamas debe empaquetarse aqui: solo el backend la usa,
  /// contra `https://www.google.com/recaptcha/api/siteverify`. Si se empaqueta,
  /// cualquiera que descompile el APK puede validar tokens en nombre de la CGR
  /// y el control deja de servir.
  static const String siteKeyPublica = '6LcAQRQsAAAAAFmZjRHuBuRw8YYbfWv5ReY6mZEK';

  static const String endpointTramites = '/api/Consulta/GetTramitesProveedor';
  static const String endpointValidarCaptcha = '/api/Consulta/validar';

  /// Nombre del parametro de consulta. La API espera `nodocumento`.
  static const String parametroDocumento = 'nodocumento';

  final String baseUrl;
  final String recaptchaSiteKey;

  /// Si es `true`, antes de cada consulta se obtiene un token de reCAPTCHA y
  /// se valida contra `POST /api/Consulta/validar`, igual que el portal web.
  ///
  /// **Viene apagado, y no es un descuido.** Se probo encendido en un
  /// dispositivo real y Google rechazo el token al primer intento
  /// (`success: false`, "Captcha no valido o sospechoso"). La causa de fondo
  /// es que la clave del proyecto es de tipo **reCAPTCHA v3 web**, una
  /// libreria de navegador: en una app nativa no hay `window.grecaptcha` y
  /// ejecutarla dentro de un WebView invisible es un camino que Google no
  /// documenta ni soporta. Una pagina en blanco, sin interaccion ni historial,
  /// no le genera senales de confianza.
  ///
  /// Apagarlo no quita seguridad que hoy exista: `GetTramitesProveedor` es
  /// `[AllowAnonymous]` y NO verifica ningun token del lado del servidor. El
  /// captcha del portal web es un control de cliente (un interceptor de axios
  /// que llama a `/validar` por su cuenta), asi que cualquiera con `curl` ya
  /// puede consultar el endpoint sin pasar por Google. Bloquear al ciudadano
  /// por un captcha que el servidor no exige le quitaba el servicio sin
  /// proteger nada.
  ///
  /// Si algun dia se quiere de verdad, hay dos caminos y ninguno es de app:
  /// exigir el token en el mismo request de datos y validarlo en
  /// `ConsultaController` antes de tocar la base, o migrar a reCAPTCHA
  /// Enterprise, que si tiene SDK nativo para Android/iOS pero requiere una
  /// clave distinta y que el backend valide contra otra API.
  ///
  /// La maquinaria quedo completa y probada por si se retoma: basta con
  /// construir la pantalla con
  /// `PaginaVerificaCgr(config: VerificaCgrConfig(validarCaptcha: true))`.
  final bool validarCaptcha;

  final Duration timeout;

  VerificaCgrConfig copyWith({
    String? baseUrl,
    String? recaptchaSiteKey,
    bool? validarCaptcha,
    Duration? timeout,
  }) {
    return VerificaCgrConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      recaptchaSiteKey: recaptchaSiteKey ?? this.recaptchaSiteKey,
      validarCaptcha: validarCaptcha ?? this.validarCaptcha,
      timeout: timeout ?? this.timeout,
    );
  }
}
