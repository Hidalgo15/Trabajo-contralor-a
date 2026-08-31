import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

/// Ensambla el [ThemeData] claro y oscuro del rediseño a partir de los tokens
/// ([AppColors], [AppDimens], [AppTypography]).
///
/// Los widgets migrados leen de aquí (colorScheme, textTheme y los *Theme de
/// cada componente). Ningún color literal debería quedar en las pantallas.
class AppTheme {
  const AppTheme._();

  static ThemeData get claro => _construir(AppColors.light, Brightness.light);
  static ThemeData get oscuro => _construir(AppColors.dark, Brightness.dark);

  static ThemeData _construir(AppColors c, Brightness brillo) {
    final esClaro = brillo == Brightness.light;
    final textTheme = AppTypography.textTheme(c);

    final colorScheme = ColorScheme(
      brightness: brillo,
      primary: c.azul,
      onPrimary: Colors.white,
      primaryContainer: esClaro ? const Color(0xFFD6E4F5) : c.azulProfundo,
      onPrimaryContainer: esClaro ? c.azulProfundo : Colors.white,
      secondary: c.azulEnlace,
      onSecondary: Colors.white,
      // El rojo institucional también hace de color de error: misma familia,
      // semántica compatible (rechazo / error).
      error: c.rechazo,
      onError: Colors.white,
      errorContainer: c.rechazoFondo,
      onErrorContainer: c.rechazo,
      surface: c.superficie,
      onSurface: c.tinta,
      surfaceContainerLowest: esClaro ? Colors.white : const Color(0xFF0C1A2E),
      surfaceContainerLow: c.fondo,
      surfaceContainer: c.superficieAlt,
      surfaceContainerHigh: c.superficieAlt,
      surfaceContainerHighest: c.superficieAlt,
      onSurfaceVariant: c.tenue,
      outline: c.borde,
      outlineVariant: esClaro ? const Color(0xFFE3E9F1) : const Color(0xFF1F3252),
      shadow: Colors.black,
      inverseSurface: c.tinta,
      onInverseSurface: c.superficie,
      inversePrimary: c.azulEnlace,
    );

    final formaControl = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radioMd),
    );

    OutlineInputBorder borde(Color color, double ancho) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radioMd),
          borderSide: BorderSide(color: color, width: ancho),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brillo,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.fondo,
      canvasColor: c.fondo,
      textTheme: textTheme,
      fontFamily: AppTypography.cuerpo,
      extensions: <ThemeExtension<dynamic>>[c],

      appBarTheme: AppBarTheme(
        backgroundColor: c.azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.display,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      dividerTheme: DividerThemeData(
        color: c.borde,
        thickness: 1,
        space: 1,
      ),

      cardTheme: CardThemeData(
        color: c.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radioLg),
          side: BorderSide(color: c.borde),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.superficieAlt,
        hintStyle: textTheme.bodyMedium?.copyWith(color: c.tenue),
        labelStyle: textTheme.titleSmall,
        floatingLabelStyle: textTheme.titleSmall?.copyWith(color: c.azul),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md + 1,
          vertical: AppDimens.md + 2,
        ),
        enabledBorder: borde(c.borde, 1.5),
        border: borde(c.borde, 1.5),
        focusedBorder: borde(c.azul, 1.8),
        errorBorder: borde(c.rechazo, 1.5),
        focusedErrorBorder: borde(c.rechazo, 1.8),
        errorStyle: textTheme.bodySmall?.copyWith(color: c.rechazo),
        prefixIconColor: c.tenue,
        suffixIconColor: c.tenue,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Acción principal = rojo institucional.
          backgroundColor: c.rojo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.borde,
          disabledForegroundColor: c.tenue,
          minimumSize: const Size.fromHeight(AppDimens.alturaControl),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
          shape: formaControl,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.azul,
          side: BorderSide(color: c.azul, width: 1.4),
          minimumSize: const Size.fromHeight(AppDimens.alturaControl),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
          textStyle: textTheme.labelLarge?.copyWith(color: c.azul),
          shape: formaControl,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.azulEnlace,
          textStyle: textTheme.labelLarge?.copyWith(color: c.azulEnlace),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.azulProfundo,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radioSm),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.superficie,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radioLg),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.azul : null,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.azul,
        linearTrackColor: c.superficieAlt,
      ),

      iconTheme: IconThemeData(color: c.tintaSuave),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
