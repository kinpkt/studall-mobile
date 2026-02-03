import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/user/common_widgets/plain_text_app_bar.dart';
import 'package:studall/src/features/user/common_widgets/student_app_bar.dart';
import 'package:studall/src/features/user/home/presentation/screens/admin_home_screen.dart';
import 'package:studall/src/features/user/home/presentation/screens/partner_home_screen.dart';
import 'package:studall/src/features/user/tasks/presentation/tasks_screen.dart';
import '../providers/app_layout_controller.dart';

class AppLayoutScreen extends ConsumerWidget {
  const AppLayoutScreen({super.key, required this.role});
  final Role role;

  List<Widget> get _pages {
    switch (role) {
      case Role.admin:
        return [
          Center(child: AdminHomeScreen()),
          Center(child: Text('วิชา')), // TODO: ใส่ SubjectScreen()
          Center(child: TasksScreen()), // TODO: ใส่ TodoScreen()
          Center(child: Text('สำรวจ')), // TODO: ใส่ ExploreScreen()
          Center(child: Text('เครื่องมือ')), // TODO: ใส่ ToolsScreen()
        ];
      case Role.student:
        return [
          Center(child: Text('หน้าหลัก')), // TODO: ใส่ Widget จริง เช่น HomeScreen()
          Center(child: Text('วิชา')), // TODO: ใส่ SubjectScreen()
          Center(child: TasksScreen()), // TODO: ใส่ TodoScreen()
          Center(child: Text('สำรวจ')), // TODO: ใส่ ExploreScreen()
          Center(child: Text('เครื่องมือ')), // TODO: ใส่ ToolsScreen()
        ];
      case Role.partner:
        return [
          Center(child: PartnerHomeScreen()),
          Center(child: Text('วิชา')), // TODO: ใส่ SubjectScreen()
          Center(child: TasksScreen()), // TODO: ใส่ TodoScreen()
          Center(child: Text('สำรวจ')), // TODO: ใส่ ExploreScreen()
          Center(child: Text('เครื่องมือ')), // TODO: ใส่ ToolsScreen()
        ];
      default:
        return [];
    }
  }

  List<NavigationDestination> get _destinations {
    switch (role) {
      case Role.admin:
        return [
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.cardsThree),
            selectedIcon: Icon(PhosphorIconsFill.cardsThree),
            label: 'หน้าหลัก',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.user),
            selectedIcon: Icon(PhosphorIconsFill.user),
            label: 'ผู้ใช้งาน',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.flag),
            selectedIcon: Icon(PhosphorIconsFill.flag),
            label: 'รายงาน',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.stamp),
            selectedIcon: Icon(PhosphorIconsFill.stamp),
            label: 'อนุมัติ',
          ),
        ];
      case Role.student:
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
      case Role.partner:
        return [
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.cardsThree),
            selectedIcon: Icon(PhosphorIconsFill.cardsThree),
            label: 'หน้าหลัก',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.storefront),
            selectedIcon: Icon(PhosphorIconsFill.storefront),
            label: 'สาขา',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.newspaper),
            selectedIcon: Icon(PhosphorIconsFill.newspaper),
            label: 'โฆษณา',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.usersThree),
            selectedIcon: Icon(PhosphorIconsFill.usersThree),
            label: 'พนักงาน',
          ),
        ];
      default:
        return [];
    }
  }

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    switch (role) {
      case Role.admin:
        return PlainTextAppBar(text: 'Admin');
      case Role.student:
        const studentPageTitles = [
          null,
          'รายวิชา',
          'ที่ต้องทำ',
          'บันทึก',
          'สำรวจ',
        ];

        final title = currentIndex < studentPageTitles.length
            ? studentPageTitles[currentIndex]
            : null;

        return StudentAppbar(
          showNextEvent: currentIndex == 0,
          showSubtitle: currentIndex != 4,
          pageTitle: title,
        );
      case Role.partner:
        return PlainTextAppBar(text: 'Partner');
      default:
        return AppBar();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appLayoutControllerProvider);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: _buildAppBar(currentIndex),
        body: IndexedStack(index: currentIndex, children: _pages),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(PhosphorIconsRegular.plus),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(appLayoutControllerProvider.notifier).setIndex(index);
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}
