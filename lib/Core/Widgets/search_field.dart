import 'package:flutter/material.dart';

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

  /// Este campo va sobre la franja azul institucional, que es la misma en tema
  /// claro y oscuro. Por eso el fondo se mantiene fijo blanco y los colores de
  /// texto también son fijos (oscuros), para evitar texto claro ilegible sobre
  /// blanco en modo oscuro.
  static const Color _fondo = Colors.white;
  static const Color _tinta = Color(0xFF10233B);
  static const Color _tenue = Color(0xFF5C6E88);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fondo,
      borderRadius: BorderRadius.circular(AppDimens.radioMd + 2),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: _tenue),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 14,
                  color: _tinta,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontFamily: AppTypography.cuerpo,
                    fontSize: 14,
                    color: _tenue,
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
