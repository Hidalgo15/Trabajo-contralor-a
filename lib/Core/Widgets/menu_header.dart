import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Encabezado azul del menú principal: degradado institucional con la esquina
/// inferior curva, una cúpula tenue de marca de agua a la derecha, el logo
/// oficial en blanco y un único título centrado.
///
/// El color es fijo (marca / marcaProfundo): se ve igual en tema claro y oscuro,
/// igual que la barra superior y el pie.
class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key, this.titulo = 'Servicios y Consultas CGR'});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
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
              right: -46,
              top: 34,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.08,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: const BrandLogo(
                      variante: LogoVariante.cupula,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BrandLogo(
                      variante: LogoVariante.blanco,
                      height: 54,
                      semanticLabel:
                          'Contraloría General de la República Dominicana',
                    ),
                    const SizedBox(height: 14),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.display,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.2,
                        color: Colors.white,
                      ),
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
