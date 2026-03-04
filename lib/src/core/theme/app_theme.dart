import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/color_scheme.dart';

final appThemeLight = ShadThemeData(
  brightness: Brightness.light,
  colorScheme: AppColorScheme.lightScheme,
  textTheme: appTextStyle,
  inputTheme: appInputTheme,
  buttonSizesTheme: ShadButtonSizesTheme(
    icon: ShadButtonSizeTheme(height: 40, padding: EdgeInsets.all(8)),
  ),
  primaryDialogTheme: appDialogTheme,
  alertDialogTheme: appDialogTheme,
  selectTheme: appSelectTheme,
);

final appThemeDark = ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: AppColorScheme.darkScheme,
  textTheme: appTextStyle,
  inputTheme: appInputDarkTheme,
  buttonSizesTheme: ShadButtonSizesTheme(
    icon: ShadButtonSizeTheme(height: 40, padding: EdgeInsets.all(8)),
  ),
  primaryDialogTheme: appDialogDarkTheme,
  alertDialogTheme: appDialogDarkTheme,
  selectTheme: appSelectDarkTheme,
);

final appTextStyle = ShadTextTheme(
  family: 'Google Sans',
  custom: {
    'large24': const TextStyle(
      fontSize: 18,
      decoration: TextDecoration.none,
      fontFamily: 'Google Sans',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: 0,
    ),
    'medium': const TextStyle(
      fontSize: 16,
      decoration: TextDecoration.none,
      fontFamily: 'Google Sans',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: 24 / 16,
      letterSpacing: 0,
    ),
    'xsmall': const TextStyle(
      fontSize: 13,
      decoration: TextDecoration.none,
      fontFamily: 'Google Sans',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: 14 / 13,
      letterSpacing: 0,
    ),
  },
);

final appInputTheme = ShadInputTheme(
  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  style: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.lightScheme.foreground,
    fontWeight: FontWeight.w400,
  ),
  placeholderStyle: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.lightScheme.mutedForeground,
    fontWeight: FontWeight.w400,
  ),
);

final appInputDarkTheme = appInputTheme.copyWith(
  style: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.darkScheme.foreground,
    fontWeight: FontWeight.w400,
  ),
  placeholderStyle: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.darkScheme.mutedForeground,
    fontWeight: FontWeight.w400,
  ),
);

final appDialogTheme = ShadDialogTheme(
  constraints: BoxConstraints(minWidth: 370),
  padding: const EdgeInsets.all(16),
  radius: BorderRadius.circular(12),
  titleStyle: appTextStyle.h4.copyWith(
    color: AppColorScheme.lightScheme.foreground,
  ),
  titleTextAlign: TextAlign.left,
  descriptionTextAlign: TextAlign.left,
  backgroundColor: AppColorScheme.lightScheme.background,
  actionsAxis: Axis.horizontal,
  actionsMainAxisAlignment: MainAxisAlignment.end,
  expandActionsWhenTiny: false,
  removeBorderRadiusWhenTiny: false,
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  scrollPadding: EdgeInsets.only(bottom: 16),
);

final appDialogDarkTheme = appDialogTheme.copyWith(
  titleStyle: appTextStyle.h4.copyWith(
    color: AppColorScheme.darkScheme.foreground,
  ),
  backgroundColor: AppColorScheme.darkScheme.background,
);

final appSelectTheme = ShadSelectTheme(
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  placeholderStyle: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.lightScheme.mutedForeground,
    fontWeight: FontWeight.w400,
  ),
);

final appSelectDarkTheme = appSelectTheme.copyWith(
  placeholderStyle: appTextStyle.custom['medium']?.copyWith(
    color: AppColorScheme.darkScheme.mutedForeground,
    fontWeight: FontWeight.w400,
  ),
);
