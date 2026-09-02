import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Encabezado azul curvo de las pantallas de consulta: botón "volver" + título,
/// cúpula de marca de agua a la derecha y el lockup del logo (cúpula blanca +
/// letras) debajo.
///
/// El lockup se arma con la cúpula blanca (`cupula-blanca.png`) y texto de
/// verdad, para que quede nítido y no dependa de escalar el PNG grande.
class ConsultaHeader extends StatelessWidget {
  const ConsultaHeader({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.marcaProfundo, AppColors.marca],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -56,
              top: 24,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.07,
                  child: BrandLogo(
                    variante: LogoVariante.cupulaBlanca,
                    height: 200,
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        HeaderButton(
                          icono: Icons.arrow_back,
                          tooltip: 'Volver',
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 4),
                        Semantics(
                          header: true,
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              fontFamily: AppTypography.display,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: _Lockup(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cúpula blanca + "Gobierno de la República Dominicana" + línea roja +
/// "Contraloría", todo en blanco sobre el azul.
class _Lockup extends StatelessWidget {
  const _Lockup();

  /// Cuánto baja el bloque de texto (px). Subí este número para bajarlo más.
  static const double _bajarTexto = 6;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Contraloría General de la República Dominicana',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const BrandLogo(variante: LogoVariante.cupulaBlanca, height: 46),
          const SizedBox(width: 11),
          Transform.translate(
            offset: const Offset(0, _bajarTexto),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'GOBIERNO DE LA',
                    style: TextStyle(
                      fontFamily: AppTypography.display,
                      fontWeight: FontWeight.w600,
                      fontSize: 7,
                      letterSpacing: 1.1,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'REPÚBLICA DOMINICANA',
                    style: TextStyle(
                      fontFamily: AppTypography.display,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                      letterSpacing: 0.4,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'CONTRALORÍA',
                    style: TextStyle(
                      fontFamily: AppTypography.display,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      letterSpacing: 2.6,
                      color: AppColors.rojoMarca,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
