import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';

/// Ficha de servicio de la pantalla "Servicios": mismo formato compacto que los
/// accesos rápidos del Inicio, con una flecha roja en la esquina. Grid de 2
/// columnas.
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm, vertical: 12),
      child: MergeSemantics(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(servicio.icono, size: 24, color: c.azul),
                const SizedBox(height: 8),
                Text(
                  servicio.titulo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  servicio.resumen,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.tenue, fontSize: 11, height: 1.2),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.chevron_right, size: 16, color: c.rojoVivo),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta compacta para los "accesos rápidos" del Inicio: ícono, título y una
/// línea de resumen, centrados. Grid de 2 columnas.
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm, vertical: 12),
      child: MergeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(servicio.icono, size: 24, color: c.azul),
            const SizedBox(height: 8),
            Text(
              servicio.titulo,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTypography.display,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              servicio.resumen,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: c.tenue, fontSize: 11, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
