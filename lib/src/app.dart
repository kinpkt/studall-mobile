import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/presentation/screens/login_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ShadApp(
      themeMode: themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      home: const LoginScreen(),
      materialThemeBuilder: (context, theme) {
        final shadTheme = ShadTheme.of(context);
        final shadColorScheme = shadTheme.colorScheme;
        return ThemeData(
          brightness: shadTheme.brightness,
          scaffoldBackgroundColor: shadColorScheme.background,
          colorScheme: ColorScheme(
            brightness: shadTheme.brightness,
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
                return IconThemeData(
                  color: shadColorScheme.secondaryForeground,
                );
              }
              return IconThemeData(
                color: shadColorScheme.secondaryForeground.withValues(
                  alpha: 0.5,
                ),
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return shadTheme.textTheme.custom['xsmall']!.copyWith(
                  color: shadColorScheme.secondaryForeground,
                  fontWeight: FontWeight.w600,
                );
              }
              return shadTheme.textTheme.custom['xsmall']!.copyWith(
                color: shadColorScheme.secondaryForeground.withValues(
                  alpha: 0.5,
                ),
              );
            }),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: shadColorScheme.primary,
            foregroundColor: shadColorScheme.primaryForeground,
          )
        );
      },
    );
  }
}
