import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/app_shell.dart';
import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/institutional_footer.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/search_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/section_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/service_card.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  String _filtro = '';

  List<ServicioApp> get _visibles {
    final q = _filtro.trim().toLowerCase();
    if (q.isEmpty) return serviciosApp;
    return serviciosApp
        .where((s) =>
            s.titulo.toLowerCase().contains(q) ||
            s.resumen.toLowerCase().contains(q) ||
            s.descripcion.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final scope = AppShellScope.of(context);
    final visibles = _visibles;

    return Column(
      children: [
        AppHeader(
          mostrarLogo: true,
          accion: HeaderButton(
            icono: Icons.help_outline,
            tooltip: 'Ayuda',
            onTap: () => scope.irAPestana(AppTab.ayuda),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [c.azulProfundo, c.azul],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¡Hola!',
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 27,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Consultas públicas de la Contraloría, en un solo lugar.',
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppDimens.lg),
              SearchField(
                onChanged: (v) => setState(() => _filtro = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg + 2,
              AppDimens.lg,
              0,
            ),
            children: [
              SectionHeader(
                titulo: 'Accesos rápidos',
                accionLabel: 'Ver todos',
                onAccion: () => scope.irAPestana(AppTab.servicios),
              ),
              const SizedBox(height: AppDimens.md),
              if (visibles.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.xl),
                  child: Text(
                    'Sin resultados para tu búsqueda.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: c.tenue),
                  ),
                )
              else
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppDimens.md - 1,
                  mainAxisSpacing: AppDimens.md - 1,
                  childAspectRatio: 1.06,
                  children: [
                    for (final s in visibles)
                      QuickCard(
                        servicio: s,
                        onTap: () => scope.abrirServicio(s),
                      ),
                  ],
                ),
              const SizedBox(height: AppDimens.xl),
              const InstitutionalFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
