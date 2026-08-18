import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_cacheado.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/recaptcha_web_view_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/sin_captcha.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/footer_institucional.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/header_institucional.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/recaptchahost.dart';
import 'package:consultas_y_contrataciones/Core/NetWork/api_client.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Config/verifica_cgr_config.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Data/verifica_cgr_remote_data_source.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Exceptions/verifica_cgr_exception.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/Interface/iverifica_cgr_repository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/verifica_cgr_repository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/dialogos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/verifica_cgr_colores.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaresultadoscgr.dart';

/// Formulario de consulta de trámites de proveedores (Verifica CGR).
class PaginaVerificaCgr extends StatefulWidget {
  const PaginaVerificaCgr({
    super.key,
    this.mostrarAppBar = true,
    this.config = const VerificaCgrConfig(),
  });

  final bool mostrarAppBar;

  /// Permite apuntar a otro ambiente o apagar el captcha desde la app anfitriona
  /// sin tocar esta pantalla.
  final VerificaCgrConfig config;

  @override
  State<PaginaVerificaCgr> createState() => _PaginaVerificaCgrState();
}

class _PaginaVerificaCgrState extends State<PaginaVerificaCgr> {
  final TextEditingController _documentoController = TextEditingController();
  final FocusNode _focoNode = FocusNode();

  late final ApiClient _apiClient;
  late final RecaptchaWebViewProvider? _recaptcha;
  late final IVerificaCgrRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  FaseConsulta _fase = FaseConsulta.consultandoTramites;

  @override
  void initState() {
    super.initState();

    final config = widget.config;

    _apiClient = ApiClient(baseUrl: config.baseUrl, timeout: config.timeout);

    // El WebView solo se construye si el captcha está encendido: así la
    // pantalla no arrastra esa dependencia cuando no hace falta.
    _recaptcha = config.validarCaptcha
        ? RecaptchaWebViewProvider(siteKey: config.recaptchaSiteKey)
        : null;

    final recaptcha = _recaptcha;

    // Cada consulta pide un token nuevo: los de reCAPTCHA v3 son de un solo
    // uso y expiran a los 2 minutos, así que reutilizarlos garantiza un
    // rechazo por "timeout-or-duplicate". La envoltura se conserva solo para
    // que dos toques seguidos en "Buscar" compartan la misma ejecución.
    final CaptchaProvider captcha =
        recaptcha == null ? const SinCaptcha() : CaptchaCacheado(recaptcha);

    _repository = VerificaCgrRepository(
      VerificaCgrRemoteDataSource(apiClient: _apiClient, config: config),
      config: config,
      captchaProvider: captcha,
    );
  }

  @override
  void dispose() {
    _documentoController.dispose();
    _focoNode.dispose();
    _apiClient.cerrar();
    super.dispose();
  }

