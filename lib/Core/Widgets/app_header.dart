import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Qué muestra el botón izquierdo del encabezado.
enum HeaderLeading {
  /// Flecha que hace `Navigator.maybePop`.
  atras,

  /// Sin botón (se reserva el espacio para mantener el centrado).
  ninguno,
}

/// Barra superior azul del rediseño. No es un [AppBar]: es contenido normal que
/// se pone como primer hijo de la pantalla, con el degradado institucional y el
/// área segura de la barra de estado ya resuelta.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.titulo,
    this.mostrarLogo = false,
    this.leading = HeaderLeading.ninguno,
    this.accion,
  });

  /// Título de texto. Se ignora si [mostrarLogo] es `true`.
  final String? titulo;

  /// Muestra el lockup del logo centrado en vez del título.
  final bool mostrarLogo;

  final HeaderLeading leading;

  /// Widget opcional a la derecha (normalmente un [HeaderButton]).
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    Widget centro;
    if (mostrarLogo) {
      centro = Center(
        child: Semantics(
          header: true,
          label: 'Contraloría General de la República',
          excludeSemantics: true,
          child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // La cúpula es azul; sobre la barra azul la pintamos en blanco.
            const ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: BrandLogo(variante: LogoVariante.cupula, height: 26),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                'CONTRALORÍA GENERAL\nDE LA REPÚBLICA',
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  height: 1.15,
                  letterSpacing: 0.4,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ),
          ],
          ),
        ),
      );
    } else {
      centro = Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Semantics(
          header: true,
          child: Text(
            titulo ?? '',
            style: const TextStyle(
              fontFamily: AppTypography.display,
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.marca, AppColors.marcaProfundo],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, AppDimens.md + 2),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                _leading(context),
                Expanded(child: centro),
                accion ?? const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _leading(BuildContext context) {
    switch (leading) {
      case HeaderLeading.atras:
        return HeaderButton(
          icono: Icons.arrow_back,
          tooltip: 'Volver',
          onTap: () => Navigator.of(context).maybePop(),
        );
      case HeaderLeading.ninguno:
        return const SizedBox(width: 44);
    }
  }
}

/// Botón cuadrado translúcido de la barra superior.
class HeaderButton extends StatelessWidget {
  const HeaderButton({
    super.key,
    required this.icono,
    required this.onTap,
    this.tooltip,
  });

  final IconData icono;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final boton = Material(
      color: Colors.white.withValues(alpha: 0.13),
      borderRadius: BorderRadius.circular(AppDimens.radioSm + 1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radioSm + 1),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icono, color: Colors.white, size: 20),
        ),
      ),
    );
    return tooltip == null ? boton : Tooltip(message: tooltip!, child: boton);
  }
}
