import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/brand_logo.dart';

/// Pie institucional del rediseño: bloque blanco con el logo y los valores,
/// más un bloque azul con enlaces, contacto y redes. Va al final del Inicio.
class InstitutionalFooter extends StatelessWidget {
  const InstitutionalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: c.superficie,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            children: [
              const BrandLogo(variante: LogoVariante.completo, height: 52),
              const SizedBox(height: 8),
              Text(
                'Contraloría General de la\nRepública Dominicana',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.25,
                  color: c.azul,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Transparencia · Integridad · Eficiencia',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c.tenue, letterSpacing: 0.2),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.marca, AppColors.marcaProfundo],
            ),
            border: Border(
              top: BorderSide(color: AppColors.rojoMarca, width: 3),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: _ColumnaPie(
                      icono: Icons.info_outline,
                      titulo: 'Acerca',
                      lineas: ['Quiénes somos', 'Marco legal'],
                    ),
                  ),
                  Expanded(
                    child: _ColumnaPie(
                      icono: Icons.link,
                      titulo: 'Enlaces',
                      lineas: ['Portal Web', 'Transparencia'],
                    ),
                  ),
                  Expanded(
                    child: _ColumnaPie(
                      icono: Icons.call_outlined,
                      titulo: 'Contacto',
                      lineas: ['(809) 682-1677', 'contacto@\ncontraloria.gob.do'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _IconoRed(Icons.facebook),
                  SizedBox(width: 12),
                  _IconoRed(Icons.alternate_email),
                  SizedBox(width: 12),
                  _IconoRed(Icons.camera_alt_outlined),
                  SizedBox(width: 12),
                  _IconoRed(Icons.play_circle_outline),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '© 2025 Contraloría General de la República.\nTodos los derechos reservados.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontSize: 10,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColumnaPie extends StatelessWidget {
  const _ColumnaPie({
    required this.icono,
    required this.titulo,
    required this.lineas,
  });

  final IconData icono;
  final String titulo;
  final List<String> lineas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              titulo.toUpperCase(),
              style: const TextStyle(
                fontFamily: AppTypography.cuerpo,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          lineas.join('\n'),
          style: TextStyle(
            fontFamily: AppTypography.cuerpo,
            fontSize: 10,
            height: 1.5,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _IconoRed extends StatelessWidget {
  const _IconoRed(this.icono);

  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
      ),
      child: Icon(icono, size: 15, color: Colors.white),
    );
  }
}
