import 'package:flutter/material.dart';

class TasksAppBar extends StatelessWidget {
  const TasksAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
       TabBar(
          isScrollable: false,
          tabs: const [
            Tab(text: 'มอบหมายแล้ว'),
            Tab(text: 'เลยกำหนด'),
            Tab(text: 'เสร็จสิ้น'),
          ],
        ),
      ],
    );
  }
}
