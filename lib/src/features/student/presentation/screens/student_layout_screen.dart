import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/student/common_widgets/student_app_bar.dart';
import 'package:studall/src/features/student/courses/presentation/screens/courses_screen.dart';
import 'package:studall/src/features/student/home/presentation/screens/student_home_screen.dart';
import 'package:studall/src/features/student/tasks/presentation/screens/tasks_screen.dart';
import '../../explore/presentation/screens/explore_screen.dart';
import '../../notes/presentation/screens/notes_screen.dart';
import '../providers/student_layout_controller.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StudentLayoutScreen extends ConsumerWidget {
  const StudentLayoutScreen({super.key});

  List<Widget> get _pages {
    return [
      Center(child: StudentHomeScreen()),
      Center(child: CoursesScreen()),
      Center(child: TasksScreen()),
      Center(child: NotesScreen()),
      Center(child: ExploreScreen()),
    ];
  }

  List<NavigationDestination> get _destinations {
    return [
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
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int currentIndex) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    const studentPageTitles = [null, 'รายวิชา', 'ที่ต้องทำ', 'บันทึก', 'สำรวจ'];

    final title = currentIndex < studentPageTitles.length
        ? studentPageTitles[currentIndex]
        : null;

    return StudentAppbar(
      showNextEvent: currentIndex == 0,
      showSubtitle: currentIndex != 4,
      pageTitle: title,
      actions: [
        ShadIconButton.outline(
          iconSize: 24,
          foregroundColor: colorScheme.foreground,
          decoration: ShadDecoration(shape: BoxShape.circle),
          onPressed: () {},
          icon: Icon(PhosphorIconsRegular.bell),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(studentLayoutControllerProvider);
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: _buildAppBar(context, currentIndex),
        body: SingleChildScrollView(child: IndexedStack(index: currentIndex, children: _pages)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(PhosphorIconsRegular.plus),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(studentLayoutControllerProvider.notifier).setIndex(index);
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}
