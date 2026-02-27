import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Create a ValueNotifier to listen to auth state changes
  final authStateNotifier = ValueNotifier<bool?>(null);

  // Listen to authStateProvider and update the ValueNotifier
  ref.listen(authStateProvider, (previous, next) {
    next.when(
      data: (user) => authStateNotifier.value = user != null,
      loading: () => authStateNotifier.value = null,
      error: (err, stack) => authStateNotifier.value = false,
    );
  });

  // Dispose the ValueNotifier when the provider is disposed
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

          // If NOT authenticated and not on login page, redirect to login
          if (!isAuthenticated && !isOnLoginPage) {
            return '/login';
          }

          // If authenticated and on login page, redirect to home
          if (isAuthenticated && isOnLoginPage) {
            return '/';
          }

          // Otherwise, stay on current page
          return null;
        },
        loading: () => null, // Wait while loading
        error: (err, stack) {
          // On error, redirect to login if not already there
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
