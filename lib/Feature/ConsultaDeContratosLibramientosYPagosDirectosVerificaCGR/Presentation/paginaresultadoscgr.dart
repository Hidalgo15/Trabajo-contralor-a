import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/tramite_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaginaResultadosCgr extends StatefulWidget {
  final String documento;
  final ConsultaResultadoEntity resultado;

  const PaginaResultadosCgr({
    super.key,
    required this.documento,
    required this.resultado,
  });

  @override
  State<PaginaResultadosCgr> createState() => _PaginaResultadosCgrState();
}

class _PaginaResultadosCgrState extends State<PaginaResultadosCgr> {
  // Colores Institucionales
  static const Color azulOscuro = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF1E6FCE);
  static const Color azulHover = Color(0xFFEBF3FC);
  static const Color grisBorde = Color(0xFFE2E8F0);
  static const Color grisFondoTabla = Color(0xFFF8FAFC);

  // Controladores de búsqueda por sección
  final TextEditingController _filtroLibramientos = TextEditingController();
  final TextEditingController _filtroPagosDirectos = TextEditingController();
  final TextEditingController _filtroContratos = TextEditingController();

  // Control del estado expandido de las secciones
  bool _expansionsLibramientos = false;
  bool _expansionsPagos = false;
  bool _expansionsContratos = false;

  @override
  void dispose() {
    _filtroLibramientos.dispose();
    _filtroPagosDirectos.dispose();
    _filtroContratos.dispose();
    super.dispose();
  }

  void _descargarArchivoIndividual(TramiteEntity tramite) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando trámite No. ${tramite.numero}...'),
        backgroundColor: azulOscuro,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _descargarResultadosGlobales() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generando y descargando reporte consolidado...'),
        backgroundColor: azulOscuro,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: azulOscuro),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/logos/logo_contraloria.png', // Asegúrate de tener esta imagen
          height: 40,
          errorBuilder: (_, __, ___) => const Text(
            "CONTRALORÍA",
            style: TextStyle(color: azulOscuro, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTarjetaResumenConsulta(),
                  const SizedBox(height: 20),

                  if (widget.resultado.estaVacio)
                    _buildAvisoSinResultados()
                  else ...[
                    // Seccion Libramientos
                    if (widget.resultado.libramientos.isNotEmpty)
                      _buildSeccionAcordeon(
                        titulo: "Libramientos",
                        isExpanded: _expansionsLibramientos,
                        onToggle: (val) => setState(() => _expansionsLibramientos = val),
                        searchController: _filtroLibramientos,
                        tramites: widget.resultado.libramientos,
                      ),

                    // Seccion Pagos Directos
                    if (widget.resultado.pagosDirectos.isNotEmpty)
                      _buildSeccionAcordeon(
                        titulo: "Pagos Directos",
                        isExpanded: _expansionsPagos,
                        onToggle: (val) => setState(() => _expansionsPagos = val),
                        searchController: _filtroPagosDirectos,
                        tramites: widget.resultado.pagosDirectos,
                      ),

                    // Seccion Contratos
                    if (widget.resultado.contratos.isNotEmpty)
                      _buildSeccionAcordeon(
                        titulo: "Contratos",
                        isExpanded: _expansionsContratos,
                        onToggle: (val) => setState(() => _expansionsContratos = val),
                        searchController: _filtroContratos,
                        tramites: widget.resultado.contratos,
                      ),

                    const SizedBox(height: 28),

                    // Botones Inferiores de Acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: azulBoton,
                            side: const BorderSide(color: azulBoton),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("Nueva consulta"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _descargarResultadosGlobales,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text("Descargar resultados"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azulBoton,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tarjeta de datos superiores (No. Documento, RPE, Beneficiario)
  Widget _buildTarjetaResumenConsulta() {
    final nombre = widget.resultado.nombreProveedor.isNotEmpty
        ? widget.resultado.nombreProveedor
        : "N/A";
    final doc = widget.resultado.rncCedula.isNotEmpty
        ? widget.resultado.rncCedula
        : widget.documento;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: grisBorde),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resultados de la Consulta",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: azulOscuro,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: grisBorde),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildRichTextItem("No. Documento: ", doc),
              _buildRichTextItem("RPE: ", "216"), // Valor referencial o mapeado
              _buildRichTextItem("Beneficiario: ", nombre),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  /// Acordeón Desplegable para cada categoría de trámites
  Widget _buildSeccionAcordeon({
    required String titulo,
    required bool isExpanded,
    required ValueChanged<bool> onToggle,
    required TextEditingController searchController,
    required List<TramiteEntity> tramites,
  }) {
    // Filtrado local por número de orden de pago o secuencia
    final filtro = searchController.text.toLowerCase();
    final listaFiltrada = tramites.where((t) {
      return t.numero.toLowerCase().contains(filtro) ||
          t.institucion.toLowerCase().contains(filtro);
    }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: grisBorde),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Encabezado desplegable
          InkWell(
            onTap: () => onToggle(!isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: isExpanded ? azulOscuro : azulHover,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isExpanded ? Colors.white : azulOscuro,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: isExpanded ? Colors.white : azulOscuro,
                  ),
                ],
              ),
            ),
          ),

          // Contenido Expandible
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Buscador superior derecho dentro de la sección
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 280,
                      height: 38,
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Buscar por No. Orden de Pago...",
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                          suffixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: grisBorde),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: azulBoton),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lista de Tarjetas / Tabla
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listaFiltrada.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildTarjetaTablaTramite(listaFiltrada[index]);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Estructura de Tabla Interna exactamente como en la imagen
  Widget _buildTarjetaTablaTramite(TramiteEntity tramite) {
    final NumberFormat formatoMoneda = NumberFormat.currency(
      symbol: r'RD$',
      decimalDigits: 2,
    );

    final bool esRI = tramite.tipoEstado == TipoEstadoTramite.requiereInformacion;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: grisBorde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fila Titular: Institución + Botón Descarga Individual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF1F5F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tramite.institucion.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined, color: azulBoton, size: 22),
                  onPressed: () => _descargarArchivoIndividual(tramite),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: "Descargar Documento",
                ),
              ],
            ),
          ),

          // Tabla Clave / Valor en formato Grid
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(1.8),
              },
              children: [
                _buildTableRow("Beneficiario", tramite.concepto.isNotEmpty ? tramite.concepto : widget.resultado.nombreProveedor, spanTwoColumns: true),
                _buildTableRowTwoPairs(
                  "No. Documento", widget.documento,
                  "Período", "2026",
                ),
                _buildTableRowTwoPairs(
                  "No. Orden de pago", tramite.numero,
                  "Monto", formatoMoneda.format(tramite.monto),
                ),
                _buildTableRowStatus(
                  "Fecha de registro en Contraloría", tramite.fecha,
                  "Estatus", tramite.estado, esRI,
                ),
              ],
            ),
          ),

          // Alerta amarilla si requiere información
          if (esRI)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFB45309)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "En caso de requerir información adicional, favor contactar con la institución contratante.",
                      style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Auxiliares para construir la tabla de datos estilo CGR
  TableRow _buildTableRow(String label, String value, {bool spanTwoColumns = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: azulOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
        ),
        if (!spanTwoColumns) ...[
          const SizedBox(),
          const SizedBox(),
        ]
      ],
    );
  }

  TableRow _buildTableRowTwoPairs(String label1, String value1, String label2, String value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: azulOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value1, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: azulOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value2, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
        ),
      ],
    );
  }

  TableRow _buildTableRowStatus(String label1, String value1, String label2, String statusText, bool esRI) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: azulOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value1, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: azulOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: esRI ? const Color(0xFFFEF3C7) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: esRI ? const Color(0xFF92400E) : const Color(0xFF0369A1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvisoSinResultados() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Column(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFFD97706), size: 40),
          SizedBox(height: 12),
          Text(
            "Sin trámites pendientes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
          ),
          SizedBox(height: 8),
          Text(
            "Actualmente no posee trámites pendientes en tránsito dentro de la Contraloría General de la República.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF78350F)),
          ),
        ],
      ),
    );
  }
}