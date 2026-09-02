import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/aviso_box.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/consulta_header.dart';
import 'package:consultas_y_contrataciones/Feature/SolicitudCertificacionDeCargos/Presentation/Widgets/modal_requisitos_certificacion.dart';

/// Motivos de la solicitud (tal cual el desplegable del portal web).
const List<String> _motivos = <String>[
  'Validación tiempo de servicio en el estado',
  'Pensiones',
  'Jubilaciones',
  'Para pago de prestaciones laborales',
  'Para uso en el extranjero',
];

enum _MedioContacto { correo, telefono1, telefono2 }

extension on _MedioContacto {
  String get etiqueta => switch (this) {
    _MedioContacto.correo => 'Correo electrónico',
    _MedioContacto.telefono1 => 'Teléfono contacto 1',
    _MedioContacto.telefono2 => 'Teléfono contacto 2',
  };
}

final RegExp _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class PaginaSolicitudCertificacion extends StatefulWidget {
  const PaginaSolicitudCertificacion({super.key});

  @override
  State<PaginaSolicitudCertificacion> createState() =>
      _PaginaSolicitudCertificacionState();
}

class _PaginaSolicitudCertificacionState
    extends State<PaginaSolicitudCertificacion> {
  final _cedula = TextEditingController();
  final _tel1 = TextEditingController();
  final _tel2 = TextEditingController();
  final _email = TextEditingController();
  final _emailConfirmar = TextEditingController();
  final _comentario = TextEditingController();

  String? _motivo;
  _MedioContacto? _medio;
  bool _noSoyRobot = false;

  String? _nombre;
  bool _buscandoNombre = false;

  bool _enviando = false;
  final Map<String, String?> _err = {};

  @override
  void initState() {
    super.initState();
    // Igual que en el portal web: al entrar se muestran los requisitos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) mostrarRequisitosCertificacion(context);
    });
  }

  @override
  void dispose() {
    _cedula.dispose();
    _tel1.dispose();
    _tel2.dispose();
    _email.dispose();
    _emailConfirmar.dispose();
    _comentario.dispose();
    super.dispose();
  }

  void _alCambiarCedula(String v) {
    final digitos = v.replaceAll(RegExp(r'\D'), '');
    setState(() => _err['cedula'] = null);

    if (digitos.length == 11) {
      _buscarNombre(digitos);
    } else if (_nombre != null || _buscandoNombre) {
      setState(() {
        _nombre = null;
        _buscandoNombre = false;
      });
    }
  }

  // TODO(pendiente): conectar al servicio real de cédula (padrón). Por ahora
  // simula la búsqueda para mostrar el comportamiento de autocompletado.
  Future<void> _buscarNombre(String cedula) async {
    setState(() {
      _buscandoNombre = true;
      _nombre = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _buscandoNombre = false;
      _nombre = 'Nombre del titular de la cédula';
    });
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    FocusScope.of(context).unfocus();

    final cedulaDigitos = _cedula.text.replaceAll(RegExp(r'\D'), '');
    final email = _email.text.trim();

    _err
      ..['cedula'] = cedulaDigitos.length == 11
          ? null
          : 'Ingrese una cédula de 11 dígitos.'
      ..['tel1'] = _tel1.text.trim().length >= 10
          ? null
          : 'Ingrese un teléfono válido.'
      ..['email'] = _correoValido.hasMatch(email)
          ? null
          : 'Ingrese un correo válido.'
      ..['emailConfirmar'] =
          _emailConfirmar.text.trim() == email && email.isNotEmpty
          ? null
          : 'Los correos no coinciden.'
      ..['motivo'] = _motivo == null ? 'Seleccione un motivo.' : null
      ..['medio'] = _medio == null ? 'Seleccione un medio de contacto.' : null
      ..['robot'] = _noSoyRobot ? null : 'Confirme que no es un robot.';

    setState(() {});

    if (_err.values.any((e) => e != null)) return;

    setState(() => _enviando = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _enviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Solicitud enviada. Recibirá respuesta por el medio de contacto '
          'indicado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        const ConsultaHeader(titulo: 'Solicitud de Certificación'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.xl - 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              const AvisoBox(
                texto:
                    'Complete este formulario para solicitar la certificación '
                    'de cargos (años de servicio en instituciones del Estado). '
                    'Los campos con * son obligatorios.',
              ),
              const SizedBox(height: AppDimens.md),
              AppCard(
                onTap: () => mostrarRequisitosCertificacion(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.lg,
                  vertical: AppDimens.md + 2,
                ),
                child: Row(
                  children: [
                    Icon(Icons.checklist_rtl, size: 20, color: c.azul),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ver requisitos y documentos a adjuntar',
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
              const SizedBox(height: AppDimens.lg),

              AppCard(
                elevada: true,
                padding: const EdgeInsets.all(AppDimens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _cedula,
                      label: 'No. de cédula de quien se certifica',
                      requerido: true,
                      hint: 'Digite el documento sin guiones',
                      prefixIcon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      enabled: !_enviando,
                      errorText: _err['cedula'],
                      onChanged: _alCambiarCedula,
                    ),
                    const SizedBox(height: AppDimens.md),
                    _CampoNombre(nombre: _nombre, cargando: _buscandoNombre),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _tel1,
                      label: 'Teléfono de contacto 1',
                      requerido: true,
                      hint: 'Teléfono o celular',
                      prefixIcon: Icons.call_outlined,
                      keyboardType: TextInputType.phone,
                      enabled: !_enviando,
                      errorText: _err['tel1'],
                      onChanged: (_) {
                        if (_err['tel1'] != null) {
                          setState(() => _err['tel1'] = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _tel2,
                      label: 'Teléfono de contacto 2',
                      hint: 'Opcional',
                      prefixIcon: Icons.call_outlined,
                      keyboardType: TextInputType.phone,
                      enabled: !_enviando,
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _email,
                      label: 'Correo electrónico',
                      requerido: true,
                      hint: 'nombre@correo.com',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      datos: false,
                      enabled: !_enviando,
                      errorText: _err['email'],
                      onChanged: (_) {
                        if (_err['email'] != null) {
                          setState(() => _err['email'] = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _emailConfirmar,
                      label: 'Confirmar correo electrónico',
                      requerido: true,
                      hint: 'Repite el correo',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      datos: false,
                      enabled: !_enviando,
                      errorText: _err['emailConfirmar'],
                      onChanged: (_) {
                        if (_err['emailConfirmar'] != null) {
                          setState(() => _err['emailConfirmar'] = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppDimens.md),
                    _CampoSelector(
                      label: 'Motivo de la solicitud',
                      requerido: true,
                      hint: 'Seleccione',
                      valor: _motivo,
                      opciones: _motivos,
                      errorText: _err['motivo'],
                      onChanged: _enviando
                          ? null
                          : (v) => setState(() {
                              _motivo = v;
                              _err['motivo'] = null;
                            }),
                    ),
                    const SizedBox(height: AppDimens.md),
                    _GrupoOpciones(
                      label: 'Medio de contacto preferido',
                      requerido: true,
                      valor: _medio,
                      errorText: _err['medio'],
                      onChanged: _enviando
                          ? null
                          : (v) => setState(() {
                              _medio = v;
                              _err['medio'] = null;
                            }),
                    ),
                    const SizedBox(height: AppDimens.md),
                    AppTextField(
                      controller: _comentario,
                      label: 'Comentario',
                      hint: 'Opcional',
                      datos: false,
                      maxLines: 4,
                      enabled: !_enviando,
                    ),
                    const SizedBox(height: AppDimens.lg),
                    _CampoRobot(
                      valor: _noSoyRobot,
                      errorText: _err['robot'],
                      onChanged: _enviando
                          ? null
                          : (v) => setState(() {
                              _noSoyRobot = v;
                              _err['robot'] = null;
                            }),
                    ),
                    const SizedBox(height: AppDimens.lg),
                    AppButton(
                      label: 'Enviar solicitud',
                      icono: Icons.send_outlined,
                      cargando: _enviando,
                      onPressed: _enviar,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto, {this.requerido = false});

  final String texto;
  final bool requerido;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text.rich(
        TextSpan(
          text: texto,
          style: Theme.of(context).textTheme.titleSmall,
          children: requerido
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: c.rechazo),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: context.colores.rechazo,
        ),
      ),
    );
  }
}

/// Campo "Nombre": de solo lectura, se completa al validar la cédula.
class _CampoNombre extends StatelessWidget {
  const _CampoNombre({required this.nombre, required this.cargando});

  final String? nombre;
  final bool cargando;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final vacio = nombre == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Etiqueta('Nombre'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md + 1,
            vertical: AppDimens.md + 2,
          ),
          decoration: BoxDecoration(
            color: c.superficieAlt,
            border: Border.all(color: c.borde, width: 1.5),
            borderRadius: BorderRadius.circular(AppDimens.radioLg),
          ),
          child: cargando
              ? Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(c.azul),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Validando cédula…',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: c.tenue),
                    ),
                  ],
                )
              : Text(
                  vacio ? 'Se completa al validar la cédula' : nombre!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: vacio ? c.tenue : c.tinta,
                    fontWeight: vacio ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}

/// Desplegable con el estilo de los campos de texto.
class _CampoSelector extends StatelessWidget {
  const _CampoSelector({
    required this.label,
    required this.hint,
    required this.valor,
    required this.opciones,
    required this.onChanged,
    this.requerido = false,
    this.errorText,
  });

  final String label;
  final String hint;
  final String? valor;
  final List<String> opciones;
  final ValueChanged<String?>? onChanged;
  final bool requerido;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Etiqueta(label, requerido: requerido),
        DropdownButtonFormField<String>(
          initialValue: valor,
          isExpanded: true,
          hint: Text(hint),
          icon: Icon(Icons.expand_more, color: c.tenue),
          decoration: InputDecoration(errorText: errorText),
          items: [
            for (final o in opciones)
              DropdownMenuItem<String>(value: o, child: Text(o)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Grupo de opciones únicas (radio) para el medio de contacto.
class _GrupoOpciones extends StatelessWidget {
  const _GrupoOpciones({
    required this.label,
    required this.valor,
    required this.onChanged,
    this.requerido = false,
    this.errorText,
  });

  final String label;
  final _MedioContacto? valor;
  final ValueChanged<_MedioContacto>? onChanged;
  final bool requerido;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Etiqueta(label, requerido: requerido),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? c.rechazo : c.borde,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radioLg),
          ),
          child: RadioGroup<_MedioContacto>(
            groupValue: valor,
            onChanged: (v) {
              if (v != null) onChanged?.call(v);
            },
            child: Column(
              children: [
                for (var i = 0; i < _MedioContacto.values.length; i++) ...[
                  if (i != 0) Divider(height: 1, color: c.borde),
                  InkWell(
                    onTap: onChanged == null
                        ? null
                        : () => onChanged!(_MedioContacto.values[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.sm,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Radio<_MedioContacto>(
                            value: _MedioContacto.values[i],
                          ),
                          Expanded(
                            child: Text(
                              _MedioContacto.values[i].etiqueta,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (errorText != null) _MensajeError(errorText!),
      ],
    );
  }
}

/// Casilla "No soy un robot". TODO(pendiente): reemplazar por el reCAPTCHA real
/// (reutilizar Core/Captcha + RecaptchaHost como en Verifica CGR).
class _CampoRobot extends StatelessWidget {
  const _CampoRobot({
    required this.valor,
    required this.onChanged,
    this.errorText,
  });

  final bool valor;
  final ValueChanged<bool>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Etiqueta('Confirme que no es un robot', requerido: true),
        InkWell(
          onTap: onChanged == null ? null : () => onChanged!(!valor),
          borderRadius: BorderRadius.circular(AppDimens.radioMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.md,
              vertical: AppDimens.md,
            ),
            decoration: BoxDecoration(
              color: c.superficieAlt,
              border: Border.all(
                color: errorText != null ? c.rechazo : c.borde,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radioMd),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: valor,
                    onChanged: onChanged == null
                        ? null
                        : (v) => onChanged!(v ?? false),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'No soy un robot',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Icon(Icons.verified_user_outlined, size: 22, color: c.tenue),
              ],
            ),
          ),
        ),
        if (errorText != null) _MensajeError(errorText!),
      ],
    );
  }
}
