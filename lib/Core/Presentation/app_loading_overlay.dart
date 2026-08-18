import 'package:flutter/material.dart';

/// Overlay reutilizable para bloquear la pantalla durante una operación.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xE6003870),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logos/logo_contraloria_blanco.png',
                height: 100,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 22),
              const SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
