import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/common_widgets/plain_text_app_bar.dart';

class AdminLayoutScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AdminLayoutScreen({super.key, required this.navigationShell});

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
    return const PlainTextAppBar(text: 'Admin');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(currentIndex),
        body: navigationShell,
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
