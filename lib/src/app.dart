import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/core/theme/material_theme_builder.dart';
import 'package:studall/src/features/auth/presentation/screens/login_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ShadApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      materialThemeBuilder: (context, theme) =>
          materialThemeBuilder(context, theme),
      home: const LoginScreen(),
    );
  }
}
