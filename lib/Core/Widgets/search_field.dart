import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Campo de búsqueda con fondo blanco, pensado para ir sobre la franja azul del
/// Inicio.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = '¿Qué trámite deseas consultar?',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimens.radioMd + 2),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(Icons.search, size: 18, color: c.tenue),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 14,
                  color: c.tinta,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: AppTypography.cuerpo,
                    fontSize: 14,
                    color: c.tenue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
