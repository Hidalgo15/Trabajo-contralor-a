import 'package:consultas_y_contrataciones/GeneralFeatures/FooterInstitucional.dart';
import 'package:consultas_y_contrataciones/GeneralFeatures/HeaderInstitucional.dart';
import 'package:flutter/material.dart';


class PaginaConsultaCorrespondencia extends StatefulWidget {
  const PaginaConsultaCorrespondencia({super.key});

  @override
  State<PaginaConsultaCorrespondencia> createState() =>
      _PaginaConsultaCorrespondenciaState();
}

class _PaginaConsultaCorrespondenciaState
    extends State<PaginaConsultaCorrespondencia> {
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color azulBoton = Color(0xFF1E6FCE);
  static const Color rojoCaribe = Color(0xFFEF3340);

  @override
  void dispose() {
    _codigoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _consultar() async {
    if (_codigoController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, complete todos los campos"),
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
          content: Text(
            "Consultando correspondencia: ${_codigoController.text}",
          ),
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
          "Consulta de Correspondencia",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Institucional Reutilizable
            const HeaderInstitucional(
              tituloPantalla: 'Consulta de Correspondencia',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

            // Contenido Scrollable
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 550),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 32.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Ingrese el código de registro de la correspondencia y la contraseña otorgada por la Mesa de Entrada",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A5568),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Campo Código
                          const Text(
                            "Código de la correspondencia:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _codigoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    const BorderSide(color: Color(0xFFCBD5E0)),
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
                          const SizedBox(height: 20),

                          // Campo Contraseña + Olvidé la contraseña
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Contraseña:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Acción para recuperar contraseña
                                },
                                child: const Text(
                                  "Olvidé la contraseña",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: azulBoton,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    const BorderSide(color: Color(0xFFCBD5E0)),
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
                          const SizedBox(height: 28),

                          // Botón Consultar
                          ElevatedButton(
                            onPressed: _isLoading ? null : _consultar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulBoton,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Consultar",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
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