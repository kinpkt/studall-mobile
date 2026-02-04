import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/auth_controller.dart';
import '../widgets/google_sign_in_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _handleSignup() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     await ref
  //         .read(authControllerProvider.notifier)
  //         .signUpWithEmail(
  //           email: _emailController.text.trim(),
  //           password: _passwordController.text,
  //           displayName: _nameController.text.trim(),
  //         );
  //
  //     if (mounted) {
  //       final error = ref.read(authControllerProvider).error;
  //       if (error != null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(error), backgroundColor: Colors.red),
  //         );
  //       }
  //     }
  //   }
  // }
  //
  // Future<void> _handleGoogleSignIn() async {
  //   await ref.read(authControllerProvider.notifier).signInWithGoogle();
  //
  //   if (mounted) {
  //     final error = ref.read(authControllerProvider).error;
  //     if (error != null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(error), backgroundColor: Colors.red),
  //       );
  //     }
  //   }
  // }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final formKey = GlobalKey<ShadFormState>();
    // final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ShadForm(
              key: formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 64),
                    Text('สมัครสมาชิก', style: theme.textTheme.h1,),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      id: 'email',
                      label: const Text('อีเมล'),
                      placeholder: const Text('ตัวอย่าง: ex@example.com'),
                      validator: (v) {
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                        return emailRegex.hasMatch(v) ? null : 'กรุณากรอกอีเมลให้ถูกต้อง';
                      },
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      id: 'username',
                      label: const Text('ชื่อผู้ใช้งาน'),
                      placeholder: const Text('กรอกชื่อผู้ใช้ที่ต้องการ'),
                      validator: (v) {
                        if (v.length < 2) {
                          return 'Username must be at least 2 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      id: 'password',
                      label: const Text('รหัสผ่าน'),
                      obscureText: true,
                      placeholder: const Text('กรอกรหัสผ่าน'),
                      description: const Text('รหัสผ่านจะต้องมีความยาวไม่น้อยกว่า 8 ตัวอักษร'),
                      validator: (v) {
                        if (v.length < 8) {
                          return 'รหัสผ่านจะต้องมีความยาวไม่น้อยกว่า 8 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      id: 'confirm-password',
                      label: const Text('ยืนยันรหัสผ่าน'),
                      obscureText: true,
                      placeholder: const Text('กรอกรหัสผ่านอีกครั้ง'),
                      validator: (v) {
                        if (v.length < 8) {
                          return 'รหัสผ่านจะต้องมีความยาวไม่น้อยกว่า 8 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        if (formKey.currentState!.saveAndValidate())
                          print('validation succeeded with ${formKey.currentState!.value}');
                        else
                          print('validation failed');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
