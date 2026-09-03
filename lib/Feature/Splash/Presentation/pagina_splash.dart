import 'dart:async';
import 'dart:math' as math;

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
    with TickerProviderStateMixin {
  bool _hecho = false;
  bool _arrancado = false;

  /// Tiempo mínimo en pantalla (deja terminar la animación de entrada) y tope
  /// máximo esperando a que carguen las imágenes en conexiones lentas.
  static const _minimoEnPantalla = Duration(milliseconds: 2600);
  static const _topeEspera = Duration(seconds: 7);

  static const _assetLogo = 'assets/logos/logo_contraloria_blanco.png';
  static const _assetCupula = 'assets/logos/cupula-blanca.png';

  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  late final AnimationController _deriva = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat(reverse: true);

  // Animaciones escalonadas del contenido.
  late final Animation<double> _logoAnim = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _textoAnim = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
  );
  late final Animation<double> _pieAnim = CurvedAnimation(
    parent: _entrada,
    curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_arrancado) return;
    _arrancado = true;
    _prepararYAvanzar();
  }

  /// Espera a que el logo y la cúpula queden decodificados antes de pasar al
  /// menú (en 3G tardan), pero nunca menos del mínimo ni más del tope.
  Future<void> _prepararYAvanzar() async {
    final inicio = DateTime.now();

    await Future.wait([
      precacheImage(const AssetImage(_assetLogo), context),
      precacheImage(const AssetImage(_assetCupula), context),
    ]).timeout(_topeEspera, onTimeout: () => const []).catchError(
      (_) => const <void>[],
    );

    final restante = _minimoEnPantalla - DateTime.now().difference(inicio);
    if (restante > Duration.zero) {
      await Future<void>.delayed(restante);
    }
    if (mounted) _avanzar();
  }

  @override
  void dispose() {
    _entrada.dispose();
    _deriva.dispose();
    super.dispose();
  }

  void _avanzar() {
    if (_hecho) return;
    _hecho = true;
    widget.onListo();
  }

  @override
  Widget build(BuildContext context) {
    final altoPantalla = MediaQuery.of(context).size.height;

    return Material(
      color: const Color(0xFF060F24),
      child: GestureDetector(
        onTap: _avanzar,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.1, -0.4),
              radius: 1.15,
              colors: [
                Color(0xFF17427E),
                Color(0xFF0C2551),
                Color(0xFF060F24),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ---- Ondas decorativas ----
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _deriva,
                  builder: (context, _) => CustomPaint(
                    painter: _OlasPainter(fase: _deriva.value),
                  ),
                ),
              ),

              // ---- Cúpula difuminada en la esquina inferior derecha ----
              Positioned(
                right: -104,
                bottom: -48,
                child: AnimatedBuilder(
                  animation: _deriva,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, math.sin(_deriva.value * math.pi) * -8),
                    child: child,
                  ),
                  child: Opacity(
                    opacity: 0.09,
                    child: BrandLogo(
                      variante: LogoVariante.cupulaBlanca,
                      height: altoPantalla * 0.5,
                    ),
                  ),
                ),
              ),

              // ---- Contenido ----
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 5),

                    // Logo con brillo suave y aparición con escala.
                    AnimatedBuilder(
                      animation: Listenable.merge([_logoAnim, _deriva]),
                      builder: (context, child) {
                        final v = _logoAnim.value.clamp(0.0, 1.0);
                        final pulso =
                            0.5 + 0.5 * math.sin(_deriva.value * 2 * math.pi);
                        return Opacity(
                          opacity: v,
                          child: Transform.scale(
                            scale: 0.86 + 0.14 * v,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 260,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withValues(
                                          alpha: (0.06 + 0.05 * pulso) * v,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                child!,
                              ],
                            ),
                          ),
                        );
                      },
                      child: const BrandLogo(
                        variante: LogoVariante.blanco,
                        height: 108,
                        semanticLabel:
                            'Contraloría General de la República Dominicana',
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Lema (entra un instante después del logo).
                    AnimatedBuilder(
                      animation: _textoAnim,
                      builder: (context, child) => Opacity(
                        opacity: _textoAnim.value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, (1 - _textoAnim.value) * 14),
                          child: child,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Eficiencia, Control\ny Transparencia',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTypography.display,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              height: 1.25,
                              letterSpacing: -0.2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 56,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.rojoMarca,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 6),

                    // ---- Pie ----
                    FadeTransition(
                      opacity: _pieAnim,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (final o in const [0.95, 0.3, 0.3])
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: o),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'SERVICIOS EN LÍNEA',
                            style: TextStyle(
                              fontFamily: AppTypography.mono,
                              fontSize: 10,
                              letterSpacing: 3,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ondas de fondo del splash: una clara y tenue arriba y unas bandas de azul
/// profundo apiladas abajo, con una leve deriva animada.
class _OlasPainter extends CustomPainter {
  _OlasPainter({required this.fase});

  /// 0..1 — desplaza los puntos de control para que las ondas "respiren".
  final double fase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final d = (fase - 0.5) * 26; // deriva en px

    // Onda clara superior.
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.16)
        ..cubicTo(w * 0.30, h * 0.02 + d, w * 0.55, h * 0.20 - d, w, h * 0.06)
        ..lineTo(w, 0)
        ..lineTo(0, 0)
        ..close(),
      Paint()..color = Colors.white.withValues(alpha: 0.035),
    );

    // Trazo diagonal fino.
    canvas.drawPath(
      Path()
        ..moveTo(-20, h * 0.34)
        ..cubicTo(
          w * 0.25,
          h * 0.24 + d,
          w * 0.62,
          h * 0.44 - d,
          w + 20,
          h * 0.28,
        ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Bandas de azul profundo apiladas abajo.
    const azules = [
      Color(0x33071B3D),
      Color(0x59061634),
      Color(0x8C05122B),
    ];
    for (var i = 0; i < azules.length; i++) {
      final base = h * (0.70 + i * 0.10);
      final dd = d * (i.isEven ? 1 : -1);
      canvas.drawPath(
        Path()
          ..moveTo(0, base + 34)
          ..cubicTo(
            w * 0.28,
            base - 26 + dd,
            w * 0.64,
            base + 40 - dd,
            w,
            base - 6,
          )
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close(),
        Paint()..color = azules[i],
      );
    }
  }

  @override
  bool shouldRepaint(_OlasPainter old) => old.fase != fase;
}
