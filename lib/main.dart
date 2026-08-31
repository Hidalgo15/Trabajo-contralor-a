import 'package:consultas_y_contrataciones/Feature/HubPrincipal/Presentation/hub_principal_screen.dart';
import 'package:flutter/material.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Theme/fuentes_licencia.dart';
import 'Feature/ConsultaDeCertificaciónDeCargos/Presentation/paginaconsultacontraloria.dart';
import 'Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaverificacgr.dart';
import 'Feature/ConsultaEmpleadosDelEstado/Presentation/paginaconsultaempleados.dart';
import 'Feature/ConsultaCorrespondencia/Presentation/paginaconsultacorrespondencia.dart';
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
      // Ruta inicial al abrir la App
      initialRoute: '/',
      routes: {
        '/': (context) => const HubPrincipalScreen(),
        '/certificacion-cargos': (context) => const PaginaConsultaContraloria(),
        '/verifica-cgr': (context) => const PaginaVerificaCgr(),
        '/consulta-empleados': (context) => const PaginaConsultaEmpleados(),
        // TODO: Aquí agregarás las otras 3 pantallas cuando las crees:
        '/consulta-correspondencia': (context) => const PaginaConsultaCorrespondencia(),
        // '/consulta-3': (context) => const PantallaTres(),
        // '/consulta-4': (context) => const PantallaCuatro(),
        // '/consulta-5': (context) => const PantallaCinco(),
      },
    );
  }
}