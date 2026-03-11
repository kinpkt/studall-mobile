import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/radio_card.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_controller.dart';

class RegisterRoleScreen extends StatefulWidget {
  const RegisterRoleScreen({super.key});

  @override
  State<RegisterRoleScreen> createState() => _RegisterRoleScreenState();
}

class _RegisterRoleScreenState extends State<RegisterRoleScreen> {
  Role? _selectedRole = Role.student;

  void _handleRegister(BuildContext context) {
    print('Selected Role: $_selectedRole');
    if (_selectedRole == Role.student) {
      context.push('/register-student');
    } else if (_selectedRole == Role.partner) {
      context.push('/register-partner');
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Text(
                      'ลงทะเบียนบทบาทเริ่มต้น',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.h3.copyWith(
                        color: colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เลือกบทบาทบัญชีเพื่อเริ่มต้นใช้งาน',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.muted.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: RadioCard<Role>(
                        title: 'สำหรับนักเรียน',
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
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RadioCard<Role>(
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
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 32.0, 16.0, 0),
                child: ShadButton(
                  onPressed: _selectedRole != null
                      ? () => _handleRegister(context)
                      : null,
                  size: ShadButtonSize.lg,
                  width: double.infinity,
                  child: const Text('ลงทะเบียน'),
                ),
              ),
            ],
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
            return ShadButton.ghost(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              decoration: ShadDecoration(shape: BoxShape.circle),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    PhosphorIconsRegular.signOut,
                    color: colorScheme.foreground,
                  ),
                  Text(
                    'ออกจากระบบ',
                    style: theme.textTheme.p.copyWith(
                      color: colorScheme.foreground,
                    ),
                  ),
                ],
              ),
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(context),
            );
          },
        ),
      ],
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final userAsync = ref.watch(userProfileProvider);
            return userAsync.when(
              data: (user) {
                return GestureDetector(
                  onTap: () => context.push('/setting'),
                  child: ShadAvatar(
                    user?.photoUrl == '' ? null : user?.photoUrl,
                    size: const Size.square(40),
                    backgroundColor: colorScheme.muted,
                    placeholder: Text(
                      user?.displayName.substring(0, 2).toUpperCase() ?? 'SA',
                      style: theme.textTheme.muted.copyWith(
                        color: colorScheme.foreground,
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(
                width: 40,
                height: 40,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, trace) => Icon(
                PhosphorIconsRegular.warningCircle,
                color: colorScheme.destructive,
              ),
            );
          },
        ),
      ],
    );
  }
}
