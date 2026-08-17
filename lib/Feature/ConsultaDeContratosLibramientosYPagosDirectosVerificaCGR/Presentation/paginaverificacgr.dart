import 'package:consultas_y_contrataciones/Core/Captcha/captcha_cacheado.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/recaptcha_web_view_provider.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/recaptchahost.dart';
import 'package:consultas_y_contrataciones/Core/NetWork/api_client.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/verifica_cgr_repository.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/footer_institucional.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaresultadoscgr.dart';
import 'package:flutter/material.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/header_institucional.dart';
import 'package:flutter/services.dart'; 

class PaginaVerificaCgr extends StatefulWidget {
  final bool mostrarAppBar;

  const PaginaVerificaCgr({
    super.key,
    this.mostrarAppBar = true,
  });

  @override
  State<PaginaVerificaCgr> createState() => _PaginaVerificaCgrState();
}

class _PaginaVerificaCgrState extends State<PaginaVerificaCgr> {
  final TextEditingController _documentoController = TextEditingController();
  final FocusNode _focoNode = FocusNode();

  late final ApiClient _apiClient;
  late final RecaptchaWebViewProvider _recaptchaBase;
  late final VerificaCgrRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color rojoCaribe = Color(0xFFEF3340);
  static const Color azulBoton = Color(0xFF1E6FCE);

  @override
  void initState() {
    super.initState();
    
    // Usamos el constructor por defecto de ApiClient sin sobreescribir baseUrl
    _apiClient = ApiClient();

    // Inicializamos la estrategia de Captcha con Caché
    _recaptchaBase = RecaptchaWebViewProvider(
      siteKey: 'TU_RECAPTCHA_SITE_KEY', // Sustituir por la clave de producción
    );

    _repository = VerificaCgrRepository(
      _apiClient,
      captchaProvider: CaptchaCacheado(_recaptchaBase),
    );
  }

  @override
  void dispose() {
    _documentoController.dispose();
    _focoNode.dispose();
    super.dispose();
  }

  String _limpiarDocumento(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> _buscarTramite() async {
    final documentoLimpio = _limpiarDocumento(_documentoController.text);

    if (documentoLimpio.isEmpty || (documentoLimpio.length != 9 && documentoLimpio.length != 11)) {
      setState(() {
        _errorMessage = 'Ingrese un RNC de 9 dígitos o Cédula de 11 dígitos válido.';
      });
      _mostrarSnackBar(_errorMessage!, esError: true);
      return;
    }

    _focoNode.unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ConsultaResultadoEntity resultado = 
          await _repository.consultarTramites(documentoLimpio);

      if (!mounted) return;
      setState(() => _isLoading = false);

      // NAVEGACIÓN A LA SEGUNDA PANTALLA:
      // Se delega tanto el estado vacío (alerta amarilla) como la lista de resultados a la nueva página.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaResultadosCgr(
            documento: documentoLimpio,
            resultado: resultado,
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _errorMessage = "Error al conectar con la CGR: ${e.toString().replaceAll('Exception: ', '')}";
      });

      _mostrarSnackBar(_errorMessage!, esError: true);
    }
  }

void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? rojoCaribe : azulMedianoche,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarBaseLegalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Base Legal - Verifica CGR",
          style: TextStyle(color: azulMedianoche, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Conforme a la Ley No. 10-07 que crea el Sistema Nacional de Control Interno y de la Contraloría General de la República, esta herramienta permite fiscalizar los expedientes en tránsito.\n\n"
            "Nota: Esta consulta únicamente refleja los trámites que se encuentran actualmente en curso dentro de la Contraloría General de la República.",
            style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF4A5568)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar", style: TextStyle(color: azulBoton, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controlador = _recaptchaBase.controladorActual;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: widget.mostrarAppBar
          ? AppBar(
              backgroundColor: azulMedianoche,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              title: const Text(
                "Certificación de Cargos",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            if (controlador != null) RecaptchaHost(controlador: controlador),

            Column(
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
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568), height: 1.5),
            children: [
              const TextSpan(text: "Acceda de forma segura y transparente a la información de sus "),
              const TextSpan(text: "trámites en proceso.", style: TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: "\nEsta consulta solo mostrará los trámites que se encuentren en Contraloría. "),
              WidgetSpan(
                child: GestureDetector(
                  onTap: _mostrarBaseLegalDialog,
                  child: const Text(
                    "Base legal",
                    style: TextStyle(
                      color: azulBoton,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
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
            focusNode: _focoNode,
            keyboardType: TextInputType.number,
            maxLength: 11,
            enabled: !_isLoading,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_errorMessage != null) setState(() => _errorMessage = null);
            },
            onSubmitted: (_) => _buscarTramite(),
            decoration: InputDecoration(
              hintText: "Ingrese su número de RNC / Cédula",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              counterText: '',
              errorText: _errorMessage,
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