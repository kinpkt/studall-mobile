import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/core/theme/material_theme_builder.dart';
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';
import 'package:studall/src/features/partner/presentation/screens/partner_layout_screen.dart';
import 'package:studall/src/features/admin/presentation/screens/admin_layout_screen.dart';
import 'package:studall/src/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/select_role_screen.dart';

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
            }
            else if (user.lastActiveRole != null) {
              switch (user.lastActiveRole!) {
                case Role.student:
                  return const StudentLayoutScreen();
                case Role.partner:
                  return const PartnerLayoutScreen();
                case Role.admin:
                  return const AdminLayoutScreen();
              }
            }
          }
          return const AdminLayoutScreen();
          // return const LogInScreen();
        },
        loading: () =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, trace) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/select-role': (context) => const SelectRoleScreen(),
        '/student-layout': (context) => const StudentLayoutScreen(),
        '/partner-layout': (context) => const PartnerLayoutScreen(),
        '/admin-layout': (context) => const AdminLayoutScreen(),
      },
    );
  }
}