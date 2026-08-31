import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Core/Navigation/app_shell.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_colors.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_dimens.dart';
import 'package:consultas_y_contrataciones/Core/Theme/app_typography.dart';
import 'package:consultas_y_contrataciones/Core/Widgets/app_header.dart';

class PaginaAjustes extends StatelessWidget {
  const PaginaAjustes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    final scope = AppShellScope.of(context);

    return Column(
      children: [
        const AppHeader(titulo: 'Ajustes'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg,
              AppDimens.lg,
              AppDimens.xl,
            ),
            children: [
              _Grupo(
                children: [
                  _Fila(
                    icono: Icons.brightness_6_outlined,
                    label: 'Tema',
                    trailing: const _SegmentoTema(),
                  ),
                  _Fila(
                    icono: Icons.language_outlined,
                    label: 'Idioma',
                    valor: 'Español',
                    onTap: () {},
                  ),
                  _Fila(
                    icono: Icons.format_size_outlined,
                    label: 'Tamaño de texto',
                    valor: 'Estándar',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              _Grupo(
                children: [
                  _Fila(
                    icono: Icons.help_outline,
                    label: 'Ayuda y preguntas frecuentes',
                    onTap: () => scope.irAPestana(AppTab.ayuda),
                  ),
                  _Fila(
                    icono: Icons.account_balance_outlined,
                    label: 'Acerca de la Contraloría',
                    onTap: () {},
                  ),
                  _Fila(
                    icono: Icons.description_outlined,
                    label: 'Licencias de código abierto',
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'Portal de Consultas CGR',
                      applicationVersion: '2.0.0',
                    ),
                  ),
                  _Fila(
                    icono: Icons.call_outlined,
                    label: 'Contacto',
                    valor: '(809) 682-1677',
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              Text(
                'Contraloría General de la República · versión 2.0.0',
                textAlign: TextAlign.center,
                style: AppTypography.datos(color: c.tenue, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Grupo extends StatelessWidget {
  const _Grupo({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      decoration: BoxDecoration(
        color: c.superficie,
        border: Border.all(color: c.borde),
        borderRadius: BorderRadius.circular(AppDimens.radioMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, color: c.borde),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.icono,
    required this.label,
    this.valor,
    this.trailing,
    this.onTap,
  });

  final IconData icono;
  final String label;
  final String? valor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colores;

    Widget? cola = trailing;
    cola ??= (onTap != null || valor != null)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (valor != null)
                Text(
                  valor!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.tenue),
                ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: c.tenue),
              ],
            ],
          )
        : null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md + 2,
          vertical: AppDimens.md + 1,
        ),
        child: Row(
          children: [
            Icon(icono, size: 18, color: c.azul),
            const SizedBox(width: AppDimens.md - 1),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTypography.cuerpo,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            ?cola,
          ],
        ),
      ),
    );
  }
}

/// Segmento Auto / Claro / Oscuro. Por ahora solo visual; el cambio de tema
/// real llega en la Fase 3.
class _SegmentoTema extends StatefulWidget {
  const _SegmentoTema();

  @override
  State<_SegmentoTema> createState() => _SegmentoTemaState();
}

class _SegmentoTemaState extends State<_SegmentoTema> {
  int _sel = 1;
  static const _opciones = ['Auto', 'Claro', 'Oscuro'];

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.superficieAlt,
        borderRadius: BorderRadius.circular(AppDimens.radioSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _opciones.length; i++)
            GestureDetector(
              onTap: () => setState(() => _sel = i),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: i == _sel ? c.azul : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  _opciones[i],
                  style: TextStyle(
                    fontFamily: AppTypography.cuerpo,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: i == _sel ? Colors.white : c.tenue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
