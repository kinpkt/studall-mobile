import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/radio_card.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:go_router/go_router.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  Role? _selectedRole = Role.student;

  void _handleRegister(BuildContext context) {
    print('Selected Role: $_selectedRole'); // Debug print
    if (_selectedRole == Role.student) {
      context.pushReplacementNamed('/student/home');
    } else if (_selectedRole == Role.partner) {
      context.go('/partner-layout');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        bottom: true,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 392),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),

                  Column(
                    children: [
                      Text(
                        'ลงทะเบียนบทบาทของคุณ',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.h3.copyWith(
                          color: colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เลือกประเภทบัญชีเพื่อเริ่มต้นใช้งาน',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Role Selection Cards
                  Column(
                    children: [
                      // Student Role Card
                      RadioCard<Role>(
                        title: 'สำหรับนักเรียน / นักศึกษา',
                        description:
                            'จัดการตารางเรียน ติดตามการบ้าน \nรับการแจ้งเตือนเพื่อไม่พลาดทุกคลาสสำคัญ',
                        value: Role.student,
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        backgroundImage: 'assets/images/student.png',
                      ),
                      const SizedBox(height: 16),
                      // Partner Role Card
                      RadioCard<Role>(
                        title: 'สำหรับร้านค้าธุรกิจ',
                        description:
                            'เพิ่มยอดขายด้วยการเชื่อมต่อร้านค้าของคุณ \nเข้ากับคอมมูนิตี้ของนักเรียนโดยตรง',
                        value: Role.partner,
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        backgroundImage: 'assets/images/partner.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  ShadButton(
                    onPressed: _selectedRole != null
                        ? () => _handleRegister(context)
                        : null,
                    size: ShadButtonSize.lg,
                    width: double.infinity,
                    child: const Text('ลงทะเบียน'),
                  ),
                  const SizedBox(height: 56),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CommonAppbar _buildAppBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonAppbar(
      leading: [
        Consumer(
          builder: (context, ref, _) {
            final authRepository = ref.watch(authFirebaseRepositoryProvider);
            return GestureDetector(
              child: Row(
                children: [
                  Icon(
                    size: 24.0,
                    PhosphorIconsRegular.signOut,
                    color: colorScheme.foreground,
                  ),
                  const SizedBox(width: 8),
                  Text('ออกจากระบบ', style: theme.textTheme.p),
                ],
              ),
              onTap: () => authRepository.signOut(),
            );
          },
        ),
      ],
      actions: [
        // Consumer(
        //   builder: (context, ref, _) {
        //     final authState = ref.watch(authStateProvider);
        //     return authState.when(
        //       data: (user) {
        //         return ShadAvatar(
        //           user,
        //           size: const Size.square(40),
        //           backgroundColor: colorScheme.muted,
        //           placeholder: Initicon(
        //             text: user?.username ?? "SA",
        //             style: TextStyle(
        //               fontSize: 12,
        //               fontWeight: FontWeight.w400,
        //               color: colorScheme.foreground,
        //               height: 20 / 12,
        //             ),
        //           ),
        //         );
        //       },
        //       loading: () => const Scaffold(
        //         body: Center(child: CircularProgressIndicator()),
        //       ),
        //       error: (e, trace) =>
        //           Scaffold(body: Center(child: Text('Error: $e'))),
        //     );
        //   },
        // ),
      ],
    );
  }
}
