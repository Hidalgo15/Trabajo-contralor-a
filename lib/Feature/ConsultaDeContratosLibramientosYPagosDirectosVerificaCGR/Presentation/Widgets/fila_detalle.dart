import 'package:flutter/material.dart';

import 'verifica_cgr_colores.dart';

/// Fila etiqueta/valor.
///
/// En el portal web esto es una tabla de 4 columnas; en 360 dp no cabe, así que
/// se apila: etiqueta arriba en azul, valor debajo. Es la misma adaptación que
/// hace el CSS del portal en `@media (max-width: 768px)`.
class FilaDetalle extends StatelessWidget {
  const FilaDetalle({
    super.key,
    required this.etiqueta,
    this.valor,
    this.contenido,
    this.enfatizarValor = false,
  }) : assert(
          valor != null || contenido != null,
          'FilaDetalle necesita un valor o un contenido',
        );

  final String etiqueta;
  final String? valor;

  /// Alternativa a [valor] cuando hay que pintar un widget (una pastilla de
  /// estado, un botón "Ver más"...).
  final Widget? contenido;

  /// Para montos: negrita y un poco más grande.
  final bool enfatizarValor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: VerificaCgrColores.azulMedianoche,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          contenido ??
              Text(
                valor!,
                style: TextStyle(
                  fontSize: enfatizarValor ? 15 : 14,
                  fontWeight:
                      enfatizarValor ? FontWeight.w700 : FontWeight.normal,
                  color: VerificaCgrColores.texto,
                  height: 1.35,
                ),
              ),
        ],
      ),
    );
  }
}

/// Divisor tenue entre filas.
class DivisorFila extends StatelessWidget {
  const DivisorFila({super.key});

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        color: VerificaCgrColores.bordeSuave,
      );
}

/// Envoltura común de las tarjetas de resultado: franja azul a la izquierda,
/// encabezado con la institución y botón de descarga.
class TarjetaResultado extends StatelessWidget {
  const TarjetaResultado({
    super.key,
    required this.institucion,
    required this.hijos,
    this.onDescargar,
  });

  final String institucion;
  final List<Widget> hijos;
  final VoidCallback? onDescargar;

  @override
  Widget build(BuildContext context) {
    // El acento azul de la izquierda es una franja aparte, NO un `Border` con
    // el lado izquierdo más grueso: Flutter no permite combinar un borde de
    // lados desiguales con `borderRadius` y lanza excepción al pintar.
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: VerificaCgrColores.borde),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              width: 4,
              child: ColoredBox(color: VerificaCgrColores.azulMedianoche),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FB),
                      border: Border(
                        bottom:
                            BorderSide(color: VerificaCgrColores.bordeSuave),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            institucion,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: VerificaCgrColores.azulMedianoche,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (onDescargar != null)
                          IconButton(
                            onPressed: onDescargar,
                            icon: const Icon(Icons.download_rounded),
                            color: VerificaCgrColores.azulBoton,
                            tooltip: 'Descargar PDF',
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: hijos,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
