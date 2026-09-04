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

// --- Geometría de la barra (px lógicos) ---
const double _kAltoBarra = 60; // alto de la barra blanca
const double _kDisco = 38; // diámetro del círculo elevado
const double _kAsoma = 3; // cuánto sobresale el círculo por encima de la barra

/// Barra inferior de la app: barra baja con la pestaña activa dentro de un
/// círculo azul que apenas asoma, encajado en un hueco cuyo borde blanco sigue
/// el contorno del círculo. Al tocar otra pestaña, el círculo y el hueco se
/// deslizan con una transición suave.
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
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  /// Posición interpolada del indicador (en unidades de "índice": 0, 1, 2…).
  late Animation<double> _pos = AlwaysStoppedAnimation(widget.index.toDouble());

  @override
  void didUpdateWidget(covariant AppBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _pos =
          Tween<double>(
            begin: _pos.value,
            end: widget.index.toDouble(),
          ).animate(
            CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
          );
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final insetInferior = MediaQuery.viewPaddingOf(context).bottom;
    final total = widget.items.length;

    final fila = Row(
      children: [
        for (var i = 0; i < total; i++)
          Expanded(
            child: _NavButton(
              item: widget.items[i],
              activo: i == widget.index,
              insetInferior: insetInferior,
              onTap: () => widget.onSelect(i),
            ),
          ),
      ],
    );

    return SizedBox(
      height: _kAltoBarra + insetInferior,
      child: LayoutBuilder(
        builder: (context, cons) {
          final anchoItem = cons.maxWidth / total;
          return AnimatedBuilder(
            animation: _pos,
            child: fila,
            builder: (context, child) {
              final cx = (_pos.value + 0.5) * anchoItem;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BarraPainter(
                        cx: cx,
                        relleno: c.superficie,
                      ),
                    ),
                  ),
                  Positioned.fill(child: child!),
                  Positioned(
                    left: cx - _kDisco / 2,
                    top: -_kAsoma,
                    child: _Disco(item: widget.items[widget.index]),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.activo,
    required this.insetInferior,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool activo;
  final double insetInferior;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final color = activo ? AppColors.marca : c.tenue;

    return Semantics(
      button: true,
      selected: activo,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 9, 4, insetInferior + 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // El ícono se oculta cuando está activo: lo muestra el disco.
              Opacity(
                opacity: activo ? 0 : 1,
                child: Icon(item.icono, size: 21, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 11,
                  fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Disco extends StatelessWidget {
  const _Disco({required this.item});

  final AppBottomNavItem item;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: _kDisco,
        height: _kDisco,
        decoration: const BoxDecoration(
          color: AppColors.marca,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              item.iconoActivo,
              key: ValueKey(item.label),
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pinta la barra: una superficie blanca con un hueco cóncavo centrado en [cx]
/// cuyo borde sigue el contorno del círculo (deja ~6 px de aire). Sin línea ni
/// sombra arriba: el borde es el filo blanco de la propia barra.
class _BarraPainter extends CustomPainter {
  _BarraPainter({required this.cx, required this.relleno});

  final double cx;
  final Color relleno;

  static const double _lineaY = 0; // la barra blanca llega hasta arriba
  static const double _cyDisco = _kDisco / 2 - _kAsoma; // centro del círculo
  // El hueco es más chico que el disco: la barra pasa ~3 px por detrás del
  // borde del círculo, así no queda ningún filo de fondo asomando.
  static const double _radio = _kDisco / 2 - 3;
  static const double _hombro = _radio + 13; // medio ancho del hueco

  @override
  void paint(Canvas canvas, Size size) {
    final by = _cyDisco + _radio; // fondo del hueco
    final barra = Path()
      ..moveTo(0, _lineaY)
      ..lineTo(cx - _hombro, _lineaY)
      ..cubicTo(cx - _hombro * 0.5, _lineaY, cx - _radio, by, cx, by)
      ..cubicTo(
        cx + _radio,
        by,
        cx + _hombro * 0.5,
        _lineaY,
        cx + _hombro,
        _lineaY,
      )
      ..lineTo(size.width, _lineaY)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(barra, Paint()..color = relleno);
  }

  @override
  bool shouldRepaint(covariant _BarraPainter old) =>
      old.cx != cx || old.relleno != relleno;
}
