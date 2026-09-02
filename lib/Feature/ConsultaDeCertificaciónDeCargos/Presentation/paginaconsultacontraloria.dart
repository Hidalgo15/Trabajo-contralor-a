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
import 'package:consultas_y_contrataciones/Core/Widgets/ilustracion_certificacion.dart';

class PaginaConsultaContraloria extends StatefulWidget {
  const PaginaConsultaContraloria({super.key});

  @override
  State<PaginaConsultaContraloria> createState() =>
      _PaginaConsultaContraloriaState();
}

class _PaginaConsultaContraloriaState extends State<PaginaConsultaContraloria> {
  final TextEditingController _cedulaController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  Future<void> _consultarSolicitud() async {
    if (_cedulaController.text.trim().isEmpty) {
      setState(() => _error = 'Ingrese un número de documento.');
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
        content:
            Text('Consulta enviada para el documento ${_cedulaController.text}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        const ConsultaHeader(titulo: 'Certificación de Cargos'),
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
                          'Consulta el estado de tu solicitud',
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
                          'Consulta en qué fase se encuentra tu solicitud de '
                          'certificación de cargos.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  const IlustracionCertificacion(size: 74),
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
                      controller: _cedulaController,
                      label: 'No. de documento de identidad',
                      requerido: true,
                      hint: 'Digita el documento sin guiones',
                      prefixIcon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      errorText: _error,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      onSubmitted: (_) => _consultarSolicitud(),
                    ),
                    const SizedBox(height: AppDimens.sm),
                    const HelperText(
                      texto:
                          'Solicitud protegida con verificación automática.',
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppButton(
                      label: 'Enviar',
                      icono: Icons.check_circle_outline,
                      cargando: _isLoading,
                      onPressed: _consultarSolicitud,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.lg),

              // --- Aviso ---
              const AvisoBox(
                titulo: 'Información importante',
                texto:
                    'Consulta el estatus de tu solicitud de certificación de '
                    'cargos directamente desde este portal.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
