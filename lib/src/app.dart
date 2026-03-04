import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/core/theme/material_theme_builder.dart';
import 'package:studall/src/core/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return ShadApp.router(
      debugShowCheckedModeBanner: true,
      themeMode: themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      materialThemeBuilder: (context, theme) =>
          materialThemeBuilder(context, theme),
      routerConfig: router,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
    );
  }
}
