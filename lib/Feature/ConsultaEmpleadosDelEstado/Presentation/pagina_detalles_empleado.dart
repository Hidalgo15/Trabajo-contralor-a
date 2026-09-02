import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/consulta_empleado_response_model.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Presentation/ambito_empleados.dart';

class PaginaDetallesEmpleado extends StatelessWidget {
  const PaginaDetallesEmpleado({
    super.key,
    required this.empleadoData,
    this.ambito,
  });

  final ConsultaEmpleadoResponseModel empleadoData;
  final AmbitoEmpleados? ambito;

  String _iniciales(String? nombre) {
    final partes = (nombre ?? '').trim().split(RegExp(r'\s+'));
    final letras = partes.where((p) => p.isNotEmpty).take(2).map((p) => p[0]);
    final j = letras.join().toUpperCase();
    return j.isEmpty ? '—' : j;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final detalle =
        empleadoData.detalles.isNotEmpty ? empleadoData.detalles.first : null;

    final salarioNum = detalle?.salario;
    final salario = salarioNum != null
        ? NumberFormat.currency(
            locale: 'en_US',
            symbol: r'RD$ ',
            decimalDigits: 2,
          ).format(salarioNum)
        : 'N/D';

    final periodoRaw = detalle?.fechaPeriodo;
    final periodo =
        periodoRaw != null ? periodoRaw.split(' ').first : 'N/D';

    return Column(
      children: [
        const AppHeader(
          titulo: 'Detalle del empleado',
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
              if (ambito != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: PastillaAmbito(ambito!),
                ),
                const SizedBox(height: AppDimens.md),
              ],
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [c.azul, c.azulProfundo],
                        ),
                        borderRadius: BorderRadius.circular(AppDimens.radioLg),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _iniciales(empleadoData.nombre),
                        style: const TextStyle(
                          fontFamily: AppTypography.display,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.md + 1),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            empleadoData.nombre ?? 'N/D',
                            style: const TextStyle(
                              fontFamily: AppTypography.display,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cédula ${empleadoData.cedula ?? 'N/D'}',
                            style: AppTypography.datos(
                              color: c.tenue,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Container(
                padding: const EdgeInsets.all(AppDimens.md + 3),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    c.rojo.withValues(alpha: 0.09),
                    c.superficie,
                  ),
                  border: Border.all(
                    color: c.rojo.withValues(alpha: 0.24),
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radioLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SALARIO MENSUAL',
                      style: TextStyle(
                        fontFamily: AppTypography.cuerpo,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: c.rechazo,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      salario,
                      style: AppTypography.datos(
                        color: c.tinta,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.md),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.lg,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    _Fila('Institución', detalle?.institucion ?? 'N/D'),
                    _Fila('Función / Cargo', detalle?.funcion ?? 'N/D'),
                    _Fila('Período', periodo),
                    _Fila('Cuenta', detalle?.cuenta ?? 'N/D', mono: true),
                    _Fila(
                      'Descripción',
                      detalle?.descripcionCuenta ?? 'N/D',
                      ultima: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.lg),
              AppButton(
                label: 'Volver a consultar',
                icono: Icons.arrow_back,
                kind: AppButtonKind.ghost,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: AppDimens.md),
              const HelperText(
                icono: Icons.info_outline,
                texto:
                    'Fuente: DGCP / SIGEF. Puede variar según el período de '
                    'pago vigente.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila(this.etiqueta, this.valor, {this.mono = false, this.ultima = false});

  final String etiqueta;
  final String valor;
  final bool mono;
  final bool ultima;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.md - 2),
      decoration: ultima
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: c.borde)),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.tenue),
          ),
          const SizedBox(width: AppDimens.lg),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: mono
                  ? AppTypography.datos(color: c.tinta, fontSize: 13)
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: c.tinta,
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
