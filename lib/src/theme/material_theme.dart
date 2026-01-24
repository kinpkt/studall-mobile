import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1b1b1b),
      onPrimaryContainer: Color(0xff848484),
      secondary: Color(0xff464647),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5e5e5e),
      onSecondaryContainer: Color(0xffd9d8d7),
      tertiary: Color(0xff5e5e5f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9e9e9e),
      onTertiaryContainer: Color(0xff343636),
      error: Color(0xff930009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffba1a1a),
      onErrorContainer: Color(0xffffcdc7),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffc6c6c6),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1b1b1b),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff474747),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff464747),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1b1b1b),
      onPrimaryContainer: Color(0xffa7a7a7),
      secondary: Color(0xff363636),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5e5e5e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff353636),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6c6d6d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffba1a1a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff333737),
      outline: Color(0xff4f5354),
      outlineVariant: Color(0xff6a6e6e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffc6c6c6),
      primaryFixed: Color(0xff6d6d6d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff555555),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d6d6d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff555555),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6c6d6d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff545555),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c6c6),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffe8e8e8),
      surfaceContainerHigh: Color(0xffdddddd),
      surfaceContainerHighest: Color(0xffd1d1d1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1b1b1b),
      onPrimaryContainer: Color(0xffd0d0d0),
      secondary: Color(0xff2c2c2c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff494949),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2b2c2c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff484949),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292d2d),
      outlineVariant: Color(0xff464a4a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffc6c6c6),
      primaryFixed: Color(0xff494949),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff333333),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff494949),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff323333),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff484949),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff323333),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9b9),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1f1),
      surfaceContainer: Color(0xffe2e2e2),
      surfaceContainerHigh: Color(0xffd4d4d4),
      surfaceContainerHighest: Color(0xffc6c6c6),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc6c6c6),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff303030),
      primaryContainer: Color(0xff000000),
      onPrimaryContainer: Color(0xff757575),
      secondary: Color(0xffc7c6c6),
      onSecondary: Color(0xff303030),
      secondaryContainer: Color(0xff5e5e5e),
      onSecondaryContainer: Color(0xffd9d8d7),
      tertiary: Color(0xffc7c6c6),
      onTertiary: Color(0xff2f3131),
      tertiaryContainer: Color(0xff9e9e9e),
      onTertiaryContainer: Color(0xff343636),
      error: Color(0xffffb4ab),
      onError: Color(0xff690004),
      errorContainer: Color(0xffba1a1a),
      onErrorContainer: Color(0xffffcdc7),
      surface: Color(0xff131313),
      onSurface: Color(0xffe2e2e2),
      onSurfaceVariant: Color(0xffc4c7c7),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff5e5e5e),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1b1b1b),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff474747),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff464747),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdcdcdc),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff262626),
      primaryContainer: Color(0xff919191),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdddcdc),
      onSecondary: Color(0xff252626),
      secondaryContainer: Color(0xff919090),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdddcdc),
      onTertiary: Color(0xff252626),
      tertiaryContainer: Color(0xff9e9e9e),
      onTertiaryContainer: Color(0xff101111),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadddd),
      outline: Color(0xffafb2b3),
      outlineVariant: Color(0xff8e9191),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff484848),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff111111),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff363636),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff101111),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff363636),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff101112),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff353636),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff444444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1d1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff323232),
      surfaceContainerHighest: Color(0xff3e3e3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0f0f0),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc2c2c2),
      onPrimaryContainer: Color(0xff0b0b0b),
      secondary: Color(0xfff1efef),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc3c2c2),
      onSecondaryContainer: Color(0xff0a0b0c),
      tertiary: Color(0xfff1f0ef),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc3c2c2),
      onTertiaryContainer: Color(0xff0a0b0c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef0f1),
      outlineVariant: Color(0xffc0c3c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff484848),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff111111),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff101111),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff101112),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff505050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff303030),
      surfaceContainerHigh: Color(0xff3b3b3b),
      surfaceContainerHighest: Color(0xff474747),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    // ignore: deprecated_member_use
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  /// Sunday
  static const sunday = ExtendedColor(
    seed: Color(0xffef5350),
    value: Color(0xffef5350),
    light: ColorFamily(
      color: Color(0xffb02528),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd23e3e),
      onColorContainer: Color(0xfffffbff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xffb02528),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd23e3e),
      onColorContainer: Color(0xfffffbff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xffb02528),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd23e3e),
      onColorContainer: Color(0xfffffbff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb3ae),
      onColor: Color(0xff68000b),
      colorContainer: Color(0xfff95a56),
      onColorContainer: Color(0xff4e0006),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb3ae),
      onColor: Color(0xff68000b),
      colorContainer: Color(0xfff95a56),
      onColorContainer: Color(0xff4e0006),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb3ae),
      onColor: Color(0xff68000b),
      colorContainer: Color(0xfff95a56),
      onColorContainer: Color(0xff4e0006),
    ),
  );

  /// Monday
  static const monday = ExtendedColor(
    seed: Color(0xfffbc02d),
    value: Color(0xfffbc02d),
    light: ColorFamily(
      color: Color(0xff795900),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff795900),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff795900),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
    dark: ColorFamily(
      color: Color(0xffffe2aa),
      onColor: Color(0xff402d00),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffe2aa),
      onColor: Color(0xff402d00),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffe2aa),
      onColor: Color(0xff402d00),
      colorContainer: Color(0xfffbc02d),
      onColorContainer: Color(0xff6c5000),
    ),
  );

  /// Tuesday
  static const tuesday = ExtendedColor(
    seed: Color(0xffec407a),
    value: Color(0xffec407a),
    light: ColorFamily(
      color: Color(0xffb50a53),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd72f6b),
      onColorContainer: Color(0xfffffbff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xffb50a53),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd72f6b),
      onColorContainer: Color(0xfffffbff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xffb50a53),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd72f6b),
      onColorContainer: Color(0xfffffbff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xfffd4e87),
      onColorContainer: Color(0xff400018),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xfffd4e87),
      onColorContainer: Color(0xff400018),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xfffd4e87),
      onColorContainer: Color(0xff400018),
    ),
  );

  /// Wednesday
  static const wednesday = ExtendedColor(
    seed: Color(0xff66bb6a),
    value: Color(0xff66bb6a),
    light: ColorFamily(
      color: Color(0xff126d27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff126d27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff126d27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
    dark: ColorFamily(
      color: Color(0xff83da85),
      onColor: Color(0xff00390e),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff83da85),
      onColor: Color(0xff00390e),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff83da85),
      onColor: Color(0xff00390e),
      colorContainer: Color(0xff66bb6a),
      onColorContainer: Color(0xff004814),
    ),
  );

  /// Thursday
  static const thursday = ExtendedColor(
    seed: Color(0xffffa55e),
    value: Color(0xffffa55e),
    light: ColorFamily(
      color: Color(0xff914c08),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff914c08),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff914c08),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
    dark: ColorFamily(
      color: Color(0xffffcba7),
      onColor: Color(0xff4e2500),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffcba7),
      onColor: Color(0xff4e2500),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffcba7),
      onColor: Color(0xff4e2500),
      colorContainer: Color(0xffffa55e),
      onColorContainer: Color(0xff743a00),
    ),
  );

  /// Friday
  static const friday = ExtendedColor(
    seed: Color(0xff42a5f5),
    value: Color(0xff42a5f5),
    light: ColorFamily(
      color: Color(0xff00629d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff00629d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff00629d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
    dark: ColorFamily(
      color: Color(0xff99cbff),
      onColor: Color(0xff003355),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff99cbff),
      onColor: Color(0xff003355),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff99cbff),
      onColor: Color(0xff003355),
      colorContainer: Color(0xff42a5f5),
      onColorContainer: Color(0xff00395e),
    ),
  );

  /// Saturday
  static const saturday = ExtendedColor(
    seed: Color(0xffab47bc),
    value: Color(0xffab47bc),
    light: ColorFamily(
      color: Color(0xff8f2ba1),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff8f2ba1),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff8f2ba1),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
    dark: ColorFamily(
      color: Color(0xfff8acff),
      onColor: Color(0xff570067),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xfff8acff),
      onColor: Color(0xff570067),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xfff8acff),
      onColor: Color(0xff570067),
      colorContainer: Color(0xffab47bc),
      onColorContainer: Color(0xfffff6fa),
    ),
  );

  /// Blue
  static const blue = ExtendedColor(
    seed: Color(0xff3b82f6),
    value: Color(0xff3b82f6),
    light: ColorFamily(
      color: Color(0xff0058be),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2170e4),
      onColorContainer: Color(0xfffefcff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff0058be),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2170e4),
      onColorContainer: Color(0xfffefcff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff0058be),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2170e4),
      onColorContainer: Color(0xfffefcff),
    ),
    dark: ColorFamily(
      color: Color(0xffadc6ff),
      onColor: Color(0xff002e6a),
      colorContainer: Color(0xff4d8eff),
      onColorContainer: Color(0xff001c46),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffadc6ff),
      onColor: Color(0xff002e6a),
      colorContainer: Color(0xff4d8eff),
      onColorContainer: Color(0xff001c46),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffadc6ff),
      onColor: Color(0xff002e6a),
      colorContainer: Color(0xff4d8eff),
      onColorContainer: Color(0xff001c46),
    ),
  );

  /// Orange
  static const orange = ExtendedColor(
    seed: Color(0xfff59e0b),
    value: Color(0xfff59e0b),
    light: ColorFamily(
      color: Color(0xff855300),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff855300),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff855300),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
    dark: ColorFamily(
      color: Color(0xffffc174),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffc174),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffc174),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xfff59e0b),
      onColorContainer: Color(0xff613b00),
    ),
  );

  /// Grey
  static const grey = ExtendedColor(
    seed: Color(0xff5f6368),
    value: Color(0xff5f6368),
    light: ColorFamily(
      color: Color(0xff474b50),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff474b50),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff474b50),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
    dark: ColorFamily(
      color: Color(0xffc3c7cc),
      onColor: Color(0xff2d3135),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffc3c7cc),
      onColor: Color(0xff2d3135),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffc3c7cc),
      onColor: Color(0xff2d3135),
      colorContainer: Color(0xff5f6368),
      onColorContainer: Color(0xffdcdfe5),
    ),
  );

  /// Purple
  static const purple = ExtendedColor(
    seed: Color(0xff8b5cf6),
    value: Color(0xff8b5cf6),
    light: ColorFamily(
      color: Color(0xff6b38d4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff8455ef),
      onColorContainer: Color(0xfffffbff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff6b38d4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff8455ef),
      onColorContainer: Color(0xfffffbff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff6b38d4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff8455ef),
      onColorContainer: Color(0xfffffbff),
    ),
    dark: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3c0091),
      colorContainer: Color(0xffa078ff),
      onColorContainer: Color(0xff14003b),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3c0091),
      colorContainer: Color(0xffa078ff),
      onColorContainer: Color(0xff14003b),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3c0091),
      colorContainer: Color(0xffa078ff),
      onColorContainer: Color(0xff14003b),
    ),
  );

  /// Green
  static const green = ExtendedColor(
    seed: Color(0xff10b981),
    value: Color(0xff10b981),
    light: ColorFamily(
      color: Color(0xff006c49),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006c49),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006c49),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
    dark: ColorFamily(
      color: Color(0xff4edea3),
      onColor: Color(0xff003824),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff4edea3),
      onColor: Color(0xff003824),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff4edea3),
      onColor: Color(0xff003824),
      colorContainer: Color(0xff10b981),
      onColorContainer: Color(0xff00422b),
    ),
  );

  List<ExtendedColor> get extendedColors => [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    blue,
    orange,
    grey,
    purple,
    green,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
