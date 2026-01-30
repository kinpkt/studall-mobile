import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(PhosphorIconsRegular.plus),
      ),
      body: <Widget>[
         SizedBox.expand(child: Center(child: Text('หน้าหลัก'))),
         SizedBox.expand(child: Center(child: Text('วิชา'))),
         SizedBox.expand(child: Center(child: Text('ที่ต้องทำ'))),
         SizedBox.expand(child: Center(child: Text('สำรวจ'))),
         SizedBox.expand(child: Center(child: Text('เครื่องมือ'))),
      ][currentPageIndex],
    );
  }
}
