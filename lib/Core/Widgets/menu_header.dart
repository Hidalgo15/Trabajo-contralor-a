import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Encabezado azul del menú principal: degradado institucional con la esquina
/// inferior curva, una cúpula grande de marca de agua a la derecha, el logo
/// oficial en blanco y el título grande, ambos centrados.
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
              right: -70,
              top: 18,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.09,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: const BrandLogo(
                      variante: LogoVariante.cupula,
                      height: 240,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // El PNG blanco trae bastante margen transparente, por eso
                      // se usa a una altura alta para que el logo se vea grande.
                      const Center(
                        child: BrandLogo(
                          variante: LogoVariante.blanco,
                          height: 150,
                          semanticLabel:
                              'Contraloría General de la República Dominicana',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppTypography.display,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.15,
                          letterSpacing: -0.3,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
