import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/aviso_box.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/consulta_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/ilustracion_correspondencia.dart';

class PaginaConsultaCorrespondencia extends StatefulWidget {
  const PaginaConsultaCorrespondencia({super.key});

  @override
  State<PaginaConsultaCorrespondencia> createState() =>
      _PaginaConsultaCorrespondenciaState();
}

class _PaginaConsultaCorrespondenciaState
    extends State<PaginaConsultaCorrespondencia> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _verClave = false;
  String? _error;

  @override
  void dispose() {
    _codigoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _consultar() async {
    if (_codigoController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => _error = 'Completa el código y la contraseña.');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Consultando correspondencia ${_codigoController.text}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        const ConsultaHeader(titulo: 'Correspondencia'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.xl - 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              // --- Encabezado de contenido + ilustración ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consulta tu correspondencia',
                          style: TextStyle(
                            fontFamily: AppTypography.display,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.2,
                            letterSpacing: -0.3,
                            color: c.azul,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ingresa el código de registro y la contraseña '
                          'otorgada por la Mesa de Entrada.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  const IlustracionCorrespondencia(size: 74),
                ],
              ),
              const SizedBox(height: AppDimens.lg),

              // --- Ficha del formulario ---
              AppCard(
                elevada: true,
                padding: const EdgeInsets.all(AppDimens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _codigoController,
                      label: 'Código de la correspondencia',
                      hint: 'CGR-2025-08-0000',
                      prefixIcon: Icons.mail_outline,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      errorText: _error,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      hint: 'Ingresa tu contraseña',
                      prefixIcon: Icons.lock_outline,
                      datos: false,
                      obscureText: !_verClave,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _consultar(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _verClave
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: c.tenue,
                        ),
                        onPressed: () =>
                            setState(() => _verClave = !_verClave),
                      ),
                    ),
                    const SizedBox(height: AppDimens.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: LinkRow(
                        label: '¿Olvidaste tu contraseña?',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppButton(
                      label: 'Consultar',
                      icono: Icons.search,
                      cargando: _isLoading,
                      onPressed: _consultar,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.lg),

              // --- Aviso ---
              const AvisoBox(
                titulo: 'Tu información está segura',
                texto:
                    'La información ingresada se utiliza únicamente para '
                    'consultar la correspondencia registrada en la Contraloría.',
                icono: Icons.shield_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
