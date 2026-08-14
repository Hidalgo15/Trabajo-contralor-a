import 'package:consultas_y_contrataciones/GeneralFeatures/FooterInstitucional.dart';
import 'package:flutter/material.dart';
import 'package:consultas_y_contrataciones/GeneralFeatures/HeaderInstitucional.dart'; 

// Asegúrate de importar tu widget de footer si está en otro archivo:
// import 'widgets/footer_institucional.dart';

class PaginaVerificaCgr extends StatefulWidget {
  const PaginaVerificaCgr({super.key});

  @override
  State<PaginaVerificaCgr> createState() => _PaginaVerificaCgrState();
}

class _PaginaVerificaCgrState extends State<PaginaVerificaCgr> {
  final TextEditingController _documentoController = TextEditingController();
  bool _isLoading = false;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color rojoCaribe = Color(0xFFEF3340);
  static const Color azulBoton = Color(0xFF1E6FCE);

  @override
  void dispose() {
    _documentoController.dispose();
    super.dispose();
  }

  Future<void> _buscarTramite() async {
    if (_documentoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese un RNC o Cédula válido"),
          backgroundColor: rojoCaribe,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Buscando trámites para el documento: ${_documentoController.text}"),
          backgroundColor: azulMedianoche,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003870),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          "Certificación de Cargos",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderInstitucional(
              tituloPantalla: "Consulta Solicitudes Certificación de Cargos",
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isDesktop = constraints.maxWidth > 768;

                        return isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: _buildInformacionIzquierda()),
                                  const SizedBox(width: 48),
                                  Expanded(child: _buildTarjetaFormulario()),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildInformacionIzquierda(),
                                  const SizedBox(height: 32),
                                  _buildTarjetaFormulario(),
                                ],
                              );
                      },
                    ),
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

  Widget _buildInformacionIzquierda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Verifica CGR",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: azulMedianoche,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Color(0xFF4A5568), height: 1.5),
            children: [
              TextSpan(text: "Acceda de forma segura y transparente a la información de sus "),
              TextSpan(text: "trámites en proceso.", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "\nEsta consulta solo mostrará los trámites que se encuentren en Contraloría. "),
              TextSpan(
                text: "Base legal",
                style: TextStyle(
                  color: azulBoton,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildBulletPoint("Información verificada en registros institucionales."),
        const SizedBox(height: 8),
        _buildBulletPoint("Resultados claros y actualizados en tiempo real."),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 18, color: azulMedianoche),
          label: const Text(
            "Volver al Portal Web de la Contraloría",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: azulMedianoche,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            side: const BorderSide(color: azulMedianoche, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String texto) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: azulBoton, width: 1.5),
          ),
          child: const Icon(Icons.check, size: 12, color: azulBoton),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(texto, style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568))),
        ),
      ],
    );
  }

  Widget _buildTarjetaFormulario() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Institucional utilizando Image Asset
          Center(
            child: Image.asset(
              'assets/logos/logo_contraloria.png',
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.account_balance, size: 48, color: azulMedianoche),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Verifica CGR",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: azulMedianoche),
          ),
          const SizedBox(height: 28),
          const Text(
            "Número de Documento",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _documentoController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Ingrese su número de RNC / Cédula",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: azulBoton, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "El sistema valida automáticamente el estatus del trámite",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _buscarTramite,
            icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.search, size: 18),
            label: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text("Buscar Trámite", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: azulBoton,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, size: 16, color: azulBoton),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "En caso de requerir información de los trámites aprobados, favor dirigirse a la Oficina de Libre Acceso a la Información Pública de la Contraloría General de la República o de la Institución Contratante.",
                  style: TextStyle(fontSize: 11, color: Color(0xFF4A5568), height: 1.35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}