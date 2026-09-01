import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:consultas_y_contrataciones/Core/Theme/theme_controller.dart';
import 'package:consultas_y_contrataciones/main.dart';

void main() {
  testWidgets('arranca en el splash y pasa al menú de servicios', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final tema = await ThemeController.cargar();

    await tester.pumpWidget(MiAppContraloria(tema: tema));
    await tester.pump();

    // Splash primero.
    expect(find.text('SERVICIOS EN LÍNEA'), findsOneWidget);

    // Toca para saltar el splash.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // Ya en el menú principal.
    expect(find.text('Accesos principales'), findsOneWidget);
    expect(find.text('VerificaCGR'), findsOneWidget);
  });
}
