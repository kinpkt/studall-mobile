import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/student/common_widgets/student_app_bar.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_list_provider.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/add_edit_course_modal.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StudentLayoutScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const StudentLayoutScreen({super.key, required this.navigationShell});

  static const _allDestinations = [
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.cardsThree),
      selectedIcon: Icon(PhosphorIconsFill.cardsThree),
      label: 'หน้าหลัก',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.chalkboardSimple),
      selectedIcon: Icon(PhosphorIconsFill.chalkboardSimple),
      label: 'รายวิชา',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.listChecks),
      selectedIcon: Icon(PhosphorIconsFill.listChecks),
      label: 'ที่ต้องทำ',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.notebook),
      selectedIcon: Icon(PhosphorIconsFill.notebook),
      label: 'บันทึก',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.compass),
      selectedIcon: Icon(PhosphorIconsFill.compass),
      label: 'สำรวจ',
    ),
  ];

  List<NavigationDestination> _getDestinations(bool hasCourses) {
    if (hasCourses) return _allDestinations;
    // ซ่อน ที่ต้องทำ (2) และ บันทึก (3)
    return [_allDestinations[0], _allDestinations[1], _allDestinations[4]];
  }

  int _branchToDisplayIndex(int branchIndex, bool hasCourses) {
    if (hasCourses) return branchIndex;
    return switch (branchIndex) {
      0 => 0,
      1 => 1,
      4 => 2,
      _ => 0,
    };
  }

  int _displayToBranchIndex(int displayIndex, bool hasCourses) {
    if (hasCourses) return displayIndex;
    return switch (displayIndex) {
      0 => 0,
      1 => 1,
      2 => 4,
      _ => 0,
    };
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int currentIndex) {
    const studentPageTitles = [null, 'รายวิชา', 'ที่ต้องทำ', 'บันทึก', 'สำรวจ'];

    final title = currentIndex < studentPageTitles.length
        ? studentPageTitles[currentIndex]
        : null;

    return StudentAppbar(
      showNextEvent: currentIndex == 0,
      showSubtitle: currentIndex != 4,
      pageTitle: title,
      onProfileTap: () => context.push('/setting'),
    );
  }

  void _showAddOptions(BuildContext context, WidgetRef ref, bool hasCourses) {
    final theme = ShadTheme.of(context);

    if (!hasCourses) {
      _showAddCourseModal(context, ref);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.listChecks),
                  title: Text('เพิ่มสิ่งที่ต้องทำ', style: theme.textTheme.p),
                  onTap: () {
                    context.push('/student/tasks/add-edit');
                  },
                ),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.notebook),
                  title: Text('เพิ่มการจดบันทึก', style: theme.textTheme.p),
                  onTap: () {
                    context.push('/student/notes/editor');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.chalkboardSimple),
                  title: Text('เพิ่มวิชาเรียน', style: theme.textTheme.p),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddCourseModal(context, ref);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddCourseModal(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    showDialog(
      context: context,
      builder: (_) => AddEditCourseModal(
        onSave: (course) async {
          final repo = ref.read(courseFirestoreRepositoryProvider);
          await repo.addCourse(userId, course);
          ref.invalidate(userCoursesProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(userCoursesProvider);
    final hasCourses =
        coursesAsync.whenOrNull(
          data: (courses) => courses.where((c) => c.isActive).isNotEmpty,
        ) ??
        false;

    final currentIndex = navigationShell.currentIndex;

    if (!hasCourses && (currentIndex == 2 || currentIndex == 3)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigationShell.goBranch(0);
      });
    }

    final displayIndex = _branchToDisplayIndex(currentIndex, hasCourses);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: _buildAppBar(context, currentIndex),
        body: navigationShell,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOptions(context, ref, hasCourses),
          child: const Icon(PhosphorIconsRegular.plus),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: displayIndex,
          onDestinationSelected: (index) {
            final branchIndex = _displayToBranchIndex(index, hasCourses);
            navigationShell.goBranch(
              branchIndex,
              initialLocation: branchIndex == navigationShell.currentIndex,
            );
          },
          destinations: _getDestinations(hasCourses),
        ),
      ),
    );
  }
}
