import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_bottom_nav.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_drawer.dart';
import 'package:consultas_y_contrataciones/Feature/Ajustes/Presentation/pagina_ajustes.dart';
import 'package:consultas_y_contrataciones/Feature/Ayuda/Presentation/pagina_ayuda.dart';
import 'package:consultas_y_contrataciones/Feature/HubPrincipal/Presentation/pagina_inicio.dart';
import 'package:consultas_y_contrataciones/Feature/Servicios/Presentation/pagina_servicios.dart';

/// Índice de cada pestaña de la barra inferior.
class AppTab {
  const AppTab._();
  static const int inicio = 0;
  static const int servicios = 1;
  static const int ayuda = 2;
  static const int ajustes = 3;
}

/// Contenedor raíz: barra inferior de 4 pestañas + menú lateral.
///
/// Cada pestaña tiene su propio [Navigator] dentro de un [IndexedStack], así al
/// cambiar de pestaña se conserva el historial de cada una y la barra inferior
/// no desaparece cuando un servicio abre su formulario.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = AppTab.inicio;
  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(4, (_) => GlobalKey<NavigatorState>());

  static const List<AppBottomNavItem> _items = [
    AppBottomNavItem(
      icono: Icons.home_outlined,
      iconoActivo: Icons.home,
      label: 'Inicio',
    ),
    AppBottomNavItem(
      icono: Icons.grid_view_outlined,
      iconoActivo: Icons.grid_view_rounded,
      label: 'Servicios',
    ),
    AppBottomNavItem(
      icono: Icons.help_outline,
      iconoActivo: Icons.help,
      label: 'Ayuda',
    ),
    AppBottomNavItem(
      icono: Icons.settings_outlined,
      iconoActivo: Icons.settings,
      label: 'Ajustes',
    ),
  ];

  Widget _raiz(int i) {
    switch (i) {
      case AppTab.inicio:
        return const PaginaInicio();
      case AppTab.servicios:
        return const PaginaServicios();
      case AppTab.ayuda:
        return const PaginaAyuda();
      default:
        return const PaginaAjustes();
    }
  }

  void _seleccionarPestana(int i) {
    if (i == _tab) {
      // Segundo toque en la pestaña activa: vuelve a su raíz.
      _navKeys[i].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() => _tab = i);
    }
  }

  void _irAPestana(int i) {
    if (i != _tab) setState(() => _tab = i);
  }

  /// Cambia a Servicios y abre el formulario del [servicio].
  void _abrirServicio(ServicioApp servicio) {
    setState(() => _tab = AppTab.servicios);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = _navKeys[AppTab.servicios].currentState;
      nav?.popUntil((r) => r.isFirst);
      nav?.push(MaterialPageRoute<void>(builder: (_) => servicio.pantalla()));
    });
  }

  void _manejarPop() {
    final nav = _navKeys[_tab].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    } else if (_tab != AppTab.inicio) {
      setState(() => _tab = AppTab.inicio);
    }
    // En Inicio sin historial no se hace nada: el sistema cierra la app.
  }

  @override
  Widget build(BuildContext context) {
    return AppShellScope(
      irAPestana: _irAPestana,
      abrirServicio: _abrirServicio,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _manejarPop();
        },
        child: Scaffold(
          drawer: const AppDrawer(),
          body: IndexedStack(
            index: _tab,
            children: [
              for (var i = 0; i < 4; i++)
                Navigator(
                  key: _navKeys[i],
                  onGenerateRoute: (settings) => MaterialPageRoute<void>(
                    settings: settings,
                    builder: (_) => _raiz(i),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            index: _tab,
            onSelect: _seleccionarPestana,
            items: _items,
          ),
        ),
      ),
    );
  }
}

/// Expone las acciones de navegación del shell (cambiar de pestaña, abrir un
/// servicio) a cualquier pantalla descendiente.
class AppShellScope extends InheritedWidget {
  const AppShellScope({
    super.key,
    required this.irAPestana,
    required this.abrirServicio,
    required super.child,
  });

  final void Function(int tab) irAPestana;
  final void Function(ServicioApp servicio) abrirServicio;

  static AppShellScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppShellScope>();
    assert(scope != null, 'AppShellScope no encontrado en el árbol.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppShellScope oldWidget) => false;
}
