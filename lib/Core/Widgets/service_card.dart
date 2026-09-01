import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/servicios_app.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';

/// Tarjeta de servicio del menú principal: fila con el ícono en un chip azul,
/// el título, una línea de subtítulo y una flecha en rojo suave a la derecha.
///
/// Todos los íconos van con el mismo azul institucional (sin colores por
/// servicio, decisión de diseño).
class MenuServiceCard extends StatelessWidget {
  const MenuServiceCard({
    super.key,
    required this.servicio,
    required this.onTap,
  });

  final ServicioApp servicio;
  final VoidCallback onTap;

  /// Rojo suave fijo para la flecha. Es decorativo; se ve bien en claro y
  /// oscuro sobre la superficie de la tarjeta.
  static const Color _flecha = Color(0xFFDD6470);

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child: MergeSemantics(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  c.azul.withValues(alpha: 0.13),
                  c.superficie,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(servicio.icono, size: 22, color: c.azul),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    servicio.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.display,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    servicio.subtitulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.tenue, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: _flecha),
          ],
        ),
      ),
    );
  }
}
