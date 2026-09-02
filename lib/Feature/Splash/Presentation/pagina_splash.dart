import 'dart:async';

import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Pantalla de bienvenida que se muestra al abrir la app, antes del menú.
/// Avanza sola a los ~2,2 s o en cuanto el usuario toca.
class PaginaSplash extends StatefulWidget {
  const PaginaSplash({super.key, required this.onListo});

  /// Se llama una sola vez cuando el splash termina (por tiempo o por toque).
  final VoidCallback onListo;

  @override
  State<PaginaSplash> createState() => _PaginaSplashState();
}

class _PaginaSplashState extends State<PaginaSplash>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _hecho = false;

  late final AnimationController _flote = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2200), _avanzar);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flote.dispose();
    super.dispose();
  }

  void _avanzar() {
    if (_hecho) return;
    _hecho = true;
    _timer?.cancel();
    widget.onListo();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.marca,
      child: GestureDetector(
        onTap: _avanzar,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.marcaProfundo,
                AppColors.marca,
                Color(0xFF00224A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 6),

                // ---- Cúpula flotando ----
                AnimatedBuilder(
                  animation: _flote,
                  builder: (context, child) {
                    final t = Curves.easeInOut.transform(_flote.value);
                    return Transform.translate(
                      offset: Offset(0, -6 + t * 12),
                      child: child,
                    );
                  },
                  child: const BrandLogo(
                    variante: LogoVariante.blanco,
                    height: 118,
                    semanticLabel:
                        'Contraloría General de la República Dominicana',
                  ),
                ),

                const SizedBox(height: 26),

                // ---- Lema ----
                const Text(
                  'Eficiencia, Control\ny Transparencia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.display,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.25,
                    letterSpacing: -0.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 52,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.rojoMarca,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),

                const Spacer(flex: 5),

                // ---- Pie ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final o in const [0.9, 0.6, 0.35])
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: o),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'SERVICIOS EN LÍNEA',
                  style: TextStyle(
                    fontFamily: AppTypography.mono,
                    fontSize: 11,
                    letterSpacing: 2.2,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
