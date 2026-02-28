import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = ValueNotifier<bool?>(null);

  ref.listen(authStateProvider, (previous, next) {
    next.when(
      data: (user) => authStateNotifier.value = user != null,
      loading: () => authStateNotifier.value = null,
      error: (err, stack) => authStateNotifier.value = false,
    );
  });

  ref.onDispose(() {
    authStateNotifier.dispose();
  });

  return GoRouter(
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      return authState.when(
        data: (user) {
          final isAuthenticated = user != null;
          final isOnLoginPage = state.fullPath == '/login';

          if (!isAuthenticated && !isOnLoginPage) {
            return '/login';
          }

          if (isAuthenticated && isOnLoginPage) {
            return '/';
          }

          return null;
        },
        loading: () => null,
        error: (err, stack) {
          final isOnLoginPage = state.fullPath == '/login';
          return isOnLoginPage ? null : '/login';
        },
      );
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LogInScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) => const StudentLayoutScreen(),
      ),
    ],
  );
});
