import 'package:flutter/material.dart';

import 'package:consultas_y_contrataciones/Feature/ConsultaDeContratosLibramientosYPagosDirectosVerificaCGR/Presentation/paginaverificacgr.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Presentation/paginaconsultaempleados.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaDeCertificaciónDeCargos/Presentation/paginaconsultacontraloria.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaCorrespondencia/Presentation/paginaconsultacorrespondencia.dart';

/// Servicios de la app. Es la única fuente de verdad: el menú principal (Inicio)
/// lee de aquí para pintar las tarjetas y para el buscador.
///
/// Al alcance actual (4 consultas reales) se sumaron, por pedido de dirección,
/// "Consulta Empleados · Descentralizados" y "Solicitud de Certificación de
/// Cargos". Mientras no tengan pantalla propia, reutilizan la del servicio
/// hermano.
enum ServicioId {
  empleadosCentral,
  empleadosDescentralizados,
  verificaCgr,
  correspondencia,
  consultaCertificacion,
  solicitudCertificacion,
}

class ServicioApp {
  const ServicioApp({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
    required this.icono,
    required this.pantalla,
  });

  final ServicioId id;
  final String titulo;

  /// Línea corta bajo el título en la tarjeta del menú.
  final String subtitulo;

  /// Texto largo para la ficha del formulario y para el buscador.
  final String descripcion;

  final IconData icono;

  /// Constructora de la pantalla del servicio.
  final Widget Function() pantalla;
}

Widget _empleados() => const PaginaConsultaEmpleados();
Widget _verificaCgr() => const PaginaVerificaCgr();
Widget _correspondencia() => const PaginaConsultaCorrespondencia();
Widget _certificacion() => const PaginaConsultaContraloria();

const List<ServicioApp> serviciosApp = <ServicioApp>[
  ServicioApp(
    id: ServicioId.empleadosCentral,
    titulo: 'Consulta Empleados',
    subtitulo: 'Gobierno Central',
    descripcion:
        'Nómina pública del Gobierno Central, cargos y salarios por cédula.',
    icono: Icons.groups_outlined,
    pantalla: _empleados,
  ),
  ServicioApp(
    id: ServicioId.empleadosDescentralizados,
    titulo: 'Consulta Empleados',
    subtitulo: 'Descentralizados',
    descripcion:
        'Nómina de las instituciones descentralizadas y autónomas por cédula.',
    icono: Icons.diversity_3_outlined,
    pantalla: _empleados,
  ),
  ServicioApp(
    id: ServicioId.verificaCgr,
    titulo: 'VerificaCGR',
    subtitulo: 'Contratos, pagos directos y libramientos',
    descripcion: 'Contratos, libramientos y pagos directos de proveedores.',
    icono: Icons.verified_outlined,
    pantalla: _verificaCgr,
  ),
  ServicioApp(
    id: ServicioId.correspondencia,
    titulo: 'Consulta Correspondencia',
    subtitulo: 'Seguimiento de documentos por código de registro',
    descripcion: 'Seguimiento de documentos por código de registro.',
    icono: Icons.mark_email_read_outlined,
    pantalla: _correspondencia,
  ),
  ServicioApp(
    id: ServicioId.consultaCertificacion,
    titulo: 'Consulta Certificación de Cargos',
    subtitulo: 'Estatus de una certificación ya solicitada',
    descripcion: 'Estatus de tu solicitud de certificación de cargos.',
    icono: Icons.assignment_ind_outlined,
    pantalla: _certificacion,
  ),
  ServicioApp(
    id: ServicioId.solicitudCertificacion,
    titulo: 'Solicitud de Certificación de Cargos',
    subtitulo: 'Registra una nueva solicitud',
    descripcion: 'Registra una nueva solicitud de certificación de cargos.',
    icono: Icons.workspace_premium_outlined,
    pantalla: _certificacion,
  ),
];
