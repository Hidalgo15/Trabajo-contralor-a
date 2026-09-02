import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Ámbito de la nómina que se está consultando. Las dos entradas del menú
/// ("Gobierno Central" y "Descentralizados") abren las mismas pantallas; el
/// ámbito solo cambia los textos para que el usuario sepa qué está consultando.
enum AmbitoEmpleados { central, descentralizado }

extension AmbitoEmpleadosX on AmbitoEmpleados {
  ({String texto, IconData icono}) get pastilla => switch (this) {
    AmbitoEmpleados.central => (
      texto: 'Gobierno Central',
      icono: Icons.account_balance_outlined,
    ),
    AmbitoEmpleados.descentralizado => (
      texto: 'Descentralizados',
      icono: Icons.diversity_3_outlined,
    ),
  };

  String get descripcion => switch (this) {
    AmbitoEmpleados.central =>
      'Consulta la nómina del Gobierno Central por número de cédula del '
          'servidor.',
    AmbitoEmpleados.descentralizado =>
      'Consulta la nómina de las instituciones descentralizadas y autónomas '
          'por número de cédula.',
  };
}

/// Pastilla azul que indica qué nómina se está consultando (Gobierno Central
/// o instituciones descentralizadas).
class PastillaAmbito extends StatelessWidget {
  const PastillaAmbito(this.ambito, {super.key});

  final AmbitoEmpleados ambito;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final p = ambito.pastilla;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 11, 4),
      decoration: BoxDecoration(
        color: c.azul,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(p.icono, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            p.texto,
            style: const TextStyle(
              fontFamily: AppTypography.display,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
