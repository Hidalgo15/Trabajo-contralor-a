import 'package:flutter/material.dart';

import 'Core/Navigation/app_shell.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Theme/fuentes_licencia.dart';
import 'Core/Theme/theme_controller.dart';
import 'Feature/Splash/Presentation/pagina_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registrarLicenciasDeFuentes();
  final tema = await ThemeController.cargar();
  runApp(MiAppContraloria(tema: tema));
}

class MiAppContraloria extends StatelessWidget {
  const MiAppContraloria({super.key, required this.tema});

  final ThemeController tema;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: tema,
      child: ListenableBuilder(
        listenable: tema,
        builder: (context, _) => MaterialApp(
          title: 'Portal Contraloría',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.claro,
          darkTheme: AppTheme.oscuro,
          themeMode: tema.mode,
          home: const _Arranque(),
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: TextScaler.linear(tema.tamanoTexto.escala),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

/// Muestra el splash al abrir y luego cede el paso al [AppShell].
class _Arranque extends StatefulWidget {
  const _Arranque();

  @override
  State<_Arranque> createState() => _ArranqueState();
}

class _ArranqueState extends State<_Arranque> {
  bool _listo = false;

  @override
  Widget build(BuildContext context) {
    if (_listo) return const AppShell();
    return PaginaSplash(onListo: () => setState(() => _listo = true));
  }
}
