import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/radio_card.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import '../../../user/common_widgets/student_app_bar.dart';

/// Screen for selecting user role during registration.
/// Uses Role enum (student, partner)
class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  Role? _selectedRole = Role.student;

  void _handleRegister() {
    if (_selectedRole == null) {
      return;
    }

    // TODO: Navigate to next step of registration with selected role
    // context.push('/register/details', extra: _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: StudentAppbar(
        pageTitle: '',
        showNextEvent: false,
        showSubtitle: false,
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 394),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        title: 'สำหรับผู้นักเรียน',
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
                    onPressed: _selectedRole != null ? _handleRegister : null,
                    size: ShadButtonSize.lg,
                    width: double.infinity,
                    child: const Text('ลงทะเบียน'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
