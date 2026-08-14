import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';

class RecaptchaWebViewProvider implements CaptchaProvider {
  RecaptchaWebViewProvider({
    required this.siteKey,
    this.dominio = 'consultas.contraloria.gob.do',
    this.accion = 'consulta',
    this.timeout = const Duration(seconds: 20),
  });

  final String siteKey;
  final String dominio;
  final String accion;
  final Duration timeout;

  WebViewController? _controlador;
  WebViewController? get controladorActual => _controlador;

  @override
  void invalidar() {
    _controlador = null;
  }

  @override
  Future<String?> obtenerToken() async {
    final completer = Completer<String?>();

    final controlador = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TokenCaptcha',
        onMessageReceived: (mensaje) {
          if (completer.isCompleted) return;
          final valor = mensaje.message;
          completer.complete(valor.isEmpty ? null : valor);
        },
      );

    _controlador = controlador;

    await controlador.loadHtmlString(_html, baseUrl: 'https://$dominio/');

    try {
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      return null;
    } finally {
      _controlador = null;
    }
  }

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
      if (window.grecaptcha) {
        grecaptcha.ready(function () {
          grecaptcha.execute('$siteKey', { action: '$accion' })
            .then(reportar)
            .catch(function () { reportar(''); });
        });
      } else {
        reportar('');
      }
    </script>
  </body>
</html>
''';
}