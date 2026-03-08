//ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── Auth providers & models ──────────────────────────────────────────────────
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

// ── Auth screens ─────────────────────────────────────────────────────────────
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/register_role_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/register_student_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/register_partner_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/select_role_screen.dart';
import 'package:studall/src/features/auth/presentation/screens/setting_screen.dart';

// ── Student layout & screens ─────────────────────────────────────────────────
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';
import 'package:studall/src/features/student/home/presentation/screens/student_home_screen.dart';
import 'package:studall/src/features/student/courses/presentation/screens/student_courses_screen.dart';
import 'package:studall/src/features/student/courses/presentation/screens/course_detail_layout.dart';
import 'package:studall/src/features/student/courses/presentation/screens/course_forums_screen.dart';
import 'package:studall/src/features/student/courses/presentation/screens/course_tasks_screen.dart';
import 'package:studall/src/features/student/courses/presentation/screens/course_notes_screen.dart';
import 'package:studall/src/features/student/tasks/presentation/screens/student_tasks_screen.dart';
import 'package:studall/src/features/student/notes/presentation/screens/student_notes_screen.dart';
import 'package:studall/src/features/student/explore/presentation/screens/student_explore_screen.dart';
import 'package:studall/src/features/student/tools/presentation/gpa_calculator_screen.dart';
import 'package:studall/src/features/student/notes/presentation/screens/student_note_quill_screen.dart';

// ── Partner layout & screens ─────────────────────────────────────────────────
import 'package:studall/src/features/partner/presentation/screens/partner_layout_screen.dart';
import 'package:studall/src/features/partner/home/presentation/screens/partner_home_screen.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_branches_screen.dart';
import 'package:studall/src/features/partner/requests/presentation/screens/partner_requests_screen.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_add_edit_branch_screen.dart';
import 'package:studall/src/features/partner/advertisements/presentation/screens/partner_add_advertisement_screen.dart';

// ── Admin layout & screens ───────────────────────────────────────────────────
import 'package:studall/src/features/admin/presentation/screens/admin_layout_screen.dart';
import 'package:studall/src/features/admin/home/presentation/screens/admin_home_screen.dart';
import 'package:studall/src/features/admin/users/presentation/screens/admin_users_screen.dart';
import 'package:studall/src/features/admin/approval/presentation/screens/admin_approval_screen.dart';

