import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/footer_institucional.dart';
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
    return Scaffold(
      backgroundColor: VerificaCgrColores.fondoPantalla,
      appBar: AppBar(
        backgroundColor: VerificaCgrColores.azulMedianoche,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Resultados de la Consulta',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
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

                      const SizedBox(height: 22),
                      _Acciones(
                        resultado: resultado,
                        onDescargarTodo: () => _descargarTodo(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const FooterInstitucional(),
          ],
        ),
      ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VerificaCgrColores.fondoSuave,
        border: Border.all(color: const Color(0xFFCFE2FF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/logos/logo_contraloria.png',
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: VerificaCgrColores.azulMedianoche,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 14.5,
              color: VerificaCgrColores.texto,
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

class _Acciones extends StatelessWidget {
  const _Acciones({required this.resultado, required this.onDescargarTodo});

  final ConsultaResultadoEntity resultado;
  final VoidCallback onDescargarTodo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!resultado.estaVacio) ...[
          ElevatedButton.icon(
            onPressed: onDescargarTodo,
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text(
              'Descargar resultados',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: VerificaCgrColores.azulBoton,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton.icon(
          // "Nueva consulta" vuelve atrás en la pila: el portal web recarga la
          // página, que en Flutter no aplica.
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.search,
            size: 18,
            color: VerificaCgrColores.azulMedianoche,
          ),
          label: const Text(
            'Nueva consulta',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: VerificaCgrColores.azulMedianoche,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(
              color: VerificaCgrColores.azulMedianoche,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Consulta generada el ${Formatos.selloDeTiempo(DateTime.now())}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.5,
            height: 1.5,
            color: VerificaCgrColores.textoTenue,
          ),
        ),
      ],
    );
  }
}
