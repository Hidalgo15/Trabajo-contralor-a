import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Estilo del botón.
enum AppButtonKind {
  /// Azul institucional. Acción principal de una pantalla.
  primary,

  /// Rojo institucional. Solo para acciones destacadas puntuales.
  accent,

  /// Contorno azul sobre fondo transparente. Acción secundaria.
  ghost,
}

/// Botón de ancho completo del rediseño, con estado de carga integrado.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icono,
    this.kind = AppButtonKind.primary,
    this.cargando = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icono;
  final AppButtonKind kind;
  final bool cargando;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final accion = cargando ? null : onPressed;

    final Widget contenido = cargando
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icono != null) ...[
                Icon(icono, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    if (kind == AppButtonKind.ghost) {
      return OutlinedButton(onPressed: accion, child: contenido);
    }

    final fondo = kind == AppButtonKind.accent ? c.rojo : c.azul;
    return ElevatedButton(
      onPressed: accion,
      style: ElevatedButton.styleFrom(backgroundColor: fondo),
      child: contenido,
    );
  }
}
