import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_card.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/form_card.dart';

/// Pantalla informativa sobre la Contraloría General de la República:
/// misión, visión, valores, política de calidad, marco legal y contacto.
class PaginaAcerca extends StatelessWidget {
  const PaginaAcerca({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final texto =
        Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55);

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
                  semanticLabel:
                      'Contraloría General de la República Dominicana',
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
                icono: Icons.flag_outlined,
                titulo: 'Misión',
                child: Text(
                  'Asegurar la evaluación y fiscalización del debido recaudo, '
                  'manejo, uso e inversión de los recursos públicos, a través '
                  'de la rectoría del Sistema Nacional de Control Interno.',
                  style: texto,
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                icono: Icons.visibility_outlined,
                titulo: 'Visión',
                child: Text(
                  'Ser referente de excelencia con los más altos estándares de '
                  'calidad en la rectoría del control interno y la '
                  'fiscalización de los recursos públicos, con una gestión '
                  'ética, eficiente, eficaz y transparente, que inspire '
                  'confianza y credibilidad para el beneficio de la sociedad '
                  'dominicana.',
                  style: texto,
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                icono: Icons.diamond_outlined,
                titulo: 'Valores',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Valor(
                      'Transparencia',
                      'Manejamos con pulcritud y honestidad los recursos de que '
                          'disponemos, abiertos siempre al escrutinio público.',
                    ),
                    _Valor(
                      'Compromiso',
                      'Realizamos con excelencia, calidad y esmero las '
                          'responsabilidades asumidas, cumpliendo con las '
                          'expectativas.',
                    ),
                    _Valor(
                      'Integridad',
                      'Actuamos apegados a los principios éticos y morales en '
                          'todas nuestras actuaciones como servidores públicos.',
                    ),
                    _Valor(
                      'Confiabilidad',
                      'Producimos informaciones apegadas a la verdad, generando '
                          'confianza en el cumplimiento de nuestras funciones y '
                          'responsabilidades.',
                      ultimo: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                icono: Icons.verified_outlined,
                titulo: 'Política de Calidad',
                child: Text(
                  'La Contraloría General de la República está comprometida con '
                  'la excelencia en el servicio público y la mejora continua '
                  'de su Sistema de Gestión de la Calidad, certificado bajo la '
                  'norma ISO 9001:2015, para asegurar la eficacia de sus '
                  'procesos de fiscalización y control interno en beneficio de '
                  'la sociedad dominicana.',
                  style: texto,
                ),
              ),
              const SizedBox(height: AppDimens.md),

              _Seccion(
                icono: Icons.gavel_outlined,
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
                icono: Icons.contact_page_outlined,
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
                    _LineaContacto(
                      Icons.language_outlined,
                      'contraloria.gob.do',
                    ),
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
  const _Seccion({
    required this.icono,
    required this.titulo,
    required this.child,
  });

  final IconData icono;
  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return AppCard(
      padding: const EdgeInsets.all(AppDimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 16, color: c.azul),
              const SizedBox(width: 8),
              Semantics(
                header: true,
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: c.azul,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.md),
          child,
        ],
      ),
    );
  }
}

class _Valor extends StatelessWidget {
  const _Valor(this.nombre, this.definicion, {this.ultimo = false});

  final String nombre;
  final String definicion;
  final bool ultimo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ultimo ? 0 : 12),
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          children: [
            TextSpan(
              text: '$nombre. ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.colores.azul,
              ),
            ),
            TextSpan(text: definicion),
          ],
        ),
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
