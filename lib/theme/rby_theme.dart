import 'package:flutter/material.dart';
import 'package:rby/theme/radius_scheme.dart';
import 'package:rby/theme/rby_toolbar_theme.dart';
import 'package:rby/theme/spacing_scheme.dart';

@immutable
class RbyTheme {
  RbyTheme({
    required ColorScheme colorScheme,
    this.spacingScheme = const SpacingScheme.fallback(),
    this.radiusScheme = const RadiusScheme.fallback(),
    RbyToolbarTheme? toolbarTheme,
  }) {
    this.toolbarTheme =
        toolbarTheme ?? RbyToolbarTheme.fallback(colorScheme, spacingScheme);

    data = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    ).copyWith(
      splashFactory: NoSplash.splashFactory,
      dividerTheme: const DividerThemeData(thickness: 1, space: 1),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          vertical: spacingScheme.m,
          horizontal: spacingScheme.l,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
          borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(31)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          visualDensity: VisualDensity.standard,
          padding: EdgeInsets.symmetric(
            vertical: spacingScheme.m,
            horizontal: spacingScheme.l,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          visualDensity: VisualDensity.standard,
          padding: EdgeInsets.symmetric(
            vertical: spacingScheme.m,
            horizontal: spacingScheme.l,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,
          visualDensity: VisualDensity.standard,
          padding: EdgeInsets.symmetric(
            vertical: spacingScheme.m,
            horizontal: spacingScheme.l,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radiusScheme.large),
        ),
      ),
      extensions: [spacingScheme, radiusScheme, this.toolbarTheme],
    );
  }

  final SpacingScheme spacingScheme;
  final RadiusScheme radiusScheme;
  late final RbyToolbarTheme toolbarTheme;

  late final ThemeData data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RbyTheme &&
        other.spacingScheme == spacingScheme &&
        other.radiusScheme == radiusScheme &&
        other.toolbarTheme == toolbarTheme &&
        other.data == data;
  }

  @override
  int get hashCode {
    return spacingScheme.hashCode ^
        radiusScheme.hashCode ^
        toolbarTheme.hashCode ^
        data.hashCode;
  }
}
