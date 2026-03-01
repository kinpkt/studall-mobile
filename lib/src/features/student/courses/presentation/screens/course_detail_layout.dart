import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CourseDetailLayout extends StatelessWidget {
  final String courseId;

  final Widget child;

  const CourseDetailLayout({
    super.key,
    required this.courseId,
    required this.child,
  });

  int _tabIndexFromLocation(String location) {
    if (location.endsWith('/tasks')) return 1;
    if (location.endsWith('/notes')) return 2;
    return 0;
  }

  List<NavigationDestination> get _destinations {
    return const [
      NavigationDestination(
        icon: Icon(PhosphorIconsRegular.chatCircle),
        selectedIcon: Icon(PhosphorIconsFill.chatCircle),
        label: 'ฟอรั่ม',
      ),
      NavigationDestination(
        icon: Icon(PhosphorIconsRegular.listChecks),
        selectedIcon: Icon(PhosphorIconsFill.listChecks),
        label: 'งาน',
      ),
      NavigationDestination(
        icon: Icon(PhosphorIconsRegular.notebook),
        selectedIcon: Icon(PhosphorIconsFill.notebook),
        label: 'บันทึก',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _tabIndexFromLocation(location);
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายวิชา $courseId',
          style: theme.textTheme.large,
        ),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.go('/student/courses'),
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          final tab = switch (index) {
            0 => 'forums',
            1 => 'tasks',
            2 => 'notes',
            _ => 'forums',
          };
          context.go('/student/courses/$courseId/$tab');
        },
        destinations: _destinations,
      ),
    );
  }
}