  Future<void> _buscarTramite() async {
    final documento =
        VerificaCgrRepository.soloDigitos(_documentoController.text);

    if (!VerificaCgrRepository.documentoValido(documento)) {
      setState(() {
        _errorMessage =
            'Ingrese un RNC de 9 dígitos o una cédula de 11 dígitos válida.';
      });
      return;
    }

    _focoNode.unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fase = widget.config.validarCaptcha
          ? FaseConsulta.verificandoSeguridad
          : FaseConsulta.consultandoTramites;
    });

    try {
      final ConsultaResultadoEntity resultado =
          await _repository.consultarTramites(
        documento,
        onFase: (fase) {
          if (mounted) setState(() => _fase = fase);
        },
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // El resultado vacío también se delega a la pantalla de resultados: allí
      // se muestra como aviso ("no posee trámites pendientes"), nunca como
      // fallo de la consulta.
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PaginaResultadosCgr(
            documento: documento,
            resultado: resultado,
          ),
        ),
      );
    } on VerificaCgrException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.mensaje;
      });
      _mostrarSnackBar(e.mensaje, esError: true);
    } catch (_) {
      if (!mounted) return;
      const mensaje = 'No se pudo completar la consulta, intente nuevamente.';
      setState(() {
        _isLoading = false;
        _errorMessage = mensaje;
      });
      _mostrarSnackBar(mensaje, esError: true);
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError
            ? VerificaCgrColores.rojoCaribe
            : VerificaCgrColores.azulMedianoche,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recaptcha = _recaptcha;

    return Scaffold(
      backgroundColor: VerificaCgrColores.fondoPantalla,
      appBar: widget.mostrarAppBar
          ? AppBar(
              backgroundColor: VerificaCgrColores.azulMedianoche,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              title: const Text(
                'Verifica CGR',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            // WebView de 0x0 que ejecuta el reCAPTCHA. Se monta solo mientras
            // dura la verificación.
            if (recaptcha != null) RecaptchaHost(provider: recaptcha),

            Column(
              children: [
                const HeaderInstitucional(
                  tituloPantalla: 'Consulta de Trámites de Proveedores',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE0E0E0),
                ),
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
                            final esAncho = constraints.maxWidth > 768;

                            // En móvil el formulario va primero: el usuario
                            // viene a consultar, no a leer.
                            return esAncho
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: _buildInformacionIzquierda(),
                                      ),
                                      const SizedBox(width: 48),
                                      Expanded(child: _buildTarjetaFormulario()),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      _buildTarjetaFormulario(),
                                      const SizedBox(height: 32),
                                      _buildInformacionIzquierda(),
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

            if (_isLoading) _OverlayCarga(fase: _fase),
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
          'Verifica CGR',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: VerificaCgrColores.azulMedianoche,
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: VerificaCgrColores.textoTenue,
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: 'Acceda de forma segura y transparente a la información '
                    'de sus ',
              ),
              const TextSpan(
                text: 'trámites en proceso.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ' Esta consulta solo mostrará los trámites que se '
                    'encuentren en Contraloría. ',
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () => mostrarBaseLegal(context),
                  child: const Text(
                    'Base legal',
                    style: TextStyle(
                      fontSize: 14,
                      color: VerificaCgrColores.azulBoton,
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
        _buildBulletPoint('Información verificada en registros institucionales.'),
        const SizedBox(height: 8),
        _buildBulletPoint('Resultados claros y actualizados en tiempo real.'),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: VerificaCgrColores.azulMedianoche,
          ),
          label: const Text(
            'Volver al Portal de Consultas',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: VerificaCgrColores.azulMedianoche,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            side: const BorderSide(
              color: VerificaCgrColores.azulMedianoche,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
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
            border: Border.all(
              color: VerificaCgrColores.azulBoton,
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.check,
            size: 12,
            color: VerificaCgrColores.azulBoton,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 13,
              color: VerificaCgrColores.textoTenue,
            ),
          ),
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
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 8)),
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
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance,
                size: 48,
                color: VerificaCgrColores.azulMedianoche,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Verifica CGR',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: VerificaCgrColores.azulMedianoche,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Número de Documento',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: VerificaCgrColores.texto,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _documentoController,
            focusNode: _focoNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            maxLength: 11,
            enabled: !_isLoading,
            // El teclado numérico de Android deja meter separadores; esto
            // replica el `soloNumeros()` del portal web.
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_errorMessage != null) setState(() => _errorMessage = null);
            },
            onSubmitted: (_) => _buscarTramite(),
            decoration: InputDecoration(
              hintText: 'Ingrese su número de RNC / Cédula',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: const Icon(Icons.badge_outlined, size: 20),
              counterText: '',
              errorText: _errorMessage,
              errorMaxLines: 3,
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: VerificaCgrColores.azulBoton,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'El sistema valida automáticamente el estatus del trámite',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _buscarTramite,
            icon: _isLoading
                ? const SizedBox.shrink()
                : const Icon(Icons.search, size: 18),
            label: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Buscar Trámite',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: VerificaCgrColores.azulBoton,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: VerificaCgrColores.azulBoton,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'En caso de requerir información de los trámites aprobados, '
                  'favor dirigirse a la Oficina de Libre Acceso a la '
                  'Información Pública de la Contraloría General de la '
                  'República o de la Institución Contratante.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 11,
                    color: VerificaCgrColores.textoTenue,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Overlay institucional mientras corre la consulta. Bloquea la interacción
/// para que el usuario no dispare dos consultas seguidas, y dice en qué etapa
/// va: la verificación de seguridad puede tardar varios segundos.
class _OverlayCarga extends StatelessWidget {
  const _OverlayCarga({required this.fase});

  final FaseConsulta fase;

  @override
  Widget build(BuildContext context) {
    final mensaje = switch (fase) {
      FaseConsulta.verificandoSeguridad => 'Verificando seguridad...',
      FaseConsulta.consultandoTramites => 'Consultando trámites...',
    };

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xE6003870),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logos/logo_contraloria_blanco.png',
                height: 100,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 22),
              const SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
