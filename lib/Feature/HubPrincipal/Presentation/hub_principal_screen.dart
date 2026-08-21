import 'package:consultas_y_contrataciones/Core/Presentation/footer_institucional.dart';
import 'package:consultas_y_contrataciones/Core/Presentation/header_institucional.dart';
import 'package:flutter/material.dart';

class HubPrincipalScreen extends StatelessWidget {
  const HubPrincipalScreen({super.key});

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color rojoCaribe = Color(0xFFEF3340);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: azulMedianoche,
        elevation: 2,
        toolbarHeight: 60,
        // Solo el título en la barra azul
        title: const Text(
          "Portal de Consultas CGR",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Franja Institucional Superior
            const HeaderInstitucional(
              tituloPantalla: 'Portal de Consultas CGR',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

            // Contenido Principal Scrollable
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Servicios de Consulta en Línea",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: azulMedianoche,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Seleccione el trámite o certificación que desea consultar:",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(height: 28),

                        // Grid de Vistas
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            if (constraints.maxWidth > 900) {
                              crossAxisCount = 3;
                            } else if (constraints.maxWidth > 600) {
                              crossAxisCount = 2;
                            }

                            return GridView.count(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.3,
                              children: [
                                _buildOpcionCard(
                                  context: context,
                                  titulo: "Solicitud de Certificación de Cargos",
                                  descripcion:
                                      "Consulte el estatus de su solicitud de certificación de cargos.",
                                  icono: Icons.assignment_ind_outlined,
                                  ruta: '/certificacion-cargos',
                                ),
                                _buildOpcionCard(
                                  context: context,
                                  titulo: "Verificar CGR (Contratos y Pagos)",
                                  descripcion:
                                      "Consulta de contratos, libramientos y pagos directos.",
                                  icono: Icons.verified_outlined,
                                  ruta: '/verifica-cgr',
                                ),
                                _buildOpcionCard(
                                  context: context,
                                  titulo: "Consultar correspondencia",
                                  descripcion: "Consulta de correspondencia.",
                                  icono: Icons.find_in_page_outlined,
                                  ruta: '/consulta-correspondencia',
                                ),
                                _buildOpcionCard(
                                  context: context,
                                  titulo: "Consultar empleados del Estado",
                                  descripcion: "Consulta de empleados activos del Estado.",
                                  icono: Icons.find_in_page_outlined,
                                  ruta: '/consulta-empleados',
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer Completo Unificado
            const FooterInstitucional(),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionCard({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required String? ruta,
  }) {
    bool isDisponible = ruta != null;

    return Card(
      elevation: isDisponible ? 2 : 0,
      color: isDisponible ? Colors.white : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDisponible
              ? azulMedianoche.withValues(alpha: 0.15)
              : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: isDisponible
            ? () => Navigator.pushNamed(context, ruta)
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: isDisponible
                        ? const Color(0xFFEBF3FA)
                        : Colors.grey.shade200,
                    child: Icon(
                      icono,
                      color: isDisponible ? azulMedianoche : Colors.grey,
                    ),
                  ),
                  if (!isDisponible)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Próximamente",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDisponible ? azulMedianoche : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDisponible ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    isDisponible ? "Ingresar" : "No disponible",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDisponible ? rojoCaribe : Colors.grey,
                    ),
                  ),
                  if (isDisponible)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: rojoCaribe,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
