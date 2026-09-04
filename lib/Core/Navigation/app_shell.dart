import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/app_loading_overlay.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_bottom_nav.dart';
import 'package:consultas_y_contrataciones/Feature/Ayuda/Presentation/pagina_ayuda.dart';
import 'package:consultas_y_contrataciones/Feature/Informacion/Presentation/pagina_informacion.dart';
import 'package:consultas_y_contrataciones/Feature/Menu/Presentation/pagina_menu.dart';

/// Índice de cada pestaña de la barra inferior.
class AppTab {
  const AppTab._();
  static const int ayuda = 0;
  static const int inicio = 1;
  static const int informacion = 2;
}

/// Contenedor raíz: barra inferior de 3 pestañas, sin menú lateral.
///
/// El Inicio ya es la lista de servicios. Cada pestaña tiene su propio
/// [Navigator] dentro de un [IndexedStack], así al cambiar de pestaña se
/// conserva el historial de cada una y la barra inferior no desaparece cuando
/// un servicio abre su formulario.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const int _cantPestanas = 3;

  int _tab = AppTab.inicio;
  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(_cantPestanas, (_) => GlobalKey<NavigatorState>());

  /// Mensaje del overlay de carga a pantalla completa. `null` = oculto.
  String? _cargando;

  static const List<AppBottomNavItem> _items = [
    AppBottomNavItem(
      icono: Icons.help_outline,
      iconoActivo: Icons.help,
      label: 'Ayuda',
    ),
    AppBottomNavItem(
      icono: Icons.home_outlined,
      iconoActivo: Icons.home,
      label: 'Inicio',
    ),
    AppBottomNavItem(
      icono: Icons.info_outline,
      iconoActivo: Icons.info,
      label: 'Información',
    ),
  ];

  Widget _raiz(int i) {
    switch (i) {
      case AppTab.inicio:
        return const PaginaMenu();
      case AppTab.ayuda:
        return const PaginaAyuda();
      default:
        return const PaginaInformacion();
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

  /// Cambia al Inicio y abre el formulario del [servicio] sobre esa pestaña.
  void _abrirServicio(ServicioApp servicio) {
    setState(() => _tab = AppTab.inicio);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = _navKeys[AppTab.inicio].currentState;
      nav?.popUntil((r) => r.isFirst);
      nav?.push(MaterialPageRoute<void>(builder: (_) => servicio.pantalla()));
    });
  }

  /// Muestra el overlay de carga cubriendo toda la pantalla (header, contenido
  /// y barra inferior), sin importar en qué pestaña o pantalla esté el usuario.
  void _mostrarCargando(String mensaje) => setState(() => _cargando = mensaje);

  void _ocultarCargando() {
    if (_cargando != null) setState(() => _cargando = null);
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
      mostrarCargando: _mostrarCargando,
      ocultarCargando: _ocultarCargando,
      child: Stack(
        children: [
          PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _manejarPop();
            },
            child: Scaffold(
              body: IndexedStack(
                index: _tab,
                children: [
                  for (var i = 0; i < _cantPestanas; i++)
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
          // Encima de todo: header, contenido y barra inferior incluidos.
          // `Material(transparency)` le da al overlay el ancestro que sus
          // `Text` necesitan (si no, Flutter los pinta con el subrayado de
          // depuración por falta de `Material`).
          if (_cargando != null)
            Material(
              type: MaterialType.transparency,
              child: AppLoadingOverlay(message: _cargando!),
            ),
        ],
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
    required this.mostrarCargando,
    required this.ocultarCargando,
    required super.child,
  });

  final void Function(int tab) irAPestana;
  final void Function(ServicioApp servicio) abrirServicio;

  /// Overlay de carga a pantalla completa, por encima de header y barra
  /// inferior. Pensado para operaciones largas (ej. captcha + consulta).
  final void Function(String mensaje) mostrarCargando;
  final VoidCallback ocultarCargando;

  static AppShellScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppShellScope>();
    assert(scope != null, 'AppShellScope no encontrado en el árbol.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppShellScope oldWidget) => false;
}
