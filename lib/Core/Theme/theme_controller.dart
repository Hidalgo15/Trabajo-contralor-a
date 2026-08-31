import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tamaños de texto ofrecidos en Ajustes.
enum TamanoTexto { estandar, grande, maximo }

extension TamanoTextoX on TamanoTexto {
  double get escala => switch (this) {
        TamanoTexto.estandar => 1.0,
        TamanoTexto.grande => 1.15,
        TamanoTexto.maximo => 1.3,
      };

  String get label => switch (this) {
        TamanoTexto.estandar => 'Estándar',
        TamanoTexto.grande => 'Grande',
        TamanoTexto.maximo => 'Máximo',
      };
}

/// Guarda y expone las preferencias de apariencia del usuario (tema y tamaño de
/// texto), persistidas con [SharedPreferences].
class ThemeController extends ChangeNotifier {
  ThemeController._(this._mode, this._texto);

  static const _claveModo = 'theme_mode';
  static const _claveTexto = 'text_size';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  TamanoTexto _texto;
  TamanoTexto get tamanoTexto => _texto;

  /// Crea el controlador leyendo las preferencias guardadas.
  static Future<ThemeController> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeController._(
      _desdeString(prefs.getString(_claveModo)),
      _textoDesdeString(prefs.getString(_claveTexto)),
    );
  }

  Future<void> establecer(ThemeMode nuevo) async {
    if (nuevo == _mode) return;
    _mode = nuevo;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveModo, _aString(nuevo));
  }

  Future<void> establecerTexto(TamanoTexto nuevo) async {
    if (nuevo == _texto) return;
    _texto = nuevo;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveTexto, nuevo.name);
  }

  static TamanoTexto _textoDesdeString(String? v) => TamanoTexto.values
      .firstWhere((t) => t.name == v, orElse: () => TamanoTexto.estandar);

  static ThemeMode _desdeString(String? v) => switch (v) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String _aString(ThemeMode m) => switch (m) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}

/// Acceso al [ThemeController] desde cualquier pantalla.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope no encontrado en el árbol.');
    return scope!.notifier!;
  }
}
