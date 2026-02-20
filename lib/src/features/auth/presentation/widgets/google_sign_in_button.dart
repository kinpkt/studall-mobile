import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../controllers/log_in_controller.dart';

class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<Color> _googleColors = const [
    Color(0xFF34A853),
    Color(0xFF4285F4),
    Color(0xFFE94235),
    Color(0xFFFBBC04),
    Color(0xFF34A853),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginControllerProvider).isLoading;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8,
            ),
            gradient: SweepGradient(
              colors: _googleColors,
              transform: GradientRotation(_controller.value * 2 * pi),
            ),
          ),
          child: child,
        );
      },
      child: ShadButton(
        width: double.infinity,
        size: ShadButtonSize.lg,
        onPressed: isLoading
            ? null
            : () => ref.read(loginControllerProvider.notifier).googleLogin(),
        leading: SvgPicture.asset(
          'assets/logos/Google.svg',
          height: 20,
          width: 20,
        ),
        child: const Text('เข้าสู่ระบบด้วย Google'),
      ),
    );
  }
}
