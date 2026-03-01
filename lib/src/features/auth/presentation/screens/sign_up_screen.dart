import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_controller.dart';

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

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }
    return null;
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'กรุณากรอกชื่อผู้ใช้งาน';
    } else if (value.length < 2) {
      return 'ชื่อผู้ใช้งานต้องมีอย่างน้อย 2 ตัวอักษร';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    } else if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    } else if (value.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    } else if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
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
    final signUpState = ref.watch(authControllerProvider);
    final isLoading = signUpState.isLoading;

    ref.listen(authControllerProvider, (_, next) {
      if (next.hasError) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('สร้างบัญชีไม่สำเร็จ'),
            description: Text(next.error.toString()),
            alignment: Alignment.topCenter,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 392),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('สร้างบัญชีใหม่', style: theme.textTheme.h3),
                            const SizedBox(height: 8),
                            Text(
                              'กรอกข้อมูลเพื่อเปิดใช้งานบัญชีของคุณ',
                              style: theme.textTheme.muted.copyWith(
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    ShadInputFormField(
                      controller: _emailController,
                      id: 'email',
                      label: const Text('อีเมล'),
                      placeholder: const Text('m@example.com'),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _nameController,
                      id: 'username',
                      label: const Text('ชื่อผู้ใช้'),
                      placeholder: const Text('นอนน้อย'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _passwordController,
                      id: 'password',
                      label: const Text('รหัสผ่าน'),
                      obscureText: true,
                      placeholder: const Text('กรอกรหัสผ่าน'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _confirmPasswordController,
                      id: 'confirm-password',
                      label: const Text('ยืนยันรหัสผ่าน'),
                      obscureText: true,
                      placeholder: const Text('กรอกรหัสผ่านอีกครั้ง'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),
                    ShadButton(
                      size: ShadButtonSize.lg,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signUp(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                      username: _nameController.text.trim(),
                                    );
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primaryForeground),
                            )
                          : const Text('สร้างบัญชี'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'มีบัญชีแล้วใช่ไหม? ',
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _navigateToLogin();
                          },
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: theme.textTheme.muted.copyWith(
                              color: theme.colorScheme.foreground,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
