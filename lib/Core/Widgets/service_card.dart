import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';

/// Ficha de servicio de la pantalla "Servicios": ícono, título, descripción y
/// flecha roja en la esquina. Pensada para un grid de 2 columnas.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.servicio,
    required this.onTap,
  });

  final ServicioApp servicio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimens.md + 2),
      child: MergeSemantics(
        child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconoServicio(icono: servicio.icono),
              const SizedBox(height: AppDimens.sm),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  servicio.titulo,
                  style: const TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                servicio.descripcion,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c.tenue, height: 1.35),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.chevron_right, size: 18, color: c.rojoVivo),
          ),
        ],
        ),
      ),
    );
  }
}

class _IconoServicio extends StatelessWidget {
  const _IconoServicio({required this.icono});

  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color.alphaBlend(c.azul.withValues(alpha: 0.11), c.superficie),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      child: Icon(icono, size: 20, color: c.azul),
    );
  }
}

/// Versión compacta para los "accesos rápidos" del Inicio (sin flecha, con el
/// texto resumido).
class QuickCard extends StatelessWidget {
  const QuickCard({
    super.key,
    required this.servicio,
    required this.onTap,
  });

  final ServicioApp servicio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimens.md + 1),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconoServicio(icono: servicio.icono),
            const SizedBox(height: AppDimens.sm),
            Text(
              servicio.titulo,
              style: const TextStyle(
                fontFamily: AppTypography.display,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              servicio.resumen,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: c.tenue, fontSize: 11.5, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
