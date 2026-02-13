import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/common_widgets/plain_text_app_bar.dart';
import 'package:studall/src/features/partner/home/presentation/screens/partner_home_screen.dart';
import '../providers/admin_layout_controller.dart';

class AdminLayoutScreen extends ConsumerWidget {
  const AdminLayoutScreen({super.key});

  List<Widget> get _pages {
    return [Center(child: PartnerHomeScreen())];
  }

  List<NavigationDestination> get _destinations {
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
  }

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    return PlainTextAppBar(text: 'Partner');
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
