import 'package:flutter/material.dart';

class FooterInstitucional extends StatelessWidget {
  const FooterInstitucional({super.key});

  static const Color azulMedianoche = Color(0xFF003870);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Contraloría General de la República Dominicana",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: azulMedianoche,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            "Ave. Pedro A. Lluberes No. 1, esquina Calle Francia, 3er piso, Gascue, Santo Domingo, Distrito Nacional, R.D.",
            style: TextStyle(fontSize: 11, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Bloque de Contactos Directos
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: const [
              Text("Tel: (809) 682-1677", style: TextStyle(fontSize: 11, color: Colors.black)),
              Text("•", style: TextStyle(fontSize: 11, color: Colors.grey)),
             // Text("Exts: 2101 / 2102", style: TextStyle(fontSize: 11, color: Colors.black)),
             // Text("•", style: TextStyle(fontSize: 11, color: Colors.grey)),
              Text("contacto@contraloria.gob.do", style: TextStyle(fontSize: 11, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "© 2025 Todos los derechos reservados — V1.5.4",
            style: TextStyle(fontSize: 10, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}