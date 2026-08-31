import 'package:flutter/material.dart';

import 'Core/Navigation/app_shell.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Theme/fuentes_licencia.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registrarLicenciasDeFuentes();
  runApp(const MiAppContraloria());
}

class MiAppContraloria extends StatelessWidget {
  const MiAppContraloria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Contraloría',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}
