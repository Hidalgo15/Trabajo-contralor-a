import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/app_shell.dart';
import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/menu_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/search_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/service_card.dart';

/// Pantalla de Inicio: es a la vez el menú de servicios. Fusiona lo que antes
/// eran "Inicio" y "Servicios".
///
/// El header, el buscador y el título "Accesos principales" quedan fijos; solo
/// la lista de servicios hace scroll (pasa por debajo del título).
class PaginaMenu extends StatefulWidget {
  const PaginaMenu({super.key});

  @override
  State<PaginaMenu> createState() => _PaginaMenuState();
}

class _PaginaMenuState extends State<PaginaMenu> {
  /// Cuánto sobresale el buscador por debajo del borde del header.
  static const double _overlap = 24;

  /// Alto reservado para el título fijo "Accesos principales" (debe ser >= al
  /// alto real de esa cabecera para que la primera tarjeta no quede tapada).
  static const double _altoTitulo = 66;

  String _filtro = '';

  List<ServicioApp> get _visibles {
    final q = _filtro.trim().toLowerCase();
    if (q.isEmpty) return serviciosApp;
    return serviciosApp
        .where(
          (s) =>
              s.titulo.toLowerCase().contains(q) ||
              s.subtitulo.toLowerCase().contains(q) ||
              s.descripcion.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final scope = AppShellScope.of(context);
    final visibles = _visibles;

    return Column(
      children: [
        // ---- Fijo: header + buscador ----
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Column(
              children: [
                MenuHeader(),
                SizedBox(height: _overlap + AppDimens.md),
              ],
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 4,
              child: SearchField(
                hintText: '¿Qué deseas consultar?',
                onChanged: (v) => setState(() => _filtro = v),
              ),
            ),
          ],
        ),
        // ---- Scroll: título fijo + lista que pasa por debajo ----
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg,
                  _altoTitulo,
                  AppDimens.lg,
                  0,
                ),
                children: [
                  if (visibles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.xl,
                      ),
                      child: Text(
                        'Sin resultados para tu búsqueda.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: c.tenue),
                      ),
                    )
                  else
                    for (final s in visibles)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: MenuServiceCard(
                          servicio: s,
                          onTap: () => scope.abrirServicio(s),
                        ),
                      ),
                  const SizedBox(height: AppDimens.sm),
                  const InfoBox(
                    texto:
                        'Todas las consultas son públicas y gratuitas. No '
                        'requieren usuario ni registro.',
                  ),
                  const SizedBox(height: AppDimens.xl),
                  const _PieMenu(),
                  const SizedBox(height: AppDimens.lg),
                ],
              ),
              // Título fijo: opaco, la lista pasa por detrás.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: c.fondo,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.lg,
                    AppDimens.md,
                    AppDimens.lg,
                    10,
                  ),
                  child: const _TituloSeccion('Accesos principales'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Título de sección con la barrita roja debajo.
class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Semantics(
      header: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: TextStyle(
              fontFamily: AppTypography.display,
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: c.azul,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 32,
            height: 3,
            decoration: BoxDecoration(
              color: c.rojo,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieMenu extends StatelessWidget {
  const _PieMenu();

  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2026 Contraloría General de la República. '
      'Todos los derechos reservados.',
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.colores.tenue, height: 1.4),
    );
  }
}
