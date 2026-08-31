import 'package:intl/intl.dart';

/// Formateo de montos, fechas y textos.
///
/// Nota sobre `intl`: `NumberFormat` funciona sin inicializar datos de locale,
/// pero `DateFormat` con nombres de mes si requiere `initializeDateFormatting`.
/// Como aqui solo se necesita dd/MM/yyyy, las fechas se arman a mano y asi el
/// `main()` de la app no tiene que inicializar nada.
class Formatos {
  const Formatos._();

  /// Placeholder institucional para campos vacios (guion largo, no guion medio).
  static const String vacio = '—';

  /// El backend guarda la moneda como simbolo, no como codigo ISO. Ademas la
  /// columna viene con relleno de espacios (`'RD$       '`), por eso todo pasa
  /// por `trim()` antes de buscar en el mapa.
  static const Map<String, String> _codigosMoneda = {
    r'RD$': 'DOP',
    r'US$': 'USD',
    r'$': 'USD',
    '€': 'EUR',
    '₡': 'CRC',
    '¥': 'JPY',
    '£': 'GBP',
    // Por si alguna fila ya viene normalizada.
    'DOP': 'DOP',
    'USD': 'USD',
    'EUR': 'EUR',
  };

  static const Map<String, String> _simbolos = {
    'DOP': r'RD$',
    'USD': r'US$',
    'EUR': '€',
    'CRC': '₡',
    'JPY': '¥',
    'GBP': '£',
  };

  /// Monto con su simbolo. Sin moneda reconocida cae a DOP, que es el mismo
  /// comportamiento del portal web. Si no hay monto devuelve el guion largo,
  /// para no mostrar un "RD$ 0.00" que pueda parecer un monto real.
  static String moneda(num? valor, String? moneda) {
    if (valor == null) return vacio;
    final codigo = _codigosMoneda[(moneda ?? '').trim()] ?? 'DOP';
    final formato = NumberFormat.currency(
      locale: 'es_DO',
      symbol: '${_simbolos[codigo] ?? codigo} ',
      decimalDigits: 2,
    );
    return formato.format(valor);
  }

  static String fecha(DateTime? valor) {
    if (valor == null) return vacio;
    final dia = valor.day.toString().padLeft(2, '0');
    final mes = valor.month.toString().padLeft(2, '0');
    return '$dia/$mes/${valor.year}';
  }

  static String rango(DateTime? desde, DateTime? hasta) =>
      '${fecha(desde)} – ${fecha(hasta)}';

  /// Fecha larga con hora para el pie de los PDF y de la pantalla de
  /// resultados.
  static String selloDeTiempo(DateTime valor) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final hora = valor.hour.toString().padLeft(2, '0');
    final minuto = valor.minute.toString().padLeft(2, '0');
    final segundo = valor.second.toString().padLeft(2, '0');
    return '${valor.day} de ${meses[valor.month - 1]} de ${valor.year}, '
        '$hora:$minuto:$segundo';
  }

  /// Primera letra en mayuscula y el resto en minuscula. Los conceptos vienen
  /// TODOS EN MAYUSCULA desde SIGOB y se ven agresivos sin esto.
  static String capitalizar(String? texto) {
    final limpio = texto?.trim() ?? '';
    if (limpio.isEmpty) return vacio;
    return limpio[0].toUpperCase() + limpio.substring(1).toLowerCase();
  }

  static String oVacio(Object? texto) {
    final limpio = texto?.toString().trim() ?? '';
    return limpio.isEmpty ? vacio : limpio;
  }
}
