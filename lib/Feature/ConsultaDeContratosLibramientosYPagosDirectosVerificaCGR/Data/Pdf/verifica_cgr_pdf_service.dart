import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/contrato_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/estado_tramite.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/tramite_entity.dart';

/// Generacion de los PDF de resultado.
///
/// El portal web usa `html2pdf.js`, que rasteriza HTML a canvas. Aqui el
/// documento se compone con el paquete `pdf`, que produce un PDF vectorial:
/// mas liviano y con texto seleccionable.
///
/// En movil no hay una "carpeta de descargas" universal, asi que en vez de
/// guardar se abre la hoja de compartir del sistema (`Printing.sharePdf`),
/// desde donde el usuario puede guardarlo en Archivos/Drive, enviarlo por
/// correo o imprimirlo. Es el equivalente idiomatico del boton "Descargar PDF".
///
/// **Tipografia y acentos.** Se usan las fuentes PDF estandar (Helvetica), que
/// cubren WinAnsi: acentos, eñe y guion largo salen bien. Simbolos fuera de ese
/// juego (₡, ¥) saldrian en blanco. Si algun dia se manejan esas monedas hay
/// que cargar una fuente TrueType con
/// `theme: pw.ThemeData.withFont(base: await PdfGoogleFonts.openSansRegular())`.
class VerificaCgrPdfService {
  const VerificaCgrPdfService();

  static const PdfColor _azul = PdfColor.fromInt(0xFF003870);
  static const PdfColor _azulClaro = PdfColor.fromInt(0xFFF0F4FF);
  static const PdfColor _fondoTarjeta = PdfColor.fromInt(0xFFF8FBFF);
  static const PdfColor _borde = PdfColor.fromInt(0xFFD0D7E2);
  static const PdfColor _gris = PdfColor.fromInt(0xFF555555);

  /// Ruta del logo dentro de los assets de esta app.
  static const String rutaLogo = 'assets/logos/logo_contraloria.png';

  Future<void> compartirTramite(TramiteEntity tramite, String tipo) async {
    final bytes = await construirTramite(tramite, tipo);
    await Printing.sharePdf(
      bytes: bytes,
      filename: _nombreArchivo(tipo, tramite.beneficiario),
    );
  }

  Future<void> compartirContrato(ContratoEntity contrato) async {
    final bytes = await construirContrato(contrato);
    await Printing.sharePdf(
      bytes: bytes,
      filename: _nombreArchivo('Contrato', contrato.beneficiario),
    );
  }

