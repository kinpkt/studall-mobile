import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/app_theme.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/core/theme/material_theme_builder.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/partner/advertisements/presentation/screens/partner_add_advertisement_screen.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_add_branch_screen.dart';
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';
import 'package:studall/src/features/partner/presentation/screens/partner_layout_screen.dart';
import 'package:studall/src/features/admin/presentation/screens/admin_layout_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/select_role_screen.dart';
import 'package:studall/src/features/student/tools/presentation/gpa_calculator_screen.dart';
import 'package:studall/src/core/routes/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(userProfileProvider);
    final router = ref.watch(goRouterProvider);

    return ShadApp(
      debugShowCheckedModeBanner: true,
      themeMode: themeMode,
      theme: appThemeLight,
      darkTheme: appThemeDark,
      materialThemeBuilder: (context, theme) =>
          materialThemeBuilder(context, theme),
      home: user.when(
        data: (user) {
          print('User lastActiveRole: ${user?.lastActiveRole}');
          print('User Email: ${user?.email ?? ''}');
          if (user == null){
            return const LogInScreen();
          } else if (user.isBanned) {
            return Scaffold();
          }

          if (user.roles.isEmpty) {
            return const SelectRoleScreen();
          } else if (user.lastActiveRole != null) {
            switch (user.lastActiveRole!) {
              case Role.student:
                return const StudentLayoutScreen();
              case Role.partner:
                return const PartnerLayoutScreen();
              case Role.admin:
                return const AdminLayoutScreen();
            }
          }

          return const LogInScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, trace) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
      // routerConfig: router,

      routes: {
        '/login': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/select-role': (context) => const SelectRoleScreen(),
        '/student-layout': (context) => const StudentLayoutScreen(),
        '/gpa-calculator': (context) => const GPACalculatorScreen(),
        '/partner-layout': (context) => const PartnerLayoutScreen(),
        '/partner-add-branch': (context) => const PartnerAddBranchScreen(),
        '/partner-add-advertisement': (context) =>
            const PartnerAddAdvertisementScreen(),
        '/admin-layout': (context) => const AdminLayoutScreen(),
      },
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('th', 'TH'),
      ],
    );
  }
}
