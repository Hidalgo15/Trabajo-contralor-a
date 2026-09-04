import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/olas_decorativas.dart';

/// Overlay reutilizable para bloquear la pantalla durante una operación.
/// Puramente visual (sin texto): un anillo luminoso girando con el ícono de
/// consulta al centro, sobre el mismo fondo azul con ondas y cúpula que usa
/// el splash. Se usa igual en todas las consultas.
class AppLoadingOverlay extends StatefulWidget {
  const AppLoadingOverlay({super.key, required this.message});

  /// El overlay ya no muestra texto; se conserva el parámetro para no romper
  /// a quien llama `mostrarCargando('...')`.
  final String message;

  @override
  State<AppLoadingOverlay> createState() => _AppLoadingOverlayState();
}

class _AppLoadingOverlayState extends State<AppLoadingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _giro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  late final AnimationController _deriva = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _giro.dispose();
    _deriva.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tamanoPantalla = MediaQuery.sizeOf(context);
    final anchoPantalla = tamanoPantalla.width;
    final tamanoAnillo = (anchoPantalla * 0.84).clamp(220.0, 360.0);

    return Positioned.fill(
      child: DecoratedBox(
        decoration: fondoOscuroDecoracion,
        child: Stack(
          children: [
            // ---- Ondas decorativas (mismo painter que el splash, en toda
            // la pantalla: las bandas oscuras ya caen cerca del borde
            // inferior) ----
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _deriva,
                builder: (context, _) => CustomPaint(
                  painter: OlasDecorativasPainter(fase: _deriva.value),
                ),
              ),
            ),

            // ---- Cúpula casi imperceptible, saliendo de detrás del anillo,
            // centrada vertical pero corrida a la derecha ----
            Center(
              child: AnimatedBuilder(
                animation: _deriva,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    anchoPantalla * 0.28,
                    -tamanoAnillo * 0.4 +
                        math.sin(_deriva.value * math.pi) * -6,
                  ),
                  child: child,
                ),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color.fromARGB(122, 22, 64, 126),
                    BlendMode.srcIn,
                  ),
                  child: BrandLogo(
                    variante: LogoVariante.cupulaBlanca,
                    height: tamanoAnillo * 1.7,
                  ),
                ),
              ),
            ),

            // ---- Chispita en forma de diamante ----
            const Positioned(right: 58, top: 46, child: _Diamante()),

            // ---- Anillo con el ícono de la consulta ----
            Center(
              child: SizedBox(
                width: tamanoAnillo,
                height: tamanoAnillo,
                child: AnimatedBuilder(
                  animation: _giro,
                  builder: (context, _) => _AnilloDeCarga(
                    progreso: _giro.value,
                    tamano: tamanoAnillo,
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

class _Diamante extends StatelessWidget {
  const _Diamante();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: const Color(0xFF7FD8FF).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Anillo con degradado tipo "cometa" girando, chispas titilando alrededor y
/// el ícono de la consulta con un resplandor suave al centro. Todo escala en
/// función de [tamano] (el ancho/alto real del widget).
class _AnilloDeCarga extends StatelessWidget {
  const _AnilloDeCarga({required this.progreso, required this.tamano});

  final double progreso;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final escala = tamano / 150;
    double e(double v) => v * escala;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _Chispa(
          progreso: progreso,
          fase: 0.10,
          dx: e(-60),
          dy: e(30),
          tamano: e(6),
          color: AppColors.rojoMarca,
        ),
        _Chispa(
          progreso: progreso,
          fase: 0.55,
          dx: e(56),
          dy: e(-44),
          tamano: e(5),
          color: const Color(0xFF7FD8FF),
        ),
        _Chispa(
          progreso: progreso,
          fase: 0.80,
          dx: e(52),
          dy: e(46),
          tamano: e(4),
          color: AppColors.rojoMarca,
        ),
        _Chispa(
          progreso: progreso,
          fase: 0.30,
          dx: e(-48),
          dy: e(-50),
          tamano: e(4),
          color: const Color(0xFF7FD8FF),
        ),
        CustomPaint(
          size: Size.square(e(112)),
          painter: _AroPainter(progreso: progreso),
        ),
        Container(
          width: e(80),
          height: e(80),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0x2EFFFFFF), Colors.transparent],
            ),
          ),
        ),
        BrandLogo(
          variante: LogoVariante.cupulaBlanca,
          height: e(52),
          semanticLabel: 'Contraloría General de la República Dominicana',
        ),
      ],
    );
  }
}

/// Puntito de acento que titila (cambia de opacidad) con un ciclo propio.
class _Chispa extends StatelessWidget {
  const _Chispa({
    required this.progreso,
    required this.fase,
    required this.dx,
    required this.dy,
    required this.tamano,
    required this.color,
  });

  final double progreso;
  final double fase;
  final double dx;
  final double dy;
  final double tamano;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ciclo = (progreso + fase) % 1.0;
    final alpha = 0.2 + 0.8 * (0.5 + 0.5 * math.sin(ciclo * 2 * math.pi));

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: alpha),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: alpha * 0.6),
              blurRadius: tamano,
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinta la pista tenue y el arco brillante ("cometa") que gira según
/// [progreso], con una chispa blanca en la punta.
class _AroPainter extends CustomPainter {
  _AroPainter({required this.progreso});

  final double progreso;

  static const double _dosPi = 6.283185307179586;

  @override
  void paint(Canvas canvas, Size size) {
    // El grosor y el inset escalan con el tamaño real del canvas (referencia:
    // 112 px de base, igual que en el diseño original).
    final grosor = size.width * 0.0625;
    final center = size.center(Offset.zero);
    final radio = size.width / 2 - grosor * 0.85;
    final rect = Rect.fromCircle(center: center, radius: radio);

    canvas.drawArc(
      rect,
      0,
      _dosPi,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = grosor,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progreso * _dosPi);
    canvas.translate(-center.dx, -center.dy);

    final Shader gradiente = const SweepGradient(
      colors: [
        Color(0xFFBFEEFF),
        Color(0xFF7FD8FF),
        Color(0xFF2F6BC7),
        Color(0x552F6BC7),
        Colors.transparent,
        Colors.transparent,
      ],
      stops: [0.0, 0.18, 0.45, 0.72, 0.85, 1.0],
    ).createShader(rect);

    canvas.drawArc(
      rect,
      0,
      _dosPi,
      false,
      Paint()
        ..shader = gradiente
        ..style = PaintingStyle.stroke
        ..strokeWidth = grosor
        ..strokeCap = StrokeCap.round,
    );

    final punta = center + Offset(radio, 0);
    canvas.drawCircle(
      punta,
      grosor * 0.86,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, grosor * 0.72),
    );
    canvas.drawCircle(punta, grosor * 0.43, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AroPainter old) => old.progreso != progreso;
}
