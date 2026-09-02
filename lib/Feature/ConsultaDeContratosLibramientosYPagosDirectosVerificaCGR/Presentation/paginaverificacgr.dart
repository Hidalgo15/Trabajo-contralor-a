import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:consultas_y_contrataciones/Core/Captcha/captcha_cacheado.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/captcha_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/recaptcha_web_view_provider.dart';
import 'package:consultas_y_contrataciones/Core/Captcha/sin_captcha.dart';
import 'package:consultas_y_contrataciones/Core/GeneralFeatures/recaptchahost.dart';
import 'package:consultas_y_contrataciones/Core/NetWork/api_client.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/app_loading_overlay.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/fase_operacion.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/consulta_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/ilustracion_consulta.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Config/verifica_cgr_config.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Data/verifica_cgr_remote_data_source.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Entities/consulta_resultado_entity.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Exceptions/verifica_cgr_exception.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/Interface/iverifica_cgr_repository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Domain/Repository/verifica_cgr_repository.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/Widgets/dialogos.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaresultadoscgr.dart';

/// Formulario de consulta de trámites de proveedores (Verifica CGR).
class PaginaVerificaCgr extends StatefulWidget {
  const PaginaVerificaCgr({
    super.key,
    this.config = const VerificaCgrConfig(),
  });

  /// Permite apuntar a otro ambiente o encender el captcha sin tocar la
  /// pantalla.
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
  FaseOperacion _fase = FaseOperacion.cargandoDatos;

  @override
  void initState() {
    super.initState();

    final config = widget.config;
    _apiClient = ApiClient(baseUrl: config.baseUrl, timeout: config.timeout);

    _recaptcha = config.validarCaptcha
        ? RecaptchaWebViewProvider(siteKey: config.recaptchaSiteKey)
        : null;

    final recaptcha = _recaptcha;
    final CaptchaProvider captcha = recaptcha == null
        ? const SinCaptcha()
        : CaptchaCacheado(recaptcha);

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
    if (_isLoading) return;

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
          ? FaseOperacion.seguridad
          : FaseOperacion.cargandoDatos;
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

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              PaginaResultadosCgr(documento: documento, resultado: resultado),
        ),
      );
    } on VerificaCgrException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.mensaje;
      });
      _mostrarError(e.mensaje);
    } catch (_) {
      if (!mounted) return;
      const mensaje = 'No se pudo completar la consulta, intente nuevamente.';
      setState(() {
        _isLoading = false;
        _errorMessage = mensaje;
      });
      _mostrarError(mensaje);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: context.colores.rechazo,
      ),
    );
  }

  String _mensajeDeFase(FaseOperacion fase) => switch (fase) {
        FaseOperacion.seguridad => 'Verificando seguridad...',
        FaseOperacion.cargandoDatos => 'Consultando trámites...',
      };

  @override
  Widget build(BuildContext context) {
    final recaptcha = _recaptcha;
    final c = context.colores;

    return Column(
      children: [
        const ConsultaHeader(titulo: 'Verifica CGR'),
        Expanded(
          child: Stack(
            children: [
              if (recaptcha != null) RecaptchaHost(provider: recaptcha),
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg,
                  AppDimens.xl - 2,
                  AppDimens.lg,
                  AppDimens.xl,
                ),
                children: [
                  // --- Encabezado de contenido + ilustración ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consulta el estado de tu trámite',
                              style: TextStyle(
                                fontFamily: AppTypography.display,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                height: 1.2,
                                letterSpacing: -0.3,
                                color: c.azul,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Solo se muestran los trámites que se encuentran '
                              'en Contraloría.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(height: 1.45),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      const IlustracionConsulta(size: 74),
                    ],
                  ),
                  const SizedBox(height: AppDimens.lg),

                  // --- Ficha del formulario ---
                  AppCard(
                    elevada: true,
                    padding: const EdgeInsets.all(AppDimens.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _ChipIcono(Icons.recent_actors_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                controller: _documentoController,
                                focusNode: _focoNode,
                                label: 'Número de documento',
                                hint: 'Ingresa su número de RNC o Cédula',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.search,
                                maxLength: 11,
                                enabled: !_isLoading,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                errorText: _errorMessage,
                                onChanged: (_) {
                                  if (_errorMessage != null) {
                                    setState(() => _errorMessage = null);
                                  }
                                },
                                onSubmitted: (_) => _buscarTramite(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.md),
                        AppButton(
                          label: 'Buscar trámite',
                          icono: Icons.search,
                          cargando: _isLoading,
                          onPressed: _buscarTramite,
                        ),
                        const SizedBox(height: AppDimens.md + 2),
                        Divider(height: 1, color: c.borde),
                        const SizedBox(height: AppDimens.md + 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _ChipIcono(Icons.verified_user_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'El sistema valida automáticamente el estatus '
                                'del trámite.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: c.tenue, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.lg),

                  // --- Aviso ---
                  _AvisoInfo(
                    texto:
                        'Para información de los trámites aprobados, diríjase a '
                        'la Oficina de Libre Acceso a la Información Pública de '
                        'la CGR o de la institución contratante.',
                  ),
                  const SizedBox(height: AppDimens.md),

                  // --- Enlace a base legal ---
                  AppCard(
                    onTap: () => mostrarBaseLegal(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.lg,
                      vertical: AppDimens.md + 2,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.gavel_outlined, size: 20, color: c.azul),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ver base legal institucional',
                            style: TextStyle(
                              fontFamily: AppTypography.display,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: c.azul,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 20, color: c.tenue),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                AppLoadingOverlay(message: _mensajeDeFase(_fase)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chip circular celeste con un ícono azul (izquierda de un campo o una fila).
class _ChipIcono extends StatelessWidget {
  const _ChipIcono(this.icono);

  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          c.azul.withValues(alpha: 0.12),
          c.superficie,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(icono, size: 20, color: c.azul),
    );
  }
}

/// Recuadro de aviso azul con la "i" en un círculo sólido.
class _AvisoInfo extends StatelessWidget {
  const _AvisoInfo({required this.texto});

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
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: c.azul, shape: BoxShape.circle),
            child: const Icon(Icons.info_outline, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: c.tintaSuave,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
