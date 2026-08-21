/// Lector tolerante al casing de las filas que devuelve la API.
///
/// Los elementos de `libramientos` y `contratos` NO son DTOs: el backend los
/// arma como `dynamic` a partir del `DataReader` de SQL Server, asi que las
/// llaves del JSON son literalmente los nombres de las columnas del stored
/// procedure. Eso significa que:
///
///   * NO pasan por la politica camelCase de ASP.NET (esa solo aplica a
///     objetos tipados, como `proveedor`).
///   * El casing es inconsistente entre columnas. Verificado contra una
///     respuesta real: `Institucion`, `NumeroOrdenPago`, `Periodo` en
///     PascalCase, pero `beneficiario`, `monto`, `moneda`, `sistema` en
///     minuscula y `fecha_registro` en snake_case.
///   * Puede cambiar si alguien edita el stored procedure.
///
/// Por eso nunca se debe leer un campo con `map['fecha_registro']` directo.
/// [JsonRow] normaliza las llaves (minusculas, sin `_` ni espacios) y acepta
/// varios nombres candidatos.
class JsonRow {
  JsonRow(Map<String, dynamic> raw)
      : _raw = raw,
        _index = {
          for (final key in raw.keys) _normalizar(key): key,
        };

  final Map<String, dynamic> _raw;
  final Map<String, String> _index;

  /// El mapa original, por si el procedure agrega columnas no modeladas.
  Map<String, dynamic> get raw => _raw;

  static String _normalizar(String key) =>
      key.toLowerCase().replaceAll('_', '').replaceAll(' ', '');

  /// Primer valor no nulo entre los [nombres] candidatos.
  dynamic valor(List<String> nombres) {
    for (final nombre in nombres) {
      final llaveReal = _index[_normalizar(nombre)];
      if (llaveReal == null) continue;
      final v = _raw[llaveReal];
      if (v != null) return v;
    }
    return null;
  }

  /// Texto ya recortado. Devuelve `null` si el campo viene vacio, para que la
  /// UI pinte el guion largo en un solo lugar.
  String? texto(List<String> nombres) {
    final v = valor(nombres);
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  /// Numero tolerante a que SQL lo mande como texto con separadores de miles.
  num? numero(List<String> nombres) {
    final v = valor(nombres);
    if (v == null) return null;
    if (v is num) return v;
    final limpio = v.toString().replaceAll(',', '').replaceAll(r'$', '').trim();
    return num.tryParse(limpio);
  }

   /// Numero tolerante a que SQL lo mande como texto con separadores de miles.
  double? GetSalarios(List<String> nombres) {
    final v = valor(nombres);
    if (v == null) return null;
    if (v is double) return v;
    final limpio = v.toString().replaceAll(',', '').replaceAll(r'$', '').trim();
    return double.tryParse(limpio);
  }

  /// Fecha ISO-8601 (`2026-08-17T00:00:00`, que es como llega hoy). Si alguna
  /// columna viniera como texto libre devolvemos `null` en vez de reventar.
  DateTime? fecha(List<String> nombres) {
    final v = valor(nombres);
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString().trim());
  }
}
