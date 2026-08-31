import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Ficha de formulario del rediseño (estilo del prototipo v2): logo oficial,
/// título, descripción y una lista de contenidos separados por un espacio
/// uniforme.
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.children,
  });

  final String titulo;
  final String descripcion;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevada: true,
      padding: const EdgeInsets.all(AppDimens.xl - 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, bottom: AppDimens.md),
            child: Center(
              child: BrandLogo(
                height: 100,
                semanticLabel:
                    'Contraloría General de la República Dominicana',
              ),
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(
              fontFamily: AppTypography.display,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            descripcion,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.45),
          ),
          for (final hijo in children) ...[
            const SizedBox(height: AppDimens.lg),
            hijo,
          ],
        ],
      ),
    );
  }
}

/// Línea de ayuda bajo un campo: ícono pequeño + texto tenue.
class HelperText extends StatelessWidget {
  const HelperText({
    super.key,
    required this.texto,
    this.icono = Icons.shield_outlined,
  });

  final String texto;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 13, color: c.azul),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.tenue, height: 1.4),
          ),
        ),
      ],
    );
  }
}

/// Enlace de acción en línea (azul, con ícono opcional).
class LinkRow extends StatelessWidget {
  const LinkRow({
    super.key,
    required this.label,
    required this.onTap,
    this.icono,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icono != null) ...[
              Icon(icono, size: 14, color: c.azulEnlace),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.cuerpo,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: c.azulEnlace,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
