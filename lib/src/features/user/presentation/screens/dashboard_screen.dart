import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/user/tasks/presentation/tasks_screen.dart';
import '../providers/dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const List<Widget> _pages = [
    Center(child: Text('หน้าหลัก')), // TODO: ใส่ Widget จริง เช่น HomeScreen()
    Center(child: Text('วิชา')), // TODO: ใส่ SubjectScreen()
    Center(child: TasksScreen()), // TODO: ใส่ TodoScreen()
    Center(child: Text('สำรวจ')), // TODO: ใส่ ExploreScreen()
    Center(child: Text('เครื่องมือ')), // TODO: ใส่ ToolsScreen()
  ];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.cardsThree),
      selectedIcon: Icon(PhosphorIconsFill.cardsThree),
      label: 'หน้าหลัก',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.chalkboardSimple),
      selectedIcon: Icon(PhosphorIconsFill.chalkboardSimple),
      label: 'วิชา',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.listChecks),
      selectedIcon: Icon(PhosphorIconsFill.listChecks),
      label: 'ที่ต้องทำ',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.compass),
      selectedIcon: Icon(PhosphorIconsFill.compass),
      label: 'สำรวจ',
    ),
    NavigationDestination(
      icon: Icon(PhosphorIconsRegular.squaresFour),
      selectedIcon: Icon(PhosphorIconsFill.squaresFour),
      label: 'เครื่องมือ',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(dashboardControllerProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(PhosphorIconsRegular.plus),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(dashboardControllerProvider.notifier).setIndex(index);
        },
        destinations: _destinations,
      ),
    );
  }
}
