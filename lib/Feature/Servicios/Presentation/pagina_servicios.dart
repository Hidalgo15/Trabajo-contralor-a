import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/service_card.dart';

class PaginaServicios extends StatelessWidget {
  const PaginaServicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(titulo: 'Servicios en Línea'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg + 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              const Text(
                '¿Qué deseas consultar?',
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecciona el servicio que necesitas.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimens.lg),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppDimens.md - 1,
                mainAxisSpacing: AppDimens.md - 1,
                childAspectRatio: 0.82,
                children: [
                  for (final s in serviciosApp)
                    ServiceCard(
                      servicio: s,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => s.pantalla()),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              const InfoBox(
                texto:
                    'Todas las consultas son públicas y gratuitas. No requieren '
                    'usuario ni registro.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
