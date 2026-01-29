import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/login_controller.dart';
import '../widgets/google_sign_in_button.dart';

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
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      style: theme.textTheme.muted.copyWith(
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                      label: Text('อีเมล'),
                      placeholder: Text(
                        'm@example.com',
                        style: theme.textTheme.muted.copyWith(
                          color: theme.colorScheme.mutedForeground,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    ShadInputFormField(
                      controller: _passwordController,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      style: theme.textTheme.muted.copyWith(
                        fontSize: 16,
                        height: 24 / 16,
                      ),
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
                      placeholder: Text(
                        '••••••••',
                        style: theme.textTheme.muted.copyWith(
                          color: theme.colorScheme.mutedForeground,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_controller.dart';
// import '../widgets/auth_text_field.dart';
// import '../widgets/google_sign_in_button.dart';
// import '../widgets/or_divider.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       await ref
//           .read(authControllerProvider.notifier)
//           .signInWithEmail(
//             email: _emailController.text.trim(),
//             password: _passwordController.text,
//           );

//       if (mounted) {
//         final error = ref.read(authControllerProvider).error;
//         if (error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(error), backgroundColor: Colors.red),
//           );
//         }
//       }
//     }
//   }

//   Future<void> _handleGoogleSignIn() async {
//     await ref.read(authControllerProvider.notifier).signInWithGoogle();

//     if (mounted) {
//       final error = ref.read(authControllerProvider).error;
//       if (error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   void _navigateToSignUp() {
//     // Navigate to signup screen
//     // Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authControllerProvider);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 60),

//                 // Title
//                 const Text(
//                   'Welcome Back',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Sign in to continue',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 48),

//                 // Email Field
//                 AuthTextField(
//                   controller: _emailController,
//                   label: 'Email',
//                   hint: 'Enter your email',
//                   keyboardType: TextInputType.emailAddress,
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   enabled: !authState.isLoading,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Password Field
//                 AuthTextField(
//                   controller: _passwordController,
//                   label: 'Password',
//                   hint: 'Enter your password',
//                   isPassword: true,
//                   prefixIcon: const Icon(Icons.lock_outlined),
//                   enabled: !authState.isLoading,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),

//                 // Forgot Password
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: authState.isLoading
//                         ? null
//                         : () {
//                             // Handle forgot password
//                           },
//                     child: const Text('Forgot Password?'),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Login Button
//                 ElevatedButton(
//                   onPressed: authState.isLoading ? null : _handleLogin,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: authState.isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : const Text(
//                           'Sign In',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Divider
//                 const OrDivider(),
//                 const SizedBox(height: 24),

//                 // Google Sign In Button
//                 GoogleSignInButton(
//                   onPressed: _handleGoogleSignIn,
//                   isLoading: authState.isLoading,
//                 ),
//                 const SizedBox(height: 24),

//                 // Sign Up Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account? ",
//                       style: TextStyle(color: Colors.grey.shade600),
//                     ),
//                     TextButton(
//                       onPressed: authState.isLoading ? null : _navigateToSignUp,
//                       child: const Text(
//                         'Sign Up',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
