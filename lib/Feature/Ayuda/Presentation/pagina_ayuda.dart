import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/info_box.dart';

class _Faq {
  const _Faq(this.pregunta, this.respuesta);
  final String pregunta;
  final String respuesta;
}

const _faqs = <_Faq>[
  _Faq(
    '¿Necesito usuario o contraseña?',
    'No. Todas las consultas son públicas y gratuitas. Solo Correspondencia '
        'pide un código y una contraseña que entrega la Mesa de Entrada al '
        'registrar un documento.',
  ),
  _Faq(
    '¿Qué documento ingreso en Verifica CGR?',
    'El RNC del proveedor (9 dígitos) o la cédula (11 dígitos), sin guiones. '
        'Solo verás trámites que estén actualmente en la Contraloría.',
  ),
  _Faq(
    '¿Por qué no aparece mi trámite?',
    'Puede que ya esté aprobado (esos no se listan) o que aún no haya llegado '
        'a Contraloría. Para trámites aprobados, dirígete a la Oficina de Libre '
        'Acceso a la Información Pública.',
  ),
  _Faq(
    '¿De cuándo son los datos de nómina?',
    'De la última nómina publicada por la Dirección General de Presupuesto '
        '(SIGEF). La fecha del período se muestra en cada resultado.',
  ),
];

class PaginaAyuda extends StatelessWidget {
  const PaginaAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        const AppHeader(titulo: 'Ayuda'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg + 2,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              const Text(
                'Preguntas frecuentes',
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lo que más consultan los ciudadanos.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimens.lg),
              Container(
                decoration: BoxDecoration(
                  color: c.superficie,
                  border: Border.all(color: c.borde),
                  borderRadius: BorderRadius.circular(AppDimens.radioMd),
                ),
                clipBehavior: Clip.antiAlias,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Column(
                    children: [
                      for (var i = 0; i < _faqs.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: c.borde),
                        ExpansionTile(
                          initiallyExpanded: i == 0,
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.md + 2,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            AppDimens.md + 2,
                            0,
                            AppDimens.md + 2,
                            AppDimens.md + 2,
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Text(
                            _faqs[i].pregunta,
                            style: const TextStyle(
                              fontFamily: AppTypography.cuerpo,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            Text(
                              _faqs[i].respuesta,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.lg),
              const InfoBox(
                icono: Icons.call_outlined,
                texto:
                    '¿Necesitas más ayuda? Llama al (809) 682-1677 o escribe a '
                    'contacto@contraloria.gob.do',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
