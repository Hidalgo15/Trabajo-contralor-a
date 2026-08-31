import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda y expone la preferencia de tema del usuario (auto / claro / oscuro),
/// persistida con [SharedPreferences].
class ThemeController extends ChangeNotifier {
  ThemeController._(this._mode);

  static const _clave = 'theme_mode';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  /// Crea el controlador leyendo la preferencia guardada.
  static Future<ThemeController> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeController._(_desdeString(prefs.getString(_clave)));
  }

  Future<void> establecer(ThemeMode nuevo) async {
    if (nuevo == _mode) return;
    _mode = nuevo;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, _aString(nuevo));
  }

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
