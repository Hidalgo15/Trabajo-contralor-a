import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaverificacgr.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Presentation/paginaconsultaempleados.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeCertificaciónDeCargos/Presentation/paginaconsultacontraloria.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaCorrespondencia/Presentation/paginaconsultacorrespondencia.dart';

/// Los cuatro servicios reales de la app. Es la única fuente de verdad: el
/// Inicio (accesos rápidos), la pantalla de Servicios y el menú lateral leen
/// de aquí.
enum ServicioId { verificaCgr, empleados, certificacion, correspondencia }

class ServicioApp {
  const ServicioApp({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.descripcion,
    required this.icono,
    required this.pantalla,
  });

  final ServicioId id;
  final String titulo;

  /// Texto corto para las tarjetas de "accesos rápidos".
  final String resumen;

  /// Texto largo para las fichas de la pantalla de Servicios.
  final String descripcion;

  final IconData icono;

  /// Constructora de la pantalla del servicio.
  final Widget Function() pantalla;
}

Widget _verificaCgr() => const PaginaVerificaCgr();
Widget _empleados() => const PaginaConsultaEmpleados();
Widget _certificacion() => const PaginaConsultaContraloria();
Widget _correspondencia() => const PaginaConsultaCorrespondencia();

const List<ServicioApp> serviciosApp = <ServicioApp>[
  ServicioApp(
    id: ServicioId.verificaCgr,
    titulo: 'Verifica CGR',
    resumen: 'Consulta trámites',
    descripcion: 'Contratos, libramientos y pagos directos de proveedores.',
    icono: Icons.verified_outlined,
    pantalla: _verificaCgr,
  ),
  ServicioApp(
    id: ServicioId.empleados,
    titulo: 'Empleados del Estado',
    resumen: 'Nómina y salarios',
    descripcion: 'Nómina pública, cargos y salarios por cédula.',
    icono: Icons.badge_outlined,
    pantalla: _empleados,
  ),
  ServicioApp(
    id: ServicioId.certificacion,
    titulo: 'Certificación de Cargos',
    resumen: 'Estado de solicitudes',
    descripcion: 'Estatus de tu solicitud de certificación de cargos.',
    icono: Icons.assignment_ind_outlined,
    pantalla: _certificacion,
  ),
  ServicioApp(
    id: ServicioId.correspondencia,
    titulo: 'Correspondencia',
    resumen: 'Seguimiento de docs',
    descripcion: 'Seguimiento de documentos por código de registro.',
    icono: Icons.mark_email_read_outlined,
    pantalla: _correspondencia,
  ),
];
