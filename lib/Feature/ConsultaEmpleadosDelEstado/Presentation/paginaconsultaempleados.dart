import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Repository/consulta_empleado_repository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/exception/consulta_empleado_exception.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Presentation/pagina_detalles_empleado.dart';

class PaginaConsultaEmpleados extends StatefulWidget {
  const PaginaConsultaEmpleados({super.key});

  @override
  State<PaginaConsultaEmpleados> createState() =>
      _PaginaConsultaEmpleadosState();
}

class _PaginaConsultaEmpleadosState extends State<PaginaConsultaEmpleados> {
  final TextEditingController _cedulaController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  Future<void> _buscarEmpleado() async {
    final cedula = _cedulaController.text.trim();
    if (cedula.isEmpty) {
      setState(() => _error = 'Ingrese un número de cédula.');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final repository = ConsultaEmpleadoRepository();
      final resultado = await repository.obtenerEmpleado(cedula);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PaginaDetallesEmpleado(empleadoData: resultado),
        ),
      );
    } on ConsultaEmpleadoException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.mensaje);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Ocurrió un error al consultar el servidor.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(
          titulo: 'Empleados del Estado',
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
                icono: Icons.badge_outlined,
                titulo: 'Empleados del Estado',
                descripcion:
                    'Consulta la nómina pública del Estado por número de cédula '
                    'del servidor.',
                children: [
                  AppTextField(
                    controller: _cedulaController,
                    label: 'Cédula',
                    hint: '000-0000000-0',
                    prefixIcon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    enabled: !_isLoading,
                    errorText: _error,
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    onSubmitted: (_) => _buscarEmpleado(),
                  ),
                  const HelperText(
                    icono: Icons.info_outline,
                    texto: '11 dígitos, con o sin guiones.',
                  ),
                  AppButton(
                    label: 'Buscar',
                    icono: Icons.search,
                    cargando: _isLoading,
                    onPressed: _buscarEmpleado,
                  ),
                  const InfoBox(
                    texto:
                        'Nómina actualizada a julio 2026. Fuente: Dirección '
                        'General de Presupuesto y SIGEF.',
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
