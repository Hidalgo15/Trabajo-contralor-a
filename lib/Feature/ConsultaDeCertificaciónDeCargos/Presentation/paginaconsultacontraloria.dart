import 'package:consultas_y_contrataciones/GeneralFeatures/FooterInstitucional.dart';
import 'package:consultas_y_contrataciones/GeneralFeatures/HeaderInstitucional.dart';
import 'package:flutter/material.dart';
// import 'widgets/footer_institucional.dart';

class PaginaConsultaContraloria extends StatefulWidget {
  const PaginaConsultaContraloria({super.key});

  @override
  State<PaginaConsultaContraloria> createState() =>
      _PaginaConsultaContraloriaState();
}

class _PaginaConsultaContraloriaState
    extends State<PaginaConsultaContraloria> {
  final TextEditingController _cedulaController = TextEditingController();
  bool _isNotRobot = false;
  bool _isLoading = false;

  static const Color azulMedianoche = Color(0xFF003870);
  static const Color rojoCaribe = Color(0xFFEF3340);

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  Future<void> _consultarSolicitud() async {
    if (_cedulaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingrese un número de documento"),
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
          content: Text("Consulta enviada para la cédula: ${_cedulaController.text}"),
          backgroundColor: azulMedianoche,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: const Color(0xFFF4F6F8),
    // 1. AppBar limpio (Solo título en texto)
    appBar: AppBar(
      backgroundColor: const Color(0xFF003870),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      title: const Text(
        "Certificación de Cargos",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          // 2. Insertamos el Header reutilizable
          const HeaderInstitucional(
            tituloPantalla: "Consulta Solicitudes Certificación de Cargos",
          ),
            // CONTENIDO SCROLLABLE
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ENCABEZADO CON LOGO DE ASSETS
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            /*Image.asset(
                              'assets/logos/logocontraloriageneralrepdom.png',
                              height: 55,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.account_balance, size: 42, color: azulMedianoche),
                            ),*/
                            const Text(
                              "Consulta Solicitudes Certificación de Cargos",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: azulMedianoche,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // TARJETA DEL FORMULARIO
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF3FA),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: azulMedianoche.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.info, color: azulMedianoche, size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Puede consultar el estatus de su solicitud de certificación de cargos a través de este portal.",
                                        style: TextStyle(fontSize: 13, color: azulMedianoche),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 25),

                              RichText(
                                text: const TextSpan(
                                  text: "No. Documento Identidad: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(text: " *", style: TextStyle(color: rojoCaribe)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _cedulaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Digite el no. de documento sin guiones",
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(color: azulMedianoche, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              RichText(
                                text: const TextSpan(
                                  text: "Confirme que no es un robot: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(text: " *", style: TextStyle(color: rojoCaribe)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 280,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: azulMedianoche,
                                      value: _isNotRobot,
                                      onChanged: (val) {
                                        setState(() => _isNotRobot = val ?? false);
                                      },
                                    ),
                                    const Text("No soy un robot", style: TextStyle(fontSize: 13)),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.refresh, color: azulMedianoche, size: 24),
                                      onPressed: () {
                                        setState(() => _isNotRobot = false);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              Center(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _consultarSolicitud,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: azulMedianoche,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text("Enviar", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

            // FOOTER GENERAL UNIFICADO
            const FooterInstitucional(),
          ],
        ),
      ),
    );
  }
}