import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';

class RecaptchaHost extends StatelessWidget {
  const RecaptchaHost({super.key, required this.controlador});

  final WebViewController controlador;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 0,
        height: 0,
        child: WebViewWidget(controller: controlador),
      );
}