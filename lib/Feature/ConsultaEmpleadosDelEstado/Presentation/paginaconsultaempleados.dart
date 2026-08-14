import 'package:flutter/material.dart';
import 'package:consultas_y_contrataciones/GeneralFeatures/FooterInstitucional.dart';
import 'package:consultas_y_contrataciones/GeneralFeatures/HeaderInstitucional.dart';
// import 'widgets/header_institucional.dart';
// import 'widgets/footer_institucional.dart';

class PaginaConsultaEmpleados extends StatefulWidget {
  const PaginaConsultaEmpleados({super.key});

  @override
  State<PaginaConsultaEmpleados> createState() =>
      _PaginaConsultaEmpleadosState();
}

class _PaginaConsultaEmpleadosState extends State<PaginaConsultaEmpleados> {
  final TextEditingController _cedulaController = TextEditingController();
  bool _isNotRobot = false;
  bool _isLoading = false;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF3182CE);
  static const Color rojoCaribe = Color(0xFFEF3340);

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  Future<void> _buscarEmpleado() async {
    if (_cedulaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese un número de cédula"),
          backgroundColor: rojoCaribe,
        ),
      );
      return;
    }

    if (!_isNotRobot) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, confirme que no es un robot"),
          backgroundColor: rojoCaribe,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Buscando empleado con cédula: ${_cedulaController.text}"),
          backgroundColor: azulMedianoche,
        ),
      );
    }
  }

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
            // Header Institucional Reutilizable
            const HeaderInstitucional(
              tituloPantalla: 'Consulta Empleados del Estado',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

            // Contenido Scrollable
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
                          // Cabecera Gris del Formulario
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
                              "Consulta Empleados del Estado",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),

                          // Cuerpo del Formulario
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Puede buscar por número de cédula.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                const Text(
                                  "Cédula",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _cedulaController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: azulBoton,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),

                                const Text(
                                  "Confirme que no es un robot:",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Contenedor Captcha Estilo reCAPTCHA
                                Container(
                                  width: 280,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9F9F9),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: azulMedianoche,
                                        value: _isNotRobot,
                                        onChanged: (val) {
                                          setState(
                                            () => _isNotRobot = val ?? false,
                                          );
                                        },
                                      ),
                                      const Text(
                                        "I'm not a robot",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.refresh,
                                            color: azulBoton,
                                            size: 22,
                                          ),
                                          Text(
                                            "reCAPTCHA",
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Botón Buscar
                                SizedBox(
                                  width: 280,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _isLoading ? null : _buscarEmpleado,
                                    icon: _isLoading
                                        ? const SizedBox.shrink()
                                        : const Icon(Icons.search, size: 18),
                                    label: _isLoading
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "Buscar",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: azulBoton,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
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

                          // Banner Informativo Inferior de la Tarjeta
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
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF1976D2),
                                ),
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

            // Footer Institucional Reutilizable
            const FooterInstitucional(),
          ],
        ),
      ),
    );
  }
}