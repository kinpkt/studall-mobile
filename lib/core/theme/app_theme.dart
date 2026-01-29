import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final appThemeLight = ShadThemeData(
  brightness: Brightness.light,
  colorScheme: appColorSchemeLight,
  textTheme: appTextStyle,
);

final appThemeDark = ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: appColorSchemeDark,
  textTheme: appTextStyle,
);

final appColorSchemeLight = const ShadNeutralColorScheme.light(
  custom: {
    // Feedback
    'success': Color(0xFF00A63E),
    'successForeground': Color(0xFFFFFFFF),
    'warning': Color(0xFFE17100),
    'warningForeground': Color(0xFFFFFFFF),
    'info': Color(0xFF0084D1),
    'infoForeground': Color(0xFFFFFFFF),

    // Days of Week
    'sunday': Color(0xFFD32F2F),
    'sundayForeground': Color(0xFFFFFFFF),
    'monday': Color(0xFFFAB405),
    'mondayForeground': Color(0xFF09090B),
    'tuesday': Color(0xFFEB3370),
    'tuesdayForeground': Color(0xFFFFFFFF),
    'wednesday': Color(0xFF388E3C),
    'wednesdayForeground': Color(0xFFFFFFFF),
    'thursday': Color(0xFFDB4D00),
    'thursdayForeground': Color(0xFFFFFFFF),
    'friday': Color(0xFF1976D2),
    'fridayForeground': Color(0xFFFFFFFF),
    'saturday': Color(0xFF7B1FA2),
    'saturdayForeground': Color(0xFFFFFFFF),

    // Extra Colors
    'blue': Color(0xFF2170E4),
    'blueForeground': Color(0xFFFFFFFF),
    'orange': Color(0xFFF59E0B),
    'orangeForeground': Color(0xFFFFFFFF),
    'gray': Color(0xFF5F6368),
    'grayForeground': Color(0xFFFFFFFF),
    'purple': Color(0xFF8455EF),
    'purpleForeground': Color(0xFFFFFFFF),
    'green': Color(0xFF10B981),
    'greenForeground': Color(0xFFFFFFFF),
  },
);

final appColorSchemeDark = const ShadZincColorScheme.dark(
  custom: {
    // Feedback
    'success': Color(0xFF00A63E),
    'successForeground': Color(0xFFFFFFFF),
    'warning': Color(0xFFE17100),
    'warningForeground': Color(0xFFFFFFFF),
    'info': Color(0xFF0084D1),
    'infoForeground': Color(0xFFFFFFFF),

    // Days of Week
    'sunday': Color(0xFFD32F2F),
    'sundayForeground': Color(0xFF690005),
    'monday': Color(0xFFFBC02D),
    'mondayForeground': Color(0xFF261900),
    'tuesday': Color(0xFFEB3370),
    'tuesdayForeground': Color(0xFF31111D),
    'wednesday': Color(0xFF388E3C),
    'wednesdayForeground': Color(0xFF002204),
    'thursday': Color(0xFFDB4D00),
    'thursdayForeground': Color(0xFF341100),
    'friday': Color(0xFF2485E5),
    'fridayForeground': Color(0xFF003063),
    'saturday': Color(0xFFAA3AD9),
    'saturdayForeground': Color(0xFF320045),

    // Extra Colors
    'blue': Color(0xFF2170E4),
    'blueForeground': Color(0xFFFFFFFF),
    'orange': Color(0xFFF59E0B),
    'orangeForeground': Color(0xFFFFFFFF),
    'gray': Color(0xFF5F6368),
    'grayForeground': Color(0xFFFFFFFF),
    'purple': Color(0xFF8455EF),
    'purpleForeground': Color(0xFFFFFFFF),
    'green': Color(0xFF10B981),
    'greenForeground': Color(0xFFFFFFFF),
  },
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
