import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';

/// Pantalla informativa sobre la Contraloría General de la República.
class PaginaAcerca extends StatelessWidget {
  const PaginaAcerca({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        const AppHeader(
          titulo: 'Acerca de la Contraloría',
          leading: HeaderLeading.atras,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.xl,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              const Center(
                child: BrandLogo(
                  height: 96,
                  semanticLabel: 'Contraloría General de la República Dominicana',
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Text(
                'Contraloría General de la\nRepública Dominicana',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  height: 1.25,
                  color: c.azul,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Transparencia · Integridad · Eficiencia',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c.tenue, letterSpacing: 0.2),
              ),
              const SizedBox(height: AppDimens.xl),

              _Seccion(
                titulo: 'Qué hacemos',
                child: Text(
                  'La Contraloría General de la República ejerce la '
                  'fiscalización interna y la autorización de los pagos del '
                  'Estado, garantizando la integridad y la legalidad en el uso '
                  'de los recursos públicos, en apego a los principios de '
                  'transparencia, eficiencia y responsabilidad administrativa.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.55),
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                titulo: 'Marco legal',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Vineta(
                      'Constitución de la República Dominicana',
                      'Artículos 246 y 247.',
                    ),
                    _Vineta(
                      'Ley No. 10-07',
                      'Sistema Nacional de Control Interno y de la Contraloría '
                          'General de la República, y su Reglamento de '
                          'Aplicación No. 491-07.',
                    ),
                    _Vineta(
                      'Ley No. 200-04',
                      'Sobre Libre Acceso a la Información Pública.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                titulo: 'Contacto',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _LineaContacto(
                      Icons.place_outlined,
                      'Ave. Pedro A. Lluberes No. 1, esq. Calle Francia,\n'
                          '3er piso, Gascue, Santo Domingo, D.N.',
                    ),
                    SizedBox(height: 12),
                    _LineaContacto(Icons.call_outlined, '(809) 682-1677'),
                    SizedBox(height: 12),
                    _LineaContacto(
                      Icons.mail_outline,
                      'contacto@contraloria.gob.do',
                    ),
                    SizedBox(height: 12),
                    _LineaContacto(Icons.language_outlined, 'contraloria.gob.do'),
                  ],
                ),
              ),

              const SizedBox(height: AppDimens.xl),
              Center(
                child: LinkRow(
                  icono: Icons.description_outlined,
                  label: 'Licencias de código abierto',
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Portal de Consultas CGR',
                    applicationVersion: '2.0.0',
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.md),
              Text(
                'Versión 2.0.0',
                textAlign: TextAlign.center,
                style: AppTypography.datos(color: c.tenue, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              titulo,
              style: TextStyle(
                fontFamily: AppTypography.display,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: context.colores.azul,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          child,
        ],
      ),
    );
  }
}

class _Vineta extends StatelessWidget {
  const _Vineta(this.titulo, this.detalle);

  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colores.rojoVivo,
              ),
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
                children: [
                  TextSpan(
                    text: '$titulo. ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: detalle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineaContacto extends StatelessWidget {
  const _LineaContacto(this.icono, this.texto);

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 16, color: c.azul),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
