import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';

/// Variantes del logo oficial de la Contraloría.
enum LogoVariante {
  /// Lockup completo a color (cúpula + "Gobierno de la RD" + "Contraloría").
  completo,

  /// Lockup completo en blanco, para fondos azules.
  blanco,

  /// Solo la cúpula, en azul. Marca compacta para barras y chips.
  cupula,
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.variante = LogoVariante.completo,
    this.height = 96,
    this.semanticLabel,
  });

  final LogoVariante variante;
  final double height;

  /// Etiqueta para lectores de pantalla. `null` = decorativo (se ignora).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final asset = switch (variante) {
      LogoVariante.completo => 'assets/logos/logo_contraloria.png',
      LogoVariante.blanco => 'assets/logos/logo_contraloria_blanco.png',
      LogoVariante.cupula => 'assets/logos/contraloria_azul.png',
    };

    final colorFallback =
        variante == LogoVariante.blanco ? Colors.white : context.colores.azul;

    return Image.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      errorBuilder: (_, _, _) => Icon(
        Icons.account_balance,
        size: height * 0.8,
        color: colorFallback,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
