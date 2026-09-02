import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/chip_icono.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/consulta_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
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
    if (_isLoading) return;

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
    final c = context.colores;

    return Column(
      children: [
        const ConsultaHeader(
          titulo: 'Empleados del Estado',
          conLockup: false,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.xl - 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              // --- Ficha principal ---
              AppCard(
                elevada: true,
                padding: const EdgeInsets.all(AppDimens.lg + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: AppDimens.md + 2),
                      child: Center(
                        child: BrandLogo(
                          height: 74,
                          semanticLabel:
                              'Contraloría General de la República Dominicana',
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Empleados del Estado',
                                style: TextStyle(
                                  fontFamily: AppTypography.display,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  letterSpacing: -0.4,
                                  color: c.azul,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Consulta la nómina pública del Estado por '
                                'número de cédula del servidor.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(height: 1.45),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const ChipIcono(Icons.groups_outlined),
                      ],
                    ),
                    const SizedBox(height: AppDimens.lg),
                    AppTextField(
                      controller: _cedulaController,
                      label: 'Cédula',
                      hint: '000-0000000-0',
                      prefixIcon: Icons.recent_actors_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.search,
                      enabled: !_isLoading,
                      errorText: _error,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                      onSubmitted: (_) => _buscarEmpleado(),
                    ),
                    const SizedBox(height: AppDimens.sm),
                    const HelperText(
                      icono: Icons.info_outline,
                      texto: '11 dígitos, con o sin guiones.',
                    ),
                    const SizedBox(height: AppDimens.lg),
                    AppButton(
                      label: 'Buscar',
                      icono: Icons.search,
                      cargando: _isLoading,
                      onPressed: _buscarEmpleado,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.lg),

              // --- Aviso ---
              const _AvisoImportante(
                titulo: 'Información importante',
                texto:
                    'Nómina actualizada a julio 2026. Fuente: Dirección General '
                    'de Presupuesto y SIGEF.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Recuadro de aviso con título en negrita, chip celeste y texto.
class _AvisoImportante extends StatelessWidget {
  const _AvisoImportante({required this.titulo, required this.texto});

  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      padding: const EdgeInsets.all(AppDimens.md + 2),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          c.azul.withValues(alpha: 0.07),
          c.superficie,
        ),
        border: Border.all(color: c.azul.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChipIcono(Icons.info_outline, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: c.azul,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  texto,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: c.tintaSuave,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
