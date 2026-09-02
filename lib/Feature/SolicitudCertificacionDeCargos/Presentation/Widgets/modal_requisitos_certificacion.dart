import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_button.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_text_field.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/aviso_box.dart';
import 'package:consultas_y_contrataciones/Feature/SolicitudCertificacionDeCargos/Data/instituciones_certificadas.dart';

/// Modal que aparece al entrar a la Solicitud de Certificación de Cargos.
/// Réplica del modal del portal web: dos pestañas ("Requisitos" e
/// "Instituciones certificadas por Contraloría"). La diferencia con la web es
/// que aquí los motivos de solicitud van en secciones colapsables.
Future<void> mostrarRequisitosCertificacion(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _ModalRequisitos(),
  );
}

class _ModalRequisitos extends StatelessWidget {
  const _ModalRequisitos();

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final alto = MediaQuery.of(context).size.height * 0.82;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.xl,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radioLg),
      ),
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          width: double.infinity,
          height: alto,
          child: Column(
            children: [
              // ---- Encabezado ----
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg,
                  AppDimens.md,
                  AppDimens.sm,
                  0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Requisitos para solicitar una certificación de '
                          'cargos',
                          style: TextStyle(
                            fontFamily: AppTypography.display,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.25,
                            color: c.azul,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20, color: c.tenue),
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: c.azul,
                unselectedLabelColor: c.tenue,
                indicatorColor: c.azul,
                labelStyle: const TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: AppTypography.display,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Requisitos'),
                  Tab(text: 'Instituciones certificadas'),
                ],
              ),
              Divider(height: 1, color: c.borde),
              const Expanded(
                child: TabBarView(
                  children: [
                    _TabRequisitos(),
                    _TabInstituciones(),
                  ],
                ),
              ),
              // ---- Pie ----
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.md),
                  child: AppButton(
                    label: 'Entendido',
                    icono: Icons.check,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pestaña 1 · Requisitos
// ---------------------------------------------------------------------------

class _TabRequisitos extends StatelessWidget {
  const _TabRequisitos();

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return ListView(
      padding: const EdgeInsets.all(AppDimens.lg),
      children: [
        const AvisoBox(
          texto:
              'Los documentos deben estar en formato PDF o imagen y no superar '
              'los 4 MB. Deben ser legibles; de lo contrario, la solicitud '
              'podría ser devuelta.',
        ),
        const SizedBox(height: AppDimens.lg),
        Text(
          'Dependiendo el motivo de su solicitud, debe adjuntar:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: c.tinta,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppDimens.md),
        const _SeccionColapsable(
          titulo: 'Para pensiones, jubilaciones y tiempo en servicio en el '
              'Estado',
          inicialAbierta: true,
          items: [
            'Copia de la cédula.',
            'Cartas de certificación laboral de las instituciones donde labora '
                'o ha laborado.',
          ],
        ),
        const _SeccionColapsable(
          titulo: 'Para pago de prestaciones laborales',
          items: [
            'Copia de la cédula.',
            'Cartas de certificación laboral de las instituciones donde labora '
                'o ha laborado.',
            'Carta de desvinculación del último empleo.',
          ],
        ),
        const _SeccionColapsable(
          titulo: 'Para uso en el extranjero',
          items: [
            'Copia de la cédula.',
            'Cartas de certificación laboral de las instituciones donde labora '
                'o ha laborado.',
            'Carta del solicitante explicando el motivo de la certificación, '
                'dirigida a la Máxima Autoridad de la Contraloría.',
            'Documentos oficiales del país al que va dirigida.',
          ],
        ),
      ],
    );
  }
}

/// Sección de motivo con lista de documentos, colapsable con un toque.
class _SeccionColapsable extends StatefulWidget {
  const _SeccionColapsable({
    required this.titulo,
    required this.items,
    this.inicialAbierta = false,
  });

  final String titulo;
  final List<String> items;
  final bool inicialAbierta;

  @override
  State<_SeccionColapsable> createState() => _SeccionColapsableState();
}

class _SeccionColapsableState extends State<_SeccionColapsable> {
  late bool _abierta = widget.inicialAbierta;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.sm),
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border.all(color: c.borde),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _abierta = !_abierta),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.md,
                AppDimens.md,
                AppDimens.md - 2,
                AppDimens.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.titulo,
                      style: TextStyle(
                        fontFamily: AppTypography.display,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        height: 1.3,
                        color: c.azul,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _abierta ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more, size: 22, color: c.tenue),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _abierta
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.md,
                      0,
                      AppDimens.md,
                      AppDimens.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(height: 1, color: c.borde),
                        const SizedBox(height: AppDimens.md),
                        for (var i = 0; i < widget.items.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == widget.items.length - 1
                                  ? 0
                                  : AppDimens.sm,
                            ),
                            child: _ItemNumerado(
                              numero: i + 1,
                              texto: widget.items[i],
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _ItemNumerado extends StatelessWidget {
  const _ItemNumerado({required this.numero, required this.texto});

  final int numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$numero.',
          style: AppTypography.datos(
            color: c.azul,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: c.tinta,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pestaña 2 · Instituciones certificadas
// ---------------------------------------------------------------------------

class _TabInstituciones extends StatefulWidget {
  const _TabInstituciones();

  @override
  State<_TabInstituciones> createState() => _TabInstitucionesState();
}

class _TabInstitucionesState extends State<_TabInstituciones> {
  final TextEditingController _busqueda = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final lista = _filtro.isEmpty
        ? institucionesCertificadas
        : institucionesCertificadas
              .where((i) => i.toLowerCase().contains(_filtro))
              .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.lg,
            AppDimens.md,
            AppDimens.lg,
            AppDimens.sm,
          ),
          child: Column(
            children: [
              const AvisoBox(
                texto:
                    'Verifique que la institución de los cargos que desea '
                    'certificar esté en este listado.',
              ),
              const SizedBox(height: AppDimens.md),
              AppTextField(
                controller: _busqueda,
                hint: 'Buscar institución',
                prefixIcon: Icons.search,
                datos: false,
                onChanged: (v) =>
                    setState(() => _filtro = v.trim().toLowerCase()),
              ),
            ],
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? Center(
                  child: Text(
                    'Sin resultados para "${_busqueda.text.trim()}".',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: c.tenue),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.lg,
                    AppDimens.sm,
                    AppDimens.lg,
                    AppDimens.lg,
                  ),
                  itemCount: lista.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: c.borde),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: c.azul,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lista[i],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: c.tinta, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
