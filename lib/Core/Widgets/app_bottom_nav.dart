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

/// Barra inferior de la app. Etiquetas siempre visibles y un punto rojo bajo la
/// pestaña activa, como en el prototipo.
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

    return Container(
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border(top: BorderSide(color: c.borde)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    seleccionado: i == index,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.seleccionado,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final color = seleccionado ? c.azul : c.tenue;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            seleccionado ? item.iconoActivo : item.icono,
            size: 22,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontFamily: AppTypography.cuerpo,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: seleccionado ? c.rojoVivo : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
