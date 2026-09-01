import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icono,
    required this.iconoActivo,
    required this.label,
  });

  final IconData icono;
  final IconData iconoActivo;
  final String label;
}

/// Barra inferior de la app. Etiquetas siempre visibles; la pestaña activa se
/// pinta con un bloque azul institucional de borde a borde (incluida el área de
/// gestos del sistema), como en el mockup.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.items,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final List<AppBottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final insetInferior = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border(top: BorderSide(color: c.borde)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavButton(
                  item: items[i],
                  seleccionado: i == index,
                  insetInferior: insetInferior,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.seleccionado,
    required this.insetInferior,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool seleccionado;
  final double insetInferior;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final color = seleccionado ? Colors.white : c.tenue;

    return Semantics(
      button: true,
      selected: seleccionado,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: seleccionado ? AppColors.marca : Colors.transparent,
          padding: EdgeInsets.fromLTRB(4, 11, 4, insetInferior + 11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                seleccionado ? item.iconoActivo : item.icono,
                size: 22,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
