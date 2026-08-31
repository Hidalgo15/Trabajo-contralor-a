import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Registra la licencia SIL Open Font License de las tipografías empaquetadas
/// para que aparezcan en el diálogo "Licencias" de la app (`showLicensePage`).
///
/// Llamar una vez desde `main()`, después de `WidgetsFlutterBinding
/// .ensureInitialized()`.
void registrarLicenciasDeFuentes() {
  LicenseRegistry.addLicense(() async* {
    final ibmPlex = await rootBundle.loadString('assets/fonts/OFL-IBMPlex.txt');
    yield LicenseEntryWithLineBreaks(
      const ['IBM Plex Sans', 'IBM Plex Mono'],
      ibmPlex,
    );

    final bricolage =
        await rootBundle.loadString('assets/fonts/OFL-Bricolage.txt');
    yield LicenseEntryWithLineBreaks(
      const ['Bricolage Grotesque'],
      bricolage,
    );
  });
}
