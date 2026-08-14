// lib/Core/Utils/JsonRow.dart
class JsonRow {
  JsonRow(Map<String, dynamic> raw)
      : _raw = raw,
        _index = {
          for (final key in raw.keys) _normalizar(key): key,
        };

  final Map<String, dynamic> _raw;
  final Map<String, String> _index;

  static String _normalizar(String key) =>
      key.toLowerCase().replaceAll('_', '').replaceAll(' ', '');

  dynamic valor(List<String> nombres) {
    for (final nombre in nombres) {
      final llaveReal = _index[_normalizar(nombre)];
      if (llaveReal == null) continue;
      final v = _raw[llaveReal];
      if (v != null) return v;
    }
    return null;
  }

  String texto(List<String> nombres, {String defecto = ''}) {
    final v = valor(nombres);
    if (v == null) return defecto;
    final s = v.toString().trim();
    return s.isEmpty ? defecto : s;
  }

  double monto(List<String> nombres) {
    final v = valor(nombres);
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    final limpio = v.toString().replaceAll(',', '').replaceAll(r'$', '').trim();
    return double.tryParse(limpio) ?? 0.0;
  }
}