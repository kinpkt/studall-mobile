import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/common_widgets/plain_text_app_bar.dart';
import 'package:studall/src/features/admin/approval/presentation/screens/admin_approval_screen.dart';
import 'package:studall/src/features/admin/home/presentation/screens/admin_home_screen.dart';
import 'package:studall/src/features/admin/users/presentation/screens/admin_users_screen.dart';
import '../providers/admin_layout_controller.dart';

class AdminLayoutScreen extends ConsumerWidget {
  const AdminLayoutScreen({super.key});

  List<Widget> get _pages {
    return [
      Center(child: AdminHomeScreen()),
      Center(child: AdminUsersScreen()),
      Center(child: AdminApprovalScreen())
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
        icon: Icon(PhosphorIconsRegular.userCircle),
        selectedIcon: Icon(PhosphorIconsFill.userCircle),
        label: 'ผู้ใช้งาน',
      ),
      NavigationDestination(
        icon: Icon(PhosphorIconsRegular.checkCircle),
        selectedIcon: Icon(PhosphorIconsFill.checkCircle),
        label: 'การอนุมัติ',
      ),
    ];
  }

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    return PlainTextAppBar(text: 'Admin');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminLayoutControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(currentIndex),
        body: IndexedStack(index: currentIndex, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(adminLayoutControllerProvider.notifier).setIndex(index);
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}
