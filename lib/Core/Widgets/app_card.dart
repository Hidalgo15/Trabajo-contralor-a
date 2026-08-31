import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';

/// Tarjeta base: superficie blanca, borde tenue, esquina redondeada.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.lg),
    this.onTap,
    this.elevada = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Añade una sombra suave (para las fichas de formulario).
  final bool elevada;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final radio = BorderRadius.circular(AppDimens.radioLg);

    final decoracion = BoxDecoration(
      color: c.superficie,
      borderRadius: radio,
      border: Border.all(color: c.borde),
      boxShadow: elevada
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ]
          : null,
    );

    final contenido = Padding(padding: padding, child: child);

    if (onTap == null) {
      return DecoratedBox(decoration: decoracion, child: contenido);
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoracion,
        child: InkWell(
          onTap: onTap,
          borderRadius: radio,
          child: contenido,
        ),
      ),
    );
  }
}
