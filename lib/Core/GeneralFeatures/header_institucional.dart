import 'package:flutter/material.dart';

class HeaderInstitucional extends StatelessWidget {
  final String tituloPantalla;

  const HeaderInstitucional({
    super.key,
    required this.tituloPantalla,
  });

  static const Color azulMedianoche = Color(0xFF003870);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Logo Oficial de la Contraloría a la IZQUIERDA
          Image.asset(
            'assets/logos/logo_contraloria.png',
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, size: 28, color: azulMedianoche),
          ),

          // 2. Escudo / Bandera Nacional a la DERECHA
          Image.asset(
            'assets/logos/escudobandera.png',
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.flag, color: azulMedianoche, size: 24),
          ),
        ],
      ),
    );
  }
}


/*
class HeaderInstitucional extends StatelessWidget {
  final String tituloPantalla;

  const HeaderInstitucional({
    super.key,
    required this.tituloPantalla,
  });

  static const Color azulMedianoche = Color(0xFF003870);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Franja superior: Escudo + Texto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logos/escudo_bandera.png',
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.flag, color: azulMedianoche, size: 24),
              ),
              const Text(
                "REPÚBLICA DOMINICANA",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: azulMedianoche,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),

          // 2. Logo Oficial de Contraloría + Título Dinámico
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Image.asset(
                'assets/logos/logocontraloriageneralrepdom.png',
                height: 48,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_balance, size: 36, color: azulMedianoche),
              ),
              Text(
                tituloPantalla,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: azulMedianoche,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/