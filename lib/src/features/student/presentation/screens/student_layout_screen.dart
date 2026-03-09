import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/student/common_widgets/student_app_bar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StudentLayoutScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const StudentLayoutScreen({super.key, required this.navigationShell});

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

  void _showAddOptions(BuildContext context) {
    final theme = ShadTheme.of(context);

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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: _buildAppBar(context, currentIndex),
        body: navigationShell,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOptions(context),
          child: const Icon(PhosphorIconsRegular.plus),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}
