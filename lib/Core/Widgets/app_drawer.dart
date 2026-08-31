import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/app_shell.dart';
import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Menú lateral. Duplica la barra inferior y añade acceso directo a cada
/// servicio.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final scope = AppShellScope.of(context);

    void cerrar() => Navigator.of(context).pop();

    return Drawer(
      backgroundColor: c.superficie,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              18,
              MediaQuery.of(context).padding.top + 18,
              18,
              18,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.azul, c.azulProfundo],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(variante: LogoVariante.blanco, height: 40),
                const SizedBox(height: 10),
                const Text(
                  'Portal de Consultas\nContraloría General de la República',
                  style: TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
              children: [
                _Item(
                  icono: Icons.home_outlined,
                  label: 'Inicio',
                  onTap: () {
                    cerrar();
                    scope.irAPestana(AppTab.inicio);
                  },
                ),
                _Item(
                  icono: Icons.grid_view_outlined,
                  label: 'Servicios',
                  onTap: () {
                    cerrar();
                    scope.irAPestana(AppTab.servicios);
                  },
                ),
                const _Separador(),
                for (final s in serviciosApp)
                  _Item(
                    icono: s.icono,
                    label: s.titulo,
                    onTap: () {
                      cerrar();
                      scope.abrirServicio(s);
                    },
                  ),
                const _Separador(),
                _Item(
                  icono: Icons.help_outline,
                  label: 'Ayuda',
                  onTap: () {
                    cerrar();
                    scope.irAPestana(AppTab.ayuda);
                  },
                ),
                _Item(
                  icono: Icons.settings_outlined,
                  label: 'Ajustes',
                  onTap: () {
                    cerrar();
                    scope.irAPestana(AppTab.ajustes);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icono, required this.label, required this.onTap});

  final IconData icono;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return ListTile(
      leading: Icon(icono, size: 20, color: c.azul),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTypography.cuerpo,
          fontWeight: FontWeight.w500,
          fontSize: 14.5,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.sm,
        ),
        child: Divider(height: 1, color: context.colores.borde),
      );
}
