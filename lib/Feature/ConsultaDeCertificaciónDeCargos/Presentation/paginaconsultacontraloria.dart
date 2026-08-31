import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';

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
    return Column(
      children: [
        const AppHeader(
          titulo: 'Certificación de Cargos',
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
                icono: Icons.assignment_ind_outlined,
                titulo: 'Certificación de Cargos',
                descripcion:
                    'Consulta en qué fase se encuentra tu solicitud de '
                    'certificación de cargos.',
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
                  const HelperText(
                    texto: 'Solicitud protegida con verificación automática.',
                  ),
                  AppButton(
                    label: 'Enviar',
                    icono: Icons.check,
                    cargando: _isLoading,
                    onPressed: _consultarSolicitud,
                  ),
                  const InfoBox(
                    texto:
                        'Consulta el estatus de tu solicitud de certificación '
                        'de cargos directamente desde este portal.',
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
