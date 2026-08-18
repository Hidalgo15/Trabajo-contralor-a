import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';

/// Ejecuta reCAPTCHA v3 dentro de un WebView invisible y devuelve el token.
///
/// Por que hace falta este rodeo: la clave del proyecto es de tipo
/// **reCAPTCHA v3 web**, que es una libreria JavaScript de navegador. En una
/// app Flutter nativa no existe `window.grecaptcha` y esa clave NO tiene un SDK
/// nativo equivalente. Ejecutar el mismo JS en un WebView fuera de pantalla es
/// la unica forma de reutilizar la clave del portal sin tocar el backend.
///
/// Google no documenta este camino como soportado para apps nativas: funciona,
/// pero es fragil ante cambios de su lado. La alternativa correcta a mediano
/// plazo es migrar a reCAPTCHA Enterprise, que si tiene SDK nativo, pero eso
/// obliga a crear una clave Android/iOS y a que el backend valide contra la
/// API de Enterprise en vez de `siteverify`.
class RecaptchaWebViewProvider implements CaptchaProvider {
  RecaptchaWebViewProvider({
    required this.siteKey,

    /// Dominio con el que se sirve la pagina interna del WebView. TIENE que
    /// estar registrado en la consola de reCAPTCHA para esta clave; si no,
    /// Google responde `invalid-domain` y el token nunca llega.
    this.dominio = 'consultas.contraloria.gob.do',
    this.accion = 'consulta',
    this.timeout = const Duration(seconds: 20),
  });

  final String siteKey;
  final String dominio;
  final String accion;
  final Duration timeout;

  /// Controlador de la ejecucion en curso.
  ///
  /// Es un [ValueNotifier] y no un campo suelto a proposito: en Android el
  /// WebView solo ejecuta JavaScript cuando su vista esta montada en el arbol
  /// de widgets. La pantalla escucha esto (via `RecaptchaHost`) para montar un
  /// WebView de 0x0 justo mientras corre el captcha y desmontarlo al terminar.
  final ValueNotifier<WebViewController?> controlador =
      ValueNotifier<WebViewController?>(null);

  @override
  void invalidar() {
    controlador.value = null;
  }

  @override
  Future<String?> obtenerToken() async {
    final completer = Completer<String?>();

    final nuevoControlador = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TokenCaptcha',
        onMessageReceived: (mensaje) {
          if (completer.isCompleted) return;
          final valor = mensaje.message;
          completer.complete(valor.isEmpty ? null : valor);
        },
      );

    // Se publica ANTES de cargar el HTML para que el host alcance a montarse
    // mientras el script de Google viaja por la red.
    controlador.value = nuevoControlador;

    try {
      // `baseUrl` es lo que Google ve como origen de la pagina. Sin esto el
      // origen seria `about:blank` y la validacion de dominio falla.
      await nuevoControlador.loadHtmlString(_html, baseUrl: 'https://$dominio/');
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    } finally {
      controlador.value = null;
    }
  }

  // El notifier no se libera a proposito: la pantalla que lo escucha se
  // desuscribe sola al hacer dispose, y llamar `dispose()` aqui reventaria si
  // quedara una ejecucion de captcha en vuelo intentando limpiar el valor.

  String get _html => '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://www.google.com/recaptcha/api.js?render=$siteKey"></script>
  </head>
  <body>
    <script>
      function reportar(valor) {
        try { TokenCaptcha.postMessage(valor || ''); } catch (e) {}
      }
      // El script de Google puede no haber terminado de cargar cuando corre
      // este bloque; por eso se reintenta en vez de reportar vacio de una.
      function ejecutar(intentos) {
        if (window.grecaptcha && window.grecaptcha.execute) {
          grecaptcha.ready(function () {
            grecaptcha.execute('$siteKey', { action: '$accion' })
              .then(reportar)
              .catch(function () { reportar(''); });
          });
        } else if (intentos > 0) {
          setTimeout(function () { ejecutar(intentos - 1); }, 200);
        } else {
          reportar('');
        }
      }
      ejecutar(50);
    </script>
  </body>
</html>
''';
}
