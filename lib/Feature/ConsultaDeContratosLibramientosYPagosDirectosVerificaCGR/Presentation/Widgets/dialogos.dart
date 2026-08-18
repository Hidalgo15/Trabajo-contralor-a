import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Formatos/formatos.dart';
import 'verifica_cgr_colores.dart';

/// Diálogo "Base Legal Institucional".
///
/// El texto es normativo y está copiado palabra por palabra del portal web
/// (`ConsultaForm.vue`). Si cambia allá, tiene que cambiar aquí: no pueden
/// circular dos versiones distintas del fundamento jurídico.
Future<void> mostrarBaseLegal(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Base Legal Institucional',
        style: TextStyle(
          color: VerificaCgrColores.azulMedianoche,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Esta sección de consulta se fundamenta en el marco jurídico que '
              'regula la transparencia, el control interno y las aprobaciones '
              'de pago realizadas por la Contraloría General de la República, '
              'garantizando la integridad y legalidad en el uso de los recursos '
              'públicos del Estado.',
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Fundamento jurídico:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            SizedBox(height: 8),
            _Vineta(
              negrita: 'Constitución de la República Dominicana: ',
              texto: 'Artículo 246 y 247.',
            ),
            _Vineta(
              negrita: 'Ley No. 10-07: ',
              texto: 'que instituye el Sistema Nacional de Control Interno y '
                  'de la Contraloría General de la República y su Reglamento '
                  'de Aplicación No. 491-07.',
            ),
            _Vineta(
              negrita: 'Ley No. 200-04: ',
              texto: 'sobre Libre Acceso a la Información Pública.',
            ),
            SizedBox(height: 12),
            Text(
              'La Contraloría General de la República ejerce la fiscalización '
              'interna y la autorización de pagos conforme a este marco legal, '
              'en apego a los principios de transparencia, eficiencia y '
              'responsabilidad administrativa.',
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Cerrar'),
          style: TextButton.styleFrom(
            foregroundColor: VerificaCgrColores.azulBoton,
          ),
        ),
      ],
    ),
  );
}

class _Vineta extends StatelessWidget {
  const _Vineta({required this.negrita, required this.texto});

  final String negrita;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: VerificaCgrColores.texto,
                ),
                children: [
                  TextSpan(
                    text: negrita,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: texto),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo con el concepto completo de un contrato.
Future<void> mostrarConcepto(BuildContext context, String concepto) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Concepto completo',
        style: TextStyle(
          color: VerificaCgrColores.azulMedianoche,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          Formatos.capitalizar(concepto),
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.5, fontSize: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: VerificaCgrColores.azulBoton,
          ),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}