import '../../features/student/tasks/data/models/task_model.dart';
import '../../features/student/tasks/presentation/screens/student_add_edit_task_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
    _ref.listen(userProfileProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: notifier,

    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);
      final profileState = ref.read(userProfileProvider);
      final path = state.uri.path;

      if (authState.isLoading || profileState.isLoading) return null;

      if (authState.hasError) {
        if (path == '/login' || path == '/signup') return null;
        return '/login';
      }

      final firebaseUser = authState.value;
      if (firebaseUser == null) {
        if (path == '/login' || path == '/signup') return null;
        return '/login';
      }

      if (profileState.hasError) {
        try {
          final userRepository = ref.read(userFirestoreRepositoryProvider);
          await userRepository.createUserProfile(
            UserModel.fromFirebase(firebaseUser),
          );
          ref.invalidate(userProfileProvider);
          return path;
        } catch (_) {
          return '/login';
        }
      }

      final profile = profileState.value;

      if (profile == null) {
        if (path == '/login' || path == '/signup') return null;

        try {
          final userRepository = ref.read(userFirestoreRepositoryProvider);
          await userRepository.createUserProfile(
            UserModel.fromFirebase(firebaseUser),
          );
          ref.invalidate(userProfileProvider);
          return path;
        } catch (e) {
          print('[Router] Failed to recreate profile: $e');
          return '/login';
        }
      }

      if (profile.isBanned) {
        return '/login';
      }

      final isRegisteringPath =
          path == '/register-role' ||
          path == '/register-student' ||
          path == '/register-partner' ||
          path == '/setting';

      if (profile.roles.isEmpty) {
        return isRegisteringPath ? null : '/register-role';
      }

      const authPaths = {'/', '/login', '/signup', '/select-role'};
      if (authPaths.contains(path)) {
        return switch (profile.lastActiveRole) {
          Role.student => '/student/home',
          Role.partner => '/partner/home',
          Role.admin => '/admin/home',
          null => '/select-role',
        };
      }

      final role = profile.lastActiveRole;
      if (role != null) {
        final rolePrefix = '/${role.name}/';
        final isRolePath =
            path.startsWith('/student/') ||
            path.startsWith('/partner/') ||
            path.startsWith('/admin/');

        if (isRolePath && !path.startsWith(rolePrefix)) {
          return switch (role) {
            Role.student => '/student/home',
            Role.partner => '/partner/home',
            Role.admin => '/admin/home',
          };
        }
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),

      GoRoute(path: '/login', builder: (_, _) => const LogInScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignUpScreen()),
      GoRoute(
        path: '/register-role',
        builder: (_, _) => const RegisterRoleScreen(),
      ),
      GoRoute(
        path: '/register-student',
        builder: (_, _) => const RegisterStudentScreen(),
      ),
      GoRoute(
        path: '/register-partner',
        builder: (_, _) => const RegisterPartnerScreen(),
      ),
      GoRoute(
        path: '/select-role',
        builder: (_, _) => const SelectRoleScreen(),
      ),
      GoRoute(path: '/setting', builder: (_, _) => const SettingScreen()),

      GoRoute(
        path: '/student/tools/gpa-calculator',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const GPACalculatorScreen(),
      ),
      GoRoute(
        path: '/student/notes/editor',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => NoteQuillScreen(),
      ),
      GoRoute(
        path: '/partner/add-branch',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const PartnerAddEditBranchScreen(),
      ),
      GoRoute(
        path: '/partner/add-advertisement',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const PartnerAddAdvertisementScreen(),
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) =>
            StudentLayoutScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/home',
                builder: (_, _) => const StudentHomeScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/courses',
                builder: (_, _) => const StudentCoursesScreen(),
                routes: [
                  GoRoute(
                    path: ':courseId',
                    redirect: (_, state) =>
                      '/student/courses/${state.pathParameters['courseId']}/forums',
                  ),

                  ShellRoute(
                    builder: (context, state, child) => CourseDetailLayout(
                      courseId: state.pathParameters['courseId'] ?? '',
                      child: child,
                    ),
                    routes: [
                      GoRoute(
                        path: ':courseId/forums',
                        builder: (_, state) => CourseForumsScreen(
                          courseId: state.pathParameters['courseId'] ?? '',
                        ),
                      ),
                      GoRoute(
                        path: ':courseId/tasks',
                        builder: (_, state) => CourseTasksScreen(
                          courseId: state.pathParameters['courseId'] ?? '',
                        ),
                      ),
                      GoRoute(
                        path: ':courseId/notes',
                        builder: (_, state) => CourseNotesScreen(
                          courseId: state.pathParameters['courseId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/tasks',
                builder: (_, _) => const StudentTasksScreen(),
                routes: [
                  GoRoute(
                    path: 'add-edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final taskToEdit = state.extra as TaskModel?;

                      return StudentAddEditTaskScreen(task: taskToEdit);
                    },
                  ),
                ]
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/note',
                builder: (_, _) => const StudentNotesScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/explore',
                builder: (_, _) => const StudentExploreScreen(),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) =>
            PartnerLayoutScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/partner/home',
                builder: (_, _) => const PartnerHomeScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/partner/branches',
                builder: (_, _) => const PartnerBranchesScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/partner/request',
                builder: (_, _) => const PartnerRequestsScreen(),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) =>
            AdminLayoutScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/home',
                builder: (_, _) => const AdminHomeScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/users',
                builder: (_, _) => const AdminUsersScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/approve',
                builder: (_, _) => const AdminApprovalScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
