import 'package:consultas_y_contrataciones/Core/Presentation/footer_institucional.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/header_institucional.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/consulta_empleado_response_model.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/empleadoentity.dart';
import 'package:flutter/material.dart';


/*

class PaginaDetallesEmpleado extends StatelessWidget {
  const PaginaDetallesEmpleado({
    super.key,
    required this.empleadoData,
  });

  final ConsultaEmpleadoResponseModel empleadoData;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF3182CE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: azulMedianoche,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          "Consulta Empleados del Estado",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderInstitucional(
              tituloPantalla: 'Consulta Empleados del Estado',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Cabecera de la Tarjeta
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: const Text(
                              "Detalles del Empleado",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),

                          // Datos Generales
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _lineaInfo("Cédula:", empleadoData.cedula ?? "N/A"),
                                const SizedBox(height: 4),
                                _lineaInfo("Nombre:", empleadoData.nombre ?? "N/A"),
                                const SizedBox(height: 4),
                                _lineaInfo("Empleado:", "Gobierno Central"),
                                const SizedBox(height: 20),

                                // Tabla de Puestos / Sueldos / Cuentas
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2.5),
                                    1: FlexColumnWidth(1.5),
                                    2: FlexColumnWidth(1.2),
                                  },
                                  children: [
                                    const TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text("Institución",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text("Sueldo",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text("Cuenta",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...empleadoData.detalles.map(
                                      (d) => TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Text(
                                              d.institucion ?? "-",
                                              style: const TextStyle(
                                                  fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Text(
                                              d.salario != null
                                                  ? "RD\$ ${d.salario!.toStringAsFixed(2)}"
                                                  : "-",
                                              style: const TextStyle(
                                                  fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Text(
                                              d.cuenta ?? "-",
                                              style: const TextStyle(
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),

                                // Botón Volver
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(Icons.arrow_back,
                                        size: 16, color: Colors.white),
                                    label: const Text(
                                      "Volver a Consultar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: azulBoton,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Banner Informativo Inferior
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: Color(0xFF1976D2)),
                                SizedBox(width: 8),
                                Text(
                                  "Datos actualizados Julio 2026",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const FooterInstitucional(),
          ],
        ),
      ),
    );
  }

  Widget _lineaInfo(String etiqueta, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            etiqueta,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }
}
*/


import 'package:flutter/material.dart';

class PaginaDetallesEmpleado extends StatelessWidget {
  const PaginaDetallesEmpleado({
    super.key,
    required this.empleadoData,
  });

  final ConsultaEmpleadoResponseModel empleadoData;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF3182CE);

  @override
  Widget build(BuildContext context) {
    // Si no hay detalles, se toma un objeto vacío por defecto
    final detalle = empleadoData.detalles.isNotEmpty
        ? empleadoData.detalles.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: azulMedianoche,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          "Consulta Empleados del Estado",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderInstitucional(
              tituloPantalla: 'Consulta Empleados del Estado',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Cabecera
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: const Text(
                              "Detalles del Empleado",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),

                          // Datos completos extraídos de EmpleadoEntity
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _lineaInfo("Cédula:", empleadoData.cedula ?? "N/A"),
                                const SizedBox(height: 8),
                                _lineaInfo("Nombre:", empleadoData.nombre ?? "N/A"),
                                //const SizedBox(height: 8),
                                //_lineaInfo("Empleado:", "Gobierno Central"),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Divider(color: Color(0xFFE2E8F0)),
                                ),

                                _lineaInfo("Institución:", detalle?.institucion ?? "N/A"),
                                const SizedBox(height: 8),
                                _lineaInfo("Función/Cargo:", detalle?.funcion ?? "N/A"),
                                const SizedBox(height: 8),
                                _lineaInfo(
                                  "Salario:",
                                  detalle?.salario != null
                                      ? "RD\$ ${detalle!.salario!.toStringAsFixed(2)}"
                                      : "N/A",
                                ),
                                const SizedBox(height: 8),
                                _lineaInfo("Fecha/Período:", detalle?.fechaPeriodo != null ? detalle!.fechaPeriodo!.toString().split(' ')[0] : "N/A"),
                                const SizedBox(height: 8),
                                _lineaInfo("Cuenta:", detalle?.cuenta ?? "N/A"),
                                const SizedBox(height: 8),
                                _lineaInfo("Descripción Cuenta:", detalle?.descripcionCuenta ?? "N/A"),

                                const SizedBox(height: 28),

                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Volver a Consultar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: azulBoton,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Pie de Tarjeta
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF1976D2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Datos actualizados ${detalle?.fechaPeriodo ?? 'Julio 2026'}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const FooterInstitucional(),
          ],
        ),
      ),
    );
  }

  Widget _lineaInfo(String etiqueta, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            etiqueta,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4A5568),
            ),
          ),
        ),
      ],
    );
  }
}