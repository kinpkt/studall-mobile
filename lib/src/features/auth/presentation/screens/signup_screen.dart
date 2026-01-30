// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_controller.dart';
// import '../widgets/auth_text_field.dart';
// import '../widgets/google_sign_in_button.dart';
// import '../widgets/or_divider.dart';

// class SignupScreen extends ConsumerStatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   ConsumerState<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends ConsumerState<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignup() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       await ref
//           .read(authControllerProvider.notifier)
//           .signUpWithEmail(
//             email: _emailController.text.trim(),
//             password: _passwordController.text,
//             displayName: _nameController.text.trim(),
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

//   void _navigateToLogin() {
//     Navigator.pop(context);
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
//                 const SizedBox(height: 40),

//                 // Title
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Sign up to get started',
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 40),

//                 // Name Field
//                 AuthTextField(
//                   controller: _nameController,
//                   label: 'Full Name',
//                   hint: 'Enter your full name',
//                   prefixIcon: const Icon(Icons.person_outlined),
//                   enabled: !authState.isLoading,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

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
//                 const SizedBox(height: 16),

//                 // Confirm Password Field
//                 AuthTextField(
//                   controller: _confirmPasswordController,
//                   label: 'Confirm Password',
//                   hint: 'Re-enter your password',
//                   isPassword: true,
//                   prefixIcon: const Icon(Icons.lock_outlined),
//                   enabled: !authState.isLoading,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),

//                 // Sign Up Button
//                 ElevatedButton(
//                   onPressed: authState.isLoading ? null : _handleSignup,
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
//                           'Sign Up',
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

//                 // Login Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account? ',
//                       style: TextStyle(color: Colors.grey.shade600),
//                     ),
//                     TextButton(
//                       onPressed: authState.isLoading ? null : _navigateToLogin,
//                       child: const Text(
//                         'Sign In',
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
