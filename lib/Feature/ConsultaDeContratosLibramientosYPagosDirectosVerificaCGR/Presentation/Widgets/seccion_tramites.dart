import 'package:flutter/material.dart';

import 'verifica_cgr_colores.dart';

/// Sección colapsable con buscador, equivalente al `Accordion` de PrimeVue del
/// portal web.
///
/// Diferencia deliberada con el web: allí el filtro está siempre visible; en
/// móvil solo aparece cuando hay suficientes registros para que filtrar valga
/// la pena, para no gastar alto de pantalla.
class SeccionTramites extends StatefulWidget {
  const SeccionTramites({
    super.key,
    required this.titulo,
    required this.cantidad,
    required this.hintBusqueda,
    required this.constructorHijos,
    this.inicialmenteExpandida = true,
    this.minimoParaFiltrar = 4,
  });

  final String titulo;

  /// Total sin filtrar, para el contador del encabezado.
  final int cantidad;

  final String hintBusqueda;

  /// Recibe el texto del filtro y devuelve las tarjetas a mostrar.
  final List<Widget> Function(String filtro) constructorHijos;

  final bool inicialmenteExpandida;
  final int minimoParaFiltrar;

  @override
  State<SeccionTramites> createState() => _SeccionTramitesState();
}

class _SeccionTramitesState extends State<SeccionTramites> {
  final TextEditingController _controlador = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hijos = widget.constructorHijos(_filtro);
    final mostrarFiltro = widget.cantidad >= widget.minimoParaFiltrar;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: VerificaCgrColores.borde),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // ExpansionTile pinta divisores propios que chocan con el borde.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.inicialmenteExpandida,
          backgroundColor: Colors.white,
          collapsedBackgroundColor: VerificaCgrColores.fondoFila,
          iconColor: VerificaCgrColores.azulBoton,
          collapsedIconColor: VerificaCgrColores.azulMedianoche,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: VerificaCgrColores.azulMedianoche,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: VerificaCgrColores.azulMedianoche,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.cantidad}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          children: [
            if (mostrarFiltro) ...[
              TextField(
                controller: _controlador,
                onChanged: (v) => setState(() => _filtro = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.hintBusqueda,
                  hintStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _filtro.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Limpiar',
                          onPressed: () {
                            _controlador.clear();
                            setState(() => _filtro = '');
                          },
                        ),
                  isDense: true,
                  filled: true,
                  fillColor: VerificaCgrColores.fondoSuave,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: VerificaCgrColores.borde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: VerificaCgrColores.azulBoton,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (hijos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No hay registros que coincidan con la búsqueda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: VerificaCgrColores.textoTenue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...hijos,
          ],
        ),
      ),
    );
  }
}
