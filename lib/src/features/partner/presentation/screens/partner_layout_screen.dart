import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/plain_text_app_bar.dart';
import 'package:studall/src/features/partner/common_widgets/partner_app_bar.dart';

class PartnerLayoutScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const PartnerLayoutScreen({super.key, required this.navigationShell});

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
        icon: Icon(PhosphorIconsRegular.article),
        selectedIcon: Icon(PhosphorIconsFill.article),
        label: 'คำขอของฉัน',
      ),
    ];
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int currentIndex) {
    const partnerPageTitles = ['หน้าหลัก', 'สาขา', 'คำขอของฉัน'];

    return PartnerAppBar(
      pageTitle: partnerPageTitles[currentIndex],
      onProfileTap: () => context.push('/setting'),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(PhosphorIconsRegular.storefront),
                title: Text(
                  'เพิ่มสาขาใหม่',
                  style: ShadTheme.of(context).textTheme.p,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/partner/add-branch');
                },
              ),
              ListTile(
                leading: Icon(PhosphorIconsRegular.newspaper),
                title: Text(
                  'เพิ่มโฆษณาใหม่',
                  style: ShadTheme.of(context).textTheme.p,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/partner/add-advertisement');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context, currentIndex),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOptions(context),
          child: Icon(PhosphorIconsRegular.plus),
        ),
      ),
    );
  }
}
