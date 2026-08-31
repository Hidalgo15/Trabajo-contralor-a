import 'package:flutter/material.dart';

/// Paleta institucional de la Contraloría General de la República.
///
/// Azul y rojo son los del logo oficial. El azul manda en estructura y
/// encabezados; el rojo es el acento único, reservado para la acción principal
/// y los estados activos. Se expone como [ThemeExtension] para leerla con
/// `Theme.of(context).extension<AppColors>()!` desde cualquier widget y que
/// cambie sola entre tema claro y oscuro.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.azul,
    required this.azulProfundo,
    required this.azulEnlace,
    required this.rojo,
    required this.rojoProfundo,
    required this.rojoVivo,
    required this.fondo,
    required this.superficie,
    required this.superficieAlt,
    required this.borde,
    required this.tinta,
    required this.tintaSuave,
    required this.tenue,
    required this.exito,
    required this.exitoFondo,
    required this.aviso,
    required this.avisoFondo,
    required this.rechazo,
    required this.rechazoFondo,
  });

  /// Azul institucional. Encabezados, barras, íconos primarios.
  final Color azul;

  /// Variante honda del azul, para degradados y superficies oscuras.
  final Color azulProfundo;

  /// Azul más claro y saturado para enlaces y acentos secundarios sobre blanco.
  final Color azulEnlace;

  /// Rojo institucional. **Acento único**: botón de acción, elemento activo.
  final Color rojo;

  /// Rojo para texto/hover sobre blanco (contraste AA).
  final Color rojoProfundo;

  /// Rojo vivo del logo, solo para franjas finas y detalles, nunca texto.
  final Color rojoVivo;

  final Color fondo;
  final Color superficie;
  final Color superficieAlt;
  final Color borde;

  /// Texto principal.
  final Color tinta;

  /// Texto secundario con algo más de peso que [tenue].
  final Color tintaSuave;

  /// Texto terciario, ayudas, marcas de agua.
  final Color tenue;

  final Color exito;
  final Color exitoFondo;
  final Color aviso;
  final Color avisoFondo;
  final Color rechazo;
  final Color rechazoFondo;

  static const AppColors light = AppColors(
    azul: Color(0xFF003876),
    azulProfundo: Color(0xFF002B5B),
    azulEnlace: Color(0xFF1160B4),
    rojo: Color(0xFFCE0E2D),
    rojoProfundo: Color(0xFFB00C27),
    rojoVivo: Color(0xFFED1C24),
    fondo: Color(0xFFEEF2F8),
    superficie: Color(0xFFFFFFFF),
    superficieAlt: Color(0xFFE9EFF7),
    borde: Color(0xFFD4DDEA),
    tinta: Color(0xFF10233B),
    tintaSuave: Color(0xFF33455F),
    tenue: Color(0xFF5C6E88),
    exito: Color(0xFF1B6E44),
    exitoFondo: Color(0xFFE2F0E7),
    aviso: Color(0xFF895A12),
    avisoFondo: Color(0xFFFBEED6),
    rechazo: Color(0xFFA81B2B),
    rechazoFondo: Color(0xFFFBE4E6),
  );

  static const AppColors dark = AppColors(
    azul: Color(0xFF4F91DD),
    azulProfundo: Color(0xFF2C63A6),
    azulEnlace: Color(0xFF86B6E8),
    rojo: Color(0xFFFF4D5E),
    rojoProfundo: Color(0xFFFF6B7A),
    rojoVivo: Color(0xFFFF5A63),
    fondo: Color(0xFF0A1626),
    superficie: Color(0xFF10203A),
    superficieAlt: Color(0xFF172B49),
    borde: Color(0xFF263B5A),
    tinta: Color(0xFFE5EDF8),
    tintaSuave: Color(0xFFC2D0E4),
    tenue: Color(0xFF9DB0CC),
    exito: Color(0xFF56C08A),
    exitoFondo: Color(0xFF14301F),
    aviso: Color(0xFFE0B265),
    avisoFondo: Color(0xFF33260C),
    rechazo: Color(0xFFFF7A88),
    rechazoFondo: Color(0xFF3A1A1F),
  );

  @override
  AppColors copyWith({
    Color? azul,
    Color? azulProfundo,
    Color? azulEnlace,
    Color? rojo,
    Color? rojoProfundo,
    Color? rojoVivo,
    Color? fondo,
    Color? superficie,
    Color? superficieAlt,
    Color? borde,
    Color? tinta,
    Color? tintaSuave,
    Color? tenue,
    Color? exito,
    Color? exitoFondo,
    Color? aviso,
    Color? avisoFondo,
    Color? rechazo,
    Color? rechazoFondo,
  }) {
    return AppColors(
      azul: azul ?? this.azul,
      azulProfundo: azulProfundo ?? this.azulProfundo,
      azulEnlace: azulEnlace ?? this.azulEnlace,
      rojo: rojo ?? this.rojo,
      rojoProfundo: rojoProfundo ?? this.rojoProfundo,
      rojoVivo: rojoVivo ?? this.rojoVivo,
      fondo: fondo ?? this.fondo,
      superficie: superficie ?? this.superficie,
      superficieAlt: superficieAlt ?? this.superficieAlt,
      borde: borde ?? this.borde,
      tinta: tinta ?? this.tinta,
      tintaSuave: tintaSuave ?? this.tintaSuave,
      tenue: tenue ?? this.tenue,
      exito: exito ?? this.exito,
      exitoFondo: exitoFondo ?? this.exitoFondo,
      aviso: aviso ?? this.aviso,
      avisoFondo: avisoFondo ?? this.avisoFondo,
      rechazo: rechazo ?? this.rechazo,
      rechazoFondo: rechazoFondo ?? this.rechazoFondo,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      azul: Color.lerp(azul, other.azul, t)!,
      azulProfundo: Color.lerp(azulProfundo, other.azulProfundo, t)!,
      azulEnlace: Color.lerp(azulEnlace, other.azulEnlace, t)!,
      rojo: Color.lerp(rojo, other.rojo, t)!,
      rojoProfundo: Color.lerp(rojoProfundo, other.rojoProfundo, t)!,
      rojoVivo: Color.lerp(rojoVivo, other.rojoVivo, t)!,
      fondo: Color.lerp(fondo, other.fondo, t)!,
      superficie: Color.lerp(superficie, other.superficie, t)!,
      superficieAlt: Color.lerp(superficieAlt, other.superficieAlt, t)!,
      borde: Color.lerp(borde, other.borde, t)!,
      tinta: Color.lerp(tinta, other.tinta, t)!,
      tintaSuave: Color.lerp(tintaSuave, other.tintaSuave, t)!,
      tenue: Color.lerp(tenue, other.tenue, t)!,
      exito: Color.lerp(exito, other.exito, t)!,
      exitoFondo: Color.lerp(exitoFondo, other.exitoFondo, t)!,
      aviso: Color.lerp(aviso, other.aviso, t)!,
      avisoFondo: Color.lerp(avisoFondo, other.avisoFondo, t)!,
      rechazo: Color.lerp(rechazo, other.rechazo, t)!,
      rechazoFondo: Color.lerp(rechazoFondo, other.rechazoFondo, t)!,
    );
  }
}

/// Azúcar sintáctico: `context.colores.rojo` en vez de
/// `Theme.of(context).extension<AppColors>()!.rojo`.
extension AppColorsX on BuildContext {
  AppColors get colores => Theme.of(this).extension<AppColors>()!;
}
