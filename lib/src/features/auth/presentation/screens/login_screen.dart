import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/login_controller.dart';
import '../widgets/google_sign_in_button.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    ref.listen(loginControllerProvider, (_, next) {
      if (next.hasError) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('เข้าสู่ระบบไม่สำเร็จ'),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GoogleSignInButton(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: theme.colorScheme.border),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'หรือดำเนินการด้วย',
                            style: theme.textTheme.muted.copyWith(
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: theme.colorScheme.border),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    ShadInputFormField(
                      controller: _emailController,
                      label: const Text('อีเมล'),
                      placeholder: const Text('m@example.com'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _passwordController,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('รหัสผ่าน'),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to Forgot Password
                            },
                            child: Text(
                              'ลืมรหัสผ่าน',
                              style: theme.textTheme.muted.copyWith(
                                color: theme.colorScheme.foreground,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      obscureText: _obscurePassword,
                      placeholder: const Text('••••••••'),
                      trailing: ShadIconButton.ghost(
                        width: 24,
                        height: 24,
                        padding: EdgeInsets.zero,
                        decoration: const ShadDecoration(
                          border: ShadBorder.none,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? LucideIcons.eye
                              : LucideIcons.eyeOff,
                          size: 20,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    ShadButton.secondary(
                      width: double.infinity,
                      size: ShadButtonSize.lg,
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              String? errorMessage;

                              if (email.isEmpty) {
                                errorMessage = 'กรุณากรอกอีเมล';
                              } else if (!email.contains('@')) {
                                errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
                              } else if (password.isEmpty) {
                                errorMessage = 'กรุณากรอกรหัสผ่าน';
                              } else if (password.length < 6) {
                                errorMessage =
                                    'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                              }

                              if (errorMessage != null) {
                                ShadToaster.of(context).show(
                                  ShadToast.destructive(
                                    title: const Text('ข้อมูลไม่ถูกต้อง'),
                                    description: Text(errorMessage),
                                    alignment: Alignment.topCenter,
                                  ),
                                );
                              } else {
                                ref
                                    .read(loginControllerProvider.notifier)
                                    .login(email, password);
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('เข้าสู่ระบบ'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีบัญชีใช่ไหม? ',
                          style: theme.textTheme.muted.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to Sign Up
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ));
                          },
                          child: Text(
                            'เริ่มสร้างบัญชี',
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
