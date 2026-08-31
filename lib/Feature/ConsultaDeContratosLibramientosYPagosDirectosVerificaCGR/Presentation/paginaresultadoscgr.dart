import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Data/Pdf/verifica_cgr_pdf_service.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/contrato_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/proveedor_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/tramite_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/contrato_card.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/dialogos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/seccion_tramites.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/tramite_card.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/verifica_cgr_colores.dart';

/// Resultados de la consulta.
///
/// Adaptación a móvil: el portal web usa un acordeón con tablas de 4 columnas;
/// aquí cada trámite es una tarjeta apilada y las secciones se colapsan. Como
/// en móvil no hay carpeta de descargas universal, los PDF se abren en la hoja
/// de compartir del sistema.
class PaginaResultadosCgr extends StatelessWidget {
  const PaginaResultadosCgr({
    super.key,
    required this.documento,
    required this.resultado,
    this.pdfService = const VerificaCgrPdfService(),
  });

  /// Documento tal cual lo tecleó el usuario. Se usa como respaldo cuando la
  /// respuesta no trae datos del proveedor.
  final String documento;

  final ConsultaResultadoEntity resultado;
  final VerificaCgrPdfService pdfService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(titulo: 'Resultados', leading: HeaderLeading.atras),
        Expanded(
          child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    children: [
                      _Resumen(
                        resultado: resultado,
                        documentoRespaldo: documento,
                      ),
                      const SizedBox(height: 18),

                      if (resultado.libramientos.isNotEmpty)
                        SeccionTramites(
                          titulo: 'Libramientos',
                          cantidad: resultado.libramientos.length,
                          hintBusqueda: 'Buscar por No. Orden de Pago...',
                          constructorHijos: (filtro) => _filtrarTramites(
                            resultado.libramientos,
                            filtro,
                          )
                              .map(
                                (t) => TramiteCard(
                                  tramite: t,
                                  onDescargar: () => _descargarTramite(
                                    context,
                                    t,
                                    'Libramiento',
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                      if (resultado.pagosDirectos.isNotEmpty)
                        SeccionTramites(
                          titulo: 'Pagos Directos',
                          cantidad: resultado.pagosDirectos.length,
                          hintBusqueda: 'Buscar por No. Orden de Pago...',
                          constructorHijos: (filtro) => _filtrarTramites(
                            resultado.pagosDirectos,
                            filtro,
                          )
                              .map(
                                (t) => TramiteCard(
                                  tramite: t,
                                  onDescargar: () => _descargarTramite(
                                    context,
                                    t,
                                    'Pago Directo',
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                      if (resultado.contratos.isNotEmpty)
                        SeccionTramites(
                          titulo: 'Contratos',
                          cantidad: resultado.contratos.length,
                          hintBusqueda: 'Buscar por No. Certificado...',
                          constructorHijos: (filtro) => _filtrarContratos(
                            resultado.contratos,
                            filtro,
                          )
                              .map(
                                (c) => ContratoCard(
                                  contrato: c,
                                  onVerConcepto: (concepto) =>
                                      mostrarConcepto(context, concepto),
                                  onDescargar: () =>
                                      _descargarContrato(context, c),
                                ),
                              )
                              .toList(),
                        ),

                      if (resultado.estaVacio)
                        _SinResultados(proveedor: resultado.proveedor),

                      const SizedBox(height: 16),
                      Text(
                        'Consulta generada el '
                        '${Formatos.selloDeTiempo(DateTime.now())}',
                        textAlign: TextAlign.center,
                        style: AppTypography.datos(
                          color: VerificaCgrColores.textoTenue,
                          fontSize: 11,
                        ),
                      ),
                    ],
          ),
        ),
        _BarraAcciones(
          resultado: resultado,
          onDescargarTodo: () => _descargarTodo(context),
        ),
      ],
    );
  }

  List<TramiteEntity> _filtrarTramites(
    List<TramiteEntity> lista,
    String filtro,
  ) {
    final busqueda = filtro.trim().toLowerCase();
    if (busqueda.isEmpty) return lista;
    return lista
        .where((t) => (t.numeroOrdenPago ?? '').toLowerCase().contains(busqueda))
        .toList();
  }

  List<ContratoEntity> _filtrarContratos(
    List<ContratoEntity> lista,
    String filtro,
  ) {
    final busqueda = filtro.trim().toLowerCase();
    if (busqueda.isEmpty) return lista;
    return lista
        .where((c) => (c.codigo ?? '').toLowerCase().contains(busqueda))
        .toList();
  }

  Future<void> _descargarTramite(
    BuildContext context,
    TramiteEntity tramite,
    String tipo,
  ) =>
      _conManejoDeError(
        context,
        () => pdfService.compartirTramite(tramite, tipo),
      );

  Future<void> _descargarContrato(
    BuildContext context,
    ContratoEntity contrato,
  ) =>
      _conManejoDeError(
        context,
        () => pdfService.compartirContrato(contrato),
      );

  Future<void> _descargarTodo(BuildContext context) => _conManejoDeError(
        context,
        () => pdfService.compartirResumen(resultado),
      );

  Future<void> _conManejoDeError(
    BuildContext context,
    Future<void> Function() accion,
  ) async {
    // Se captura antes del await: después del gap el `context` puede ya no
    // estar montado.
    final messenger = ScaffoldMessenger.of(context);
    try {
      await accion();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo generar el PDF. Intente nuevamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.resultado, required this.documentoRespaldo});

  final ConsultaResultadoEntity resultado;
  final String documentoRespaldo;

  @override
  Widget build(BuildContext context) {
    final documentoMostrado = resultado.documentoGeneral ?? documentoRespaldo;
    final beneficiario = resultado.beneficiarioGeneral;
    final rpe = resultado.proveedor.rpe;

    final c = context.colores;
    return Container(
      padding: const EdgeInsets.all(AppDimens.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.azul, c.azulProfundo],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radioLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: BrandLogo(variante: LogoVariante.blanco, height: 44),
          ),
          const SizedBox(height: 14),
          _DatoResumen(etiqueta: 'No. Documento', valor: documentoMostrado),
          if (rpe != null) _DatoResumen(etiqueta: 'RPE', valor: rpe),
          if (beneficiario != null)
            _DatoResumen(etiqueta: 'Beneficiario', valor: beneficiario),
        ],
      ),
    );
  }
}

class _DatoResumen extends StatelessWidget {
  const _DatoResumen({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              fontFamily: AppTypography.cuerpo,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            style: const TextStyle(
              fontFamily: AppTypography.cuerpo,
              fontSize: 14.5,
              color: Colors.white,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// Aviso cuando la consulta no devolvió ningún trámite.
///
/// Esto NO es un error: significa que el ciudadano no tiene trámites
/// pendientes. Si además su RPE está inhabilitado, se agrega el motivo que
/// suministra la DGCP.
class _SinResultados extends StatelessWidget {
  const _SinResultados({required this.proveedor});

  final ProveedorEntity proveedor;

  @override
  Widget build(BuildContext context) {
    final inhabilitado = proveedor.rpeInhabilitado;
    final motivo = proveedor.motivoInhabilitacion;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VerificaCgrColores.avisoFondo,
        border: Border.all(color: const Color(0xFFFFE8B3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 40,
            color: Color(0xFFC68A00),
          ),
          const SizedBox(height: 12),
          Text(
            inhabilitado
                ? 'Actualmente usted no posee trámites pendientes en la '
                    'Contraloría, su RPE se encuentra Inhabilitado.'
                : 'Actualmente usted no posee trámites pendientes en la '
                    'Contraloría.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A3B00),
              height: 1.5,
            ),
          ),
          if (inhabilitado && motivo != null) ...[
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Motivo: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: motivo),
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF4A3B00),
                height: 1.45,
              ),
            ),
          ],
          if (inhabilitado) ...[
            const SizedBox(height: 12),
            const Text(
              'Esta información es suministrada por la DGCP.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Color(0xFF6A4A00)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Barra de acciones fija al pie de la pantalla de resultados.
class _BarraAcciones extends StatelessWidget {
  const _BarraAcciones({
    required this.resultado,
    required this.onDescargarTodo,
  });

  final ConsultaResultadoEntity resultado;
  final VoidCallback onDescargarTodo;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border(top: BorderSide(color: c.borde)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.lg,
            AppDimens.md,
            AppDimens.lg,
            AppDimens.sm,
          ),
          child: Column(
            children: [
              if (!resultado.estaVacio) ...[
                AppButton(
                  label: 'Descargar resultados (PDF)',
                  icono: Icons.download_rounded,
                  onPressed: onDescargarTodo,
                ),
                const SizedBox(height: AppDimens.sm),
              ],
              AppButton(
                label: 'Nueva consulta',
                icono: Icons.search,
                kind: AppButtonKind.ghost,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
