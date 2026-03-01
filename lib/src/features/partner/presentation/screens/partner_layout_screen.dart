import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/plain_text_app_bar.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_branches_screen.dart';
import 'package:studall/src/features/partner/home/presentation/screens/partner_home_screen.dart';
import 'package:studall/src/features/partner/requests/presentation/screens/partner_requests_screen.dart';
import '../providers/partner_layout_controller.dart';

class PartnerLayoutScreen extends ConsumerWidget {
  const PartnerLayoutScreen({super.key});

  List<Widget> get _pages {
    return [
      Center(child: PartnerHomeScreen()),
      Center(child: PartnerBranchesScreen()),
      Center(child: PartnerRequestsScreen()),
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

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    return PlainTextAppBar(text: 'Partner');
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(PhosphorIconsRegular.storefront),
                title: Text('เพิ่มสาขาใหม่', style: ShadTheme.of(context).textTheme.p),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/partner-add-branch');
                },
              ),
              ListTile(
                leading: Icon(PhosphorIconsRegular.newspaper),
                title: Text('เพิ่มโฆษณาใหม่', style: ShadTheme.of(context).textTheme.p),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/partner-add-advertisement');
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
    final currentIndex = ref.watch(partnerLayoutControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(currentIndex),
        body: SingleChildScrollView(child: IndexedStack(index: currentIndex, children: _pages)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(partnerLayoutControllerProvider.notifier).setIndex(index);
          },
          destinations: _destinations,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddOptions(context);
          },
          child: Icon(PhosphorIconsRegular.plus),
        ),
      ),
    );
  }
}
