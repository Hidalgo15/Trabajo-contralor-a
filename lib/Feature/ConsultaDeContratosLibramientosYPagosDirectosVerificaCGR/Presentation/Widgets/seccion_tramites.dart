import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';

/// Sección colapsable con buscador (equivale al acordeón del portal web). El
/// filtro solo aparece cuando hay suficientes registros para que valga la pena.
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
  final int cantidad;
  final String hintBusqueda;
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
    final c = context.colores;
    final hijos = widget.constructorHijos(_filtro);
    final mostrarFiltro = widget.cantidad >= widget.minimoParaFiltrar;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.md),
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border.all(color: c.borde),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.inicialmenteExpandida,
          backgroundColor: c.superficie,
          collapsedBackgroundColor: c.superficieAlt,
          iconColor: c.azulEnlace,
          collapsedIconColor: c.azul,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.titulo,
                  style: TextStyle(
                    fontFamily: AppTypography.display,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.azul,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: c.azul,
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
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (hijos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No hay registros que coincidan con la búsqueda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: c.tenue,
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
