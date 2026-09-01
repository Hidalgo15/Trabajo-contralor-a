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
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';
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

    return Column(
      children: [
        const AppHeader(
          titulo: 'Verifica CGR',
          leading: HeaderLeading.atras,
        ),
        Expanded(
          child: Stack(
            children: [
              if (recaptcha != null) RecaptchaHost(provider: recaptcha),
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg,
                  AppDimens.lg + 2,
                  AppDimens.lg,
                  AppDimens.xl,
                ),
                children: [
                  FormCard(
                    titulo: 'Verifica CGR',
                    descripcion:
                        'Accede de forma segura al estado de tus trámites en '
                        'proceso. Solo se muestran los que se encuentran en '
                        'Contraloría.',
                    children: [
                      AppTextField(
                        controller: _documentoController,
                        focusNode: _focoNode,
                        label: 'Número de documento',
                        hint: 'Ingrese su número de RNC o Cédula',
                        prefixIcon: Icons.badge_outlined,
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
                      const HelperText(
                        texto:
                            'El sistema valida automáticamente el estatus del '
                            'trámite.',
                      ),
                      AppButton(
                        label: 'Buscar trámite',
                        icono: Icons.search,
                        cargando: _isLoading,
                        onPressed: _buscarTramite,
                      ),
                      const InfoBox(
                        texto:
                            'Para información de los trámites aprobados, '
                            'dirígete a la Oficina de Libre Acceso a la '
                            'Información Pública de la CGR o de la institución '
                            'contratante.',
                      ),
                      LinkRow(
                        icono: Icons.gavel_outlined,
                        label: 'Ver base legal institucional',
                        onTap: () => mostrarBaseLegal(context),
                      ),
                    ],
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
