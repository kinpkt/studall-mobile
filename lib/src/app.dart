import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/core/theme/material_theme_builder.dart';
import 'package:studall/src/features/auth/presentation/screens/login_screen.dart';
import 'package:studall/src/features/user/presentation/screens/app_layout_screen.dart';
import 'package:studall/src/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:studall/src/features/auth/presentation/screens/select_role_screen.dart';
import 'features/classroom_sync/presentation/screens/sync_classroom_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);

    return ShadApp(
      debugShowCheckedModeBanner: true,
      themeMode: themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      materialThemeBuilder: (context, theme) =>
          materialThemeBuilder(context, theme),
      home: authState.when(
        data: (user) {
          if (user != null) {
            if (user.roles.isEmpty) {
              return const SelectRoleScreen();
            } else if (user.lastActiveRole != null) {
              return AppLayoutScreen(role: Role.student);
            }
          }

          return const LoginScreen();
          // return const SyncClassroomScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, trace) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