  Future<void> compartirResumen(ConsultaResultadoEntity resultado) async {
    final bytes = await construirResumen(resultado);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Resultados_Consulta.pdf',
    );
  }

  // ---------------------------------------------------------------------
  // Construccion de documentos (separada del compartir para poder probarla)
  // ---------------------------------------------------------------------

  Future<Uint8List> construirTramite(TramiteEntity tramite, String tipo) async {
    final documento = pw.Document();
    final logo = await _cargarLogo();

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => _encabezado(logo),
        footer: _pie,
        build: (context) => [
          _bloque(
            titulo: '$tipo - ${Formatos.oVacio(tramite.institucion)}',
            filas: [
              ('Beneficiario', Formatos.oVacio(tramite.beneficiario)),
              ('No. Documento', Formatos.oVacio(tramite.documento)),
              ('Período', Formatos.oVacio(tramite.periodo)),
              ('No. Orden de pago', Formatos.oVacio(tramite.numeroOrdenPago)),
              ('Monto', Formatos.moneda(tramite.monto, tramite.moneda)),
              (
                'Fecha de registro en Contraloría',
                Formatos.fecha(tramite.fechaRegistro),
              ),
            ],
            estado: tramite.estado,
          ),
        ],
      ),
    );

    return documento.save();
  }

  Future<Uint8List> construirContrato(ContratoEntity contrato) async {
    final documento = pw.Document();
    final logo = await _cargarLogo();

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => _encabezado(logo),
        footer: _pie,
        build: (context) => [
          _bloque(
            titulo: 'Contrato - ${Formatos.oVacio(contrato.institucion)}',
            filas: [
              ('Beneficiario', Formatos.oVacio(contrato.beneficiario)),
              ('No. Documento', Formatos.oVacio(contrato.documento)),
              ('No. Certificado', Formatos.oVacio(contrato.codigo)),
              ('Monto', Formatos.moneda(contrato.monto, contrato.moneda)),
              (
                'Vigencia',
                Formatos.rango(contrato.fechaInicio, contrato.fechaFin),
              ),
              (
                'Fecha de registro en Contraloría',
                Formatos.fecha(contrato.fechaRegistro),
              ),
              ('Concepto', Formatos.capitalizar(contrato.concepto)),
            ],
            estado: contrato.estado,
          ),
        ],
      ),
    );

    return documento.save();
  }

  /// Reporte consolidado: una tabla por tipo de tramite.
  Future<Uint8List> construirResumen(ConsultaResultadoEntity resultado) async {
    final documento = pw.Document();
    final logo = await _cargarLogo();

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        header: (context) => _encabezado(logo),
        footer: _pie,
        build: (context) {
          final secciones = <pw.Widget>[
            _datosProveedor(resultado),
          ];

          if (resultado.libramientos.isNotEmpty) {
            secciones.add(_tablaPagos('Libramientos', resultado.libramientos));
          }
          if (resultado.pagosDirectos.isNotEmpty) {
            secciones.add(
              _tablaPagos('Pagos Directos', resultado.pagosDirectos),
            );
          }
          if (resultado.contratos.isNotEmpty) {
            secciones.add(_tablaContratos('Contratos', resultado.contratos));
          }
          if (resultado.estaVacio) {
            secciones.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 40),
                child: pw.Center(
                  child: pw.Text(
                    'No se encontraron trámites registrados.',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: _gris,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
              ),
            );
          }

          return secciones;
        },
      ),
    );

    return documento.save();
  }

  // ---------------------------------------------------------------------
  // Piezas reutilizables
  // ---------------------------------------------------------------------

  pw.Widget _encabezado(pw.ImageProvider? logo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Center(
          child: pw.Column(
            children: [
              if (logo != null) pw.Image(logo, width: 110),
              pw.SizedBox(height: 6),
              pw.Text(
                'Verifica CGR',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: _azul,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: _borde, thickness: 0.6),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            Formatos.selloDeTiempo(DateTime.now()),
            style: const pw.TextStyle(fontSize: 8, color: _gris),
          ),
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pw.Widget _pie(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: _borde, thickness: 0.6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generado automáticamente por el sistema Verifica CGR — '
              'Contraloría General de la República.',
              style: const pw.TextStyle(fontSize: 7.5, color: _gris),
            ),
            pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 7.5, color: _gris),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _datosProveedor(ConsultaResultadoEntity resultado) {
    final filas = <(String, String)>[
      ('No. Documento', Formatos.oVacio(resultado.documentoGeneral)),
      if (resultado.proveedor.rpe != null)
        ('RPE', Formatos.oVacio(resultado.proveedor.rpe)),
      ('Beneficiario', Formatos.oVacio(resultado.beneficiarioGeneral)),
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _fondoTarjeta,
        border: pw.Border.all(color: _borde),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1.1),
          1: pw.FlexColumnWidth(3),
        },
        children: [
          for (final fila in filas)
            pw.TableRow(
              children: [
                _celda(fila.$1, esEtiqueta: true),
                _celda(fila.$2),
              ],
            ),
        ],
      ),
    );
  }

  /// Ficha de un solo tramite: pares etiqueta/valor.
  pw.Widget _bloque({
    required String titulo,
    required List<(String, String)> filas,
    required EstadoTramite estado,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _fondoTarjeta,
        border: pw.Border.all(color: _borde),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            titulo,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _azul,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Divider(color: _borde, thickness: 0.6),
          pw.SizedBox(height: 4),
          pw.Table(
            columnWidths: const {
              0: pw.FlexColumnWidth(1.1),
              1: pw.FlexColumnWidth(2),
            },
            children: [
              for (var i = 0; i < filas.length; i++)
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: i.isEven ? _azulClaro : null,
                  ),
                  children: [
                    _celda(filas[i].$1, esEtiqueta: true),
                    _celda(filas[i].$2),
                  ],
                ),
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: filas.length.isEven ? _azulClaro : null,
                ),
                children: [
                  _celda('Estatus', esEtiqueta: true),
                  _celda(estado.mensaje),
                ],
              ),
            ],
          ),
          if (estado.requiereContactarInstitucion) ...[
            pw.SizedBox(height: 12),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFFFF8E5),
                border: pw.Border.all(
                  color: const PdfColor.fromInt(0xFFFFDD99),
                ),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'En caso de requerir información adicional, favor contactar '
                'con la institución contratante.',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColor.fromInt(0xFF5F4500),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _celda(String texto, {bool esEtiqueta = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        texto,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: esEtiqueta ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: esEtiqueta ? _azul : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _tablaPagos(String titulo, List<TramiteEntity> datos) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _tituloSeccion(titulo),
        pw.TableHelper.fromTextArray(
          headers: const [
            '#',
            'Beneficiario',
            'Institución',
            'No. Orden',
            'Monto',
            'Fecha reg.',
            'Estatus',
          ],
          data: [
            for (var i = 0; i < datos.length; i++)
              [
                '${i + 1}',
                Formatos.oVacio(datos[i].beneficiario),
                Formatos.oVacio(datos[i].institucion),
                Formatos.oVacio(datos[i].numeroOrdenPago),
                Formatos.moneda(datos[i].monto, datos[i].moneda),
                Formatos.fecha(datos[i].fechaRegistro),
                datos[i].estado.mensaje,
              ],
          ],
          headerStyle: pw.TextStyle(
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
            color: _azul,
          ),
          headerDecoration: const pw.BoxDecoration(color: _azulClaro),
          cellStyle: const pw.TextStyle(fontSize: 7.5),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(0.5),
            1: pw.FlexColumnWidth(2.2),
            2: pw.FlexColumnWidth(2.2),
            3: pw.FlexColumnWidth(1.2),
            4: pw.FlexColumnWidth(1.4),
            5: pw.FlexColumnWidth(1.1),
            6: pw.FlexColumnWidth(1.6),
          },
          border: pw.TableBorder.all(color: _borde, width: 0.5),
        ),
        _totalSeccion(titulo, datos.length),
      ],
    );
  }

  pw.Widget _tablaContratos(String titulo, List<ContratoEntity> datos) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _tituloSeccion(titulo),
        pw.TableHelper.fromTextArray(
          headers: const [
            '#',
            'Beneficiario',
            'Certificado',
            'Institución',
            'Monto',
            'Vigencia',
            'Estatus',
          ],
          data: [
            for (var i = 0; i < datos.length; i++)
              [
                '${i + 1}',
                Formatos.oVacio(datos[i].beneficiario),
                Formatos.oVacio(datos[i].codigo),
                Formatos.oVacio(datos[i].institucion),
                Formatos.moneda(datos[i].monto, datos[i].moneda),
                Formatos.rango(datos[i].fechaInicio, datos[i].fechaFin),
                datos[i].estado.mensaje,
              ],
          ],
          headerStyle: pw.TextStyle(
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
            color: _azul,
          ),
          headerDecoration: const pw.BoxDecoration(color: _azulClaro),
          cellStyle: const pw.TextStyle(fontSize: 7.5),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FlexColumnWidth(0.5),
            1: pw.FlexColumnWidth(2.2),
            2: pw.FlexColumnWidth(1.2),
            3: pw.FlexColumnWidth(2.2),
            4: pw.FlexColumnWidth(1.4),
            5: pw.FlexColumnWidth(1.8),
            6: pw.FlexColumnWidth(1.6),
          },
          border: pw.TableBorder.all(color: _borde, width: 0.5),
        ),
        _totalSeccion(titulo, datos.length),
      ],
    );
  }

  pw.Widget _tituloSeccion(String titulo) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(top: 18, bottom: 6),
      padding: const pw.EdgeInsets.symmetric(vertical: 7),
      color: _azulClaro,
      child: pw.Center(
        child: pw.Text(
          titulo.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: _azul,
          ),
        ),
      ),
    );
  }

  pw.Widget _totalSeccion(String titulo, int total) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 4),
      child: pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Total de $titulo: $total',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  Future<pw.ImageProvider?> _cargarLogo() async {
    try {
      final datos = await rootBundle.load(rutaLogo);
      // Hay que acotar con offset/length: `buffer` puede ser mayor que el
      // asset si el bundle reutiliza el ByteBuffer.
      return pw.MemoryImage(
        datos.buffer.asUint8List(datos.offsetInBytes, datos.lengthInBytes),
      );
    } catch (_) {
      // Si el asset no esta declarado, el PDF se genera igual pero sin logo,
      // en vez de fallar la descarga completa.
      return null;
    }
  }

  String _nombreArchivo(String tipo, String? beneficiario) {
    final base = (beneficiario ?? 'documento')
        .replaceAll(RegExp(r'[^A-Za-z0-9 ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    return '${tipo.replaceAll(' ', '_')}_$base.pdf';
  }
}
