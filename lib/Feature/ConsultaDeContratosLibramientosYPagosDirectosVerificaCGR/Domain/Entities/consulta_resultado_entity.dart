import 'package:consultas_y_contrataciones/Core/Json/json_row.dart';

import 'contrato_entity.dart';
import 'proveedor_entity.dart';
import 'tramite_entity.dart';

/// Respuesta completa de `GET /api/Consulta/GetTramitesProveedor`.
///
/// Estructura real verificada contra el servicio:
///
/// ```jsonc
/// {
///   "proveedor":    { "documento": "...", "rpe": "...", "nombre": "...", ... },
///   "libramientos": [ /* filas crudas: libramientos Y pagos directos */ ],
///   "contratos":    [ /* filas crudas */ ]
/// }
/// ```
///
/// Ojo: NO existe una llave `pagosDirectos`. El backend devuelve los dos tipos
/// mezclados en `libramientos` y la separacion se hace aqui por la columna
/// `sistema`, igual que en el portal web.
class ConsultaResultadoEntity {
  const ConsultaResultadoEntity({
    required this.proveedor,
    required this.libramientos,
    required this.pagosDirectos,
    required this.contratos,
    required this.sistemasDesconocidos,
  });

  final ProveedorEntity proveedor;
  final List<TramiteEntity> libramientos;
  final List<TramiteEntity> pagosDirectos;
  final List<ContratoEntity> contratos;

  /// Valores de la columna `sistema` que no encajaron en ninguna categoria.
  /// El portal web los descarta en silencio; aqui se acumulan para poder
  /// detectar que el stored procedure agrego un tipo nuevo.
  final List<String> sistemasDesconocidos;

  factory ConsultaResultadoEntity.fromJson(Map<String, dynamic> json) {
    final row = JsonRow(json);

    final proveedorJson = row.valor(['proveedor']);
    final proveedor = proveedorJson is Map
        ? ProveedorEntity.fromJson(Map<String, dynamic>.from(proveedorJson))
        : const ProveedorEntity();

    final libramientos = <TramiteEntity>[];
    final pagosDirectos = <TramiteEntity>[];
    final desconocidos = <String>[];

    for (final item in _listaDeMapas(row.valor(['libramientos']))) {
      final tramite = TramiteEntity.fromJson(item);
      if (tramite.esLibramiento) {
        libramientos.add(tramite);
      } else if (tramite.esPagoDirecto) {
        pagosDirectos.add(tramite);
      } else {
        desconocidos.add(tramite.sistema ?? '(vacío)');
      }
    }

    final contratos = _listaDeMapas(row.valor(['contratos']))
        .map(ContratoEntity.fromJson)
        .toList();

    return ConsultaResultadoEntity(
      proveedor: proveedor,
      libramientos: libramientos,
      pagosDirectos: pagosDirectos,
      contratos: contratos,
      sistemasDesconocidos: desconocidos,
    );
  }

  static List<Map<String, dynamic>> _listaDeMapas(dynamic valor) {
    if (valor is! List) return const [];
    return valor
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Que no haya tramites NO es un error: significa que el ciudadano no tiene
  /// tramites pendientes, y la UI lo muestra como aviso.
  bool get estaVacio =>
      libramientos.isEmpty && pagosDirectos.isEmpty && contratos.isEmpty;

  int get total => libramientos.length + pagosDirectos.length + contratos.length;

  /// Beneficiario del encabezado: se toma del primer tramite y, si no hay
  /// ninguno, del registro del proveedor.
  String? get beneficiarioGeneral {
    final primero = _primerTramite;
    if (primero?.beneficiario != null) return primero!.beneficiario;
    if (contratos.isNotEmpty && contratos.first.beneficiario != null) {
      return contratos.first.beneficiario;
    }
    return proveedor.nombre;
  }

  String? get documentoGeneral {
    final primero = _primerTramite;
    if (primero?.documento != null) return primero!.documento;
    if (contratos.isNotEmpty && contratos.first.documento != null) {
      return contratos.first.documento;
    }
    return proveedor.documento;
  }

  TramiteEntity? get _primerTramite {
    if (libramientos.isNotEmpty) return libramientos.first;
    if (pagosDirectos.isNotEmpty) return pagosDirectos.first;
    return null;
  }
}
