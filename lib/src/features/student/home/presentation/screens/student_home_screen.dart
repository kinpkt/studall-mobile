import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/home/data/models/item_model.dart';
import 'package:studall/src/features/student/home/presentation/widgets/recent_item_card.dart';
import 'package:uuid/uuid.dart';

import '../../../courses/data/models/course_model.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/data/models/task_type.dart';
import '../../../tasks/presentation/widgets/to_do_list_tile.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Hardcoded datasource for items:
    List<ItemModel> items = [
      ItemModel(Uuid().v7.toString(), 'Deadlock', '01418236-65', ItemType.assignment, DateTime(2026, 2, 9)),
      ItemModel(Uuid().v7.toString(), 'Security and Protection', '01418236-65', ItemType.resource, DateTime.now()),
    ];

    return DefaultTabController(
      length: 3,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            // const Placeholder(), // TO-DO: real-time time-table schedule
            Column(
              children: [
                Row(
                  spacing: 16.0,
                  children: [
                    Text('ล่าสุด', style: theme.textTheme.h3,),
                    ShadBadge.destructive(child: Text('ใหม่'))
                  ],
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsetsGeometry.only(right: 8),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: RecentItemCard(item: items[index]),
                        ),
                      );
                    },
                  )
                ),
              ],
            ),
            Text('ที่ต้องทำสัปดาห์นี้', style: theme.textTheme.h3,),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      // ToDoListTile(task: demoTask)
                    ],
                  ),
                  // Center(child: Text("หน้ามอบหมายแล้ว")),
                  Center(child: Text("หน้าเลยกำหนด")),
                  Center(child: Text("หน้าเสร็จสิ้น")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
