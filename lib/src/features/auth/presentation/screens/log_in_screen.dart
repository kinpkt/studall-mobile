import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/domain/auth_exceptions.dart';
import 'package:studall/src/features/auth/presentation/screens/sign_up_screen.dart';
import '../controllers/auth_controller.dart';
import '../widgets/google_sign_in_button.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
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

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final loginState = ref.watch(authControllerProvider);
    final isLoading = loginState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncError) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('เข้าสู่ระบบไม่สำเร็จ'),
            description: Text(next.error.message),
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
                    ShadInputFormField(
                      controller: _emailController,
                      label: const Text('อีเมล'),
                      placeholder: const Text('m@example.com'),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _passwordController,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('รหัสผ่าน'),
                          // GestureDetector(
                          //   onTap: () {
                          //     // TODO: Implement forgot password functionality
                          //   },
                          //   child: Text(
                          //     'ลืมรหัสผ่าน',
                          //     style: theme.textTheme.muted.copyWith(
                          //       color: theme.colorScheme.foreground,
                          //       decoration: TextDecoration.underline,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validatePassword,
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
                      size: ShadButtonSize.lg,
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signInWithEmail(
                                      email: email,
                                      password: password,
                                    );
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
                          onTap: () => context.go('/register'),
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
