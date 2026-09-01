import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icono,
    required this.iconoActivo,
    required this.label,
  });

  final IconData icono;
  final IconData iconoActivo;
  final String label;
}

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.items,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final List<AppBottomNavItem> items;

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animacion;
  double _desde = 0;
  bool _inicializado = false;
  bool _animando = false;

  double _calcularPosicionCentro(int index, double anchoTotal) {
    final total = widget.items.length;
    final anchoItem = anchoTotal / total;
    return anchoItem * index + anchoItem / 2;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _animacion = AlwaysStoppedAnimation(0);
  }

  @override
  void didUpdateWidget(covariant AppBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final anchoTotal = MediaQuery.sizeOf(context).width;
      final double hasta = _calcularPosicionCentro(widget.index, anchoTotal);

      _animacion = Tween<double>(begin: _desde, end: hasta).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
      );
      _desde = hasta;
      setState(() => _animando = true);
      _controller.forward(from: 0).then((_) {
        if (mounted) setState(() => _animando = false);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final insetInferior = MediaQuery.viewPaddingOf(context).bottom;
    final double anchoTotal = MediaQuery.sizeOf(context).width;

    if (!_inicializado) {
      _inicializado = true;
      _desde = _calcularPosicionCentro(widget.index, anchoTotal);
      _animacion = AlwaysStoppedAnimation(_desde);
    }

    const double circleRadius = 24;
    const double barHeight = 80;
    const double curveHalfW = circleRadius + 20;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double rawCenterX = _animacion.value;

        // Desplazar hacia adentro si se sale de la pantalla.
        double centerX = rawCenterX;
        if (centerX - curveHalfW < 0) {
          centerX = curveHalfW;
        } else if (centerX + curveHalfW > anchoTotal) {
          centerX = anchoTotal - curveHalfW;
        }

        return SizedBox(
          height: barHeight + 30 + insetInferior,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Barra con curva.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomPaint(
                  size: Size(anchoTotal, barHeight + insetInferior),
                  painter: _BarraCurvaPainter(
                    color: c.superficie,
                    borderColor: c.borde,
                    notchCenterX: centerX,
                    curveWidth: curveHalfW * 2,
                    curveDepth: 24,
                  ),
                ),
              ),

              // Botones de navegación.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: barHeight + insetInferior,
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.items.length; i++)
                        Expanded(
                          child: _NavButton(
                            item: widget.items[i],
                            oculto: i == widget.index || _animando,
                            insetInferior: insetInferior,
                            onTap: () => widget.onSelect(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Círculo elevado animado (siempre alineado con la curva).
              Positioned(
                left: centerX - circleRadius,
                top: 10,
                child: _BotonCentral(
                  item: widget.items[widget.index],
                  onTap: () => widget.onSelect(widget.index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.oculto,
    required this.insetInferior,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool oculto;
  final double insetInferior;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final color = oculto ? Colors.transparent : c.tenue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(4, 18, 4, insetInferior + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icono, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTypography.cuerpo,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonCentral extends StatelessWidget {
  const _BotonCentral({
    required this.item,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.marca,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.marca.withAlpha(80),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              item.iconoActivo,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontFamily: AppTypography.cuerpo,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.marca,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dibuja la barra inferior con una curva cóncava suave tipo "valle"
/// centrada en [notchCenterX]. Usa cubic bezier para transiciones redondeadas
/// donde la curva se une con la línea recta, como en el sketch del usuario.
class _BarraCurvaPainter extends CustomPainter {
  _BarraCurvaPainter({
    required this.color,
    required this.borderColor,
    required this.notchCenterX,
    required this.curveWidth,
    required this.curveDepth,
  });

  final Color color;
  final Color borderColor;
  final double notchCenterX;
  final double curveWidth;
  final double curveDepth;

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    final double w = size.width;
    final double h = size.height;
    final double top = 20;

    final double halfW = curveWidth / 2;
    final double depth = curveDepth;

    // Puntos donde empieza y termina toda la zona curva.
    final double startX = (notchCenterX - halfW).clamp(0.0, w);
    final double endX = (notchCenterX + halfW).clamp(0.0, w);

    // Puntos intermedios para las transiciones suaves (1/3 y 2/3 del camino).
    final double leftMid = startX + (notchCenterX - startX) * 0.45;
    final double rightMid = notchCenterX + (endX - notchCenterX) * 0.55;

    path.moveTo(0, h);
    path.lineTo(0, top);
    path.lineTo(startX, top);

    // Transición suave izquierda: de plano a bajada.
    path.cubicTo(
      startX + (leftMid - startX) * 0.6, top,
      leftMid - (leftMid - startX) * 0.2, top + depth * 0.3,
      leftMid, top + depth * 0.55,
    );

    // Descenso al fondo del valle.
    path.cubicTo(
      leftMid + (notchCenterX - leftMid) * 0.3, top + depth * 0.9,
      notchCenterX - (notchCenterX - leftMid) * 0.15, top + depth,
      notchCenterX, top + depth,
    );

    // Subida desde el fondo del valle.
    path.cubicTo(
      notchCenterX + (rightMid - notchCenterX) * 0.15, top + depth,
      rightMid - (rightMid - notchCenterX) * 0.3, top + depth * 0.9,
      rightMid, top + depth * 0.55,
    );

    // Transición suave derecha: de bajada a plano.
    path.cubicTo(
      rightMid + (endX - rightMid) * 0.2, top + depth * 0.3,
      endX - (endX - rightMid) * 0.6, top,
      endX, top,
    );

    path.lineTo(w, top);
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(covariant _BarraCurvaPainter oldDelegate) =>
      notchCenterX != oldDelegate.notchCenterX ||
      color != oldDelegate.color;
}
