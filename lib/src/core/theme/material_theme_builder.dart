import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

ThemeData materialThemeBuilder(BuildContext context, ThemeData theme) {
  final shadColorScheme = ShadTheme.of(context).colorScheme;
  final shadTextStyle = ShadTheme.of(context).textTheme;
  return ThemeData(
    brightness: theme.brightness,
    scaffoldBackgroundColor: shadColorScheme.background,
    colorScheme: ColorScheme(
      brightness: theme.brightness,
      primary: shadColorScheme.primary,
      onPrimary: shadColorScheme.primaryForeground,
      primaryContainer: shadColorScheme.primary.withValues(alpha: .1),
      onPrimaryContainer: shadColorScheme.primary,
      secondary: shadColorScheme.secondary,
      onSecondary: shadColorScheme.secondaryForeground,
      secondaryContainer: shadColorScheme.secondary.withValues(alpha: .1),
      onSecondaryContainer: shadColorScheme.secondaryForeground,
      surface: shadColorScheme.background,
      onSurface: shadColorScheme.foreground,
      surfaceContainerLow: shadColorScheme.card,
      surfaceContainer: shadColorScheme.card,
      surfaceContainerHigh: shadColorScheme.popover,
      error: shadColorScheme.destructive,
      onError: shadColorScheme.destructiveForeground,
      errorContainer: shadColorScheme.destructive.withValues(alpha: .1),
      onErrorContainer: shadColorScheme.destructive,
      // ignore: deprecated_member_use
      surfaceVariant: shadColorScheme.muted,
      onSurfaceVariant: shadColorScheme.mutedForeground,
      outline: shadColorScheme.border,
      outlineVariant: shadColorScheme.input,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 62,
      backgroundColor: shadColorScheme.secondary,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: shadColorScheme.secondaryForeground);
        }
        return IconThemeData(
          color: shadColorScheme.secondaryForeground.withValues(alpha: 0.5),
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final textStyle =
            shadTextStyle.custom['xsmall'] ??
            shadTextStyle.small.copyWith(fontSize: 13, height: 14 / 13);

        if (states.contains(WidgetState.selected)) {
          return textStyle.copyWith(
            color: shadColorScheme.secondaryForeground,
            fontWeight: FontWeight.w600,
          );
        }
        return textStyle.copyWith(
          color: shadColorScheme.secondaryForeground.withValues(alpha: 0.5),
        );
      }),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: shadColorScheme.foreground,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: shadColorScheme.foreground, width: 2),
      ),
      labelColor: shadColorScheme.foreground,
      labelStyle: shadTextStyle.small.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelColor: shadColorScheme.mutedForeground,
      unselectedLabelStyle: shadTextStyle.small,
      dividerColor: shadColorScheme.border,
      dividerHeight: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: shadColorScheme.primary,
      foregroundColor: shadColorScheme.primaryForeground,
    ),
    menuTheme: MenuThemeData(
     style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    ),
  );
}
