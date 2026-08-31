import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:consultas_y_contrataciones/Core/Theme/theme_controller.dart';
import 'package:consultas_y_contrataciones/main.dart';

void main() {
  testWidgets('la app arranca en el Inicio', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final tema = await ThemeController.cargar();

    await tester.pumpWidget(MiAppContraloria(tema: tema));
    await tester.pump();

    expect(find.text('¡Hola!'), findsOneWidget);
    expect(find.text('Accesos rápidos'), findsOneWidget);
  });
}
