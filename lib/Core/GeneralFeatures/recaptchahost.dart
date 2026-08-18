import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:consultas_y_contrataciones/Core/Captcha/recaptcha_web_view_provider.dart';

/// Monta un WebView de 0x0 mientras el proveedor esta ejecutando el captcha.
///
/// En Android el WebView solo corre JavaScript cuando su vista existe en el
/// arbol de widgets. Este widget escucha `provider.controlador` y monta la
/// vista justo durante la ejecucion, sin ocupar espacio ni ser visible.
///
/// Se coloca dentro de un `Stack` en la pantalla que dispara la consulta.
class RecaptchaHost extends StatelessWidget {
  const RecaptchaHost({super.key, required this.provider});

  final RecaptchaWebViewProvider provider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WebViewController?>(
      valueListenable: provider.controlador,
      builder: (context, controlador, _) {
        if (controlador == null) return const SizedBox.shrink();
        return SizedBox(
          width: 0,
          height: 0,
          child: WebViewWidget(controller: controlador),
        );
      },
    );
  }
}
