import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';

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
        const AppHeader(
          titulo: 'Correspondencia',
          leading: HeaderLeading.atras,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg + 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              FormCard(
                icono: Icons.mark_email_read_outlined,
                titulo: 'Correspondencia',
                descripcion:
                    'Ingresa el código de registro y la contraseña otorgada '
                    'por la Mesa de Entrada.',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: LinkRow(
                          label: 'Olvidé la contraseña',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 2),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
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
                    ],
                  ),
                  AppButton(
                    label: 'Consultar',
                    icono: Icons.search,
                    cargando: _isLoading,
                    onPressed: _consultar,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
