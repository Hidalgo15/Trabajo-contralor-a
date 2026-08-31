import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Campo de texto del rediseño. El aspecto (relleno, bordes, foco, error) viene
/// del `inputDecorationTheme`; aquí solo se arma la etiqueta y se conectan las
/// opciones comunes.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.requerido = false,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.datos = true,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final bool requerido;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final bool enabled;
  final bool obscureText;

  /// Usa la tipografía monoespaciada (para RNC, cédula, códigos…).
  final bool datos;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: Theme.of(context).textTheme.titleSmall,
              children: requerido
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: c.rechazo),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 7),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: datos
              ? AppTypography.datos(color: c.tinta, fontSize: 15)
              : null,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            errorText: errorText,
            errorMaxLines: 3,
            prefixIcon:
                prefixIcon == null ? null : Icon(prefixIcon, size: 18),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
