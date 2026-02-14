import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/advertisement.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/tools_item_card.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/working_space_item_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Hardcoded datasource for tools:
    List<Map<String, String>> tools = [
      {
        'name': 'ถ่ายรูปจดโน้ต',
        'path': '/photo'
      },
      {
        'name': 'รวมไฟล์ PDF',
        'path': '/merge-pdf',
      },
      {
        'name': 'คำนวณเกรดเฉลี่ย',
        'path': '/gpa-calculator',
      },
    ];

    List<Map<String, dynamic>> workingSpaceTypes = [
      {
        'description': 'คาเฟ่',
        'icon': Icon(PhosphorIconsBold.coffee),
      },
      {
        'description': '24 ชม.',
        'icon': Icon(PhosphorIconsBold.clock),
      },
      {
        'description': 'ห้องสมุด',
        'icon': Icon(PhosphorIconsBold.books),
      },
      {
        'description': 'ห้องประชุม',
        'icon': Icon(PhosphorIconsBold.presentationChart),
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Advertisement(),
          Row(
            spacing: 16.0,
            children: [
              Text('เครื่องมือต่าง ๆ', style: theme.textTheme.h3,),
              ShadBadge.destructive(child: Text('ใหม่'))
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(tools.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ToolsItemCard(
                      name: tools[index]['name'] ?? '',
                      path: tools[index]['path'] ?? ''
                  ),
                );
              }),
            ),
          ),
          Text('หาที่อ่านหนังสืออยู่รึเปล่า?', style: theme.textTheme.h3,),
          Text('ประเภท', style: theme.textTheme.h4,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(workingSpaceTypes.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: WorkingSpaceItemCard(
                      description: workingSpaceTypes[index]['description'] ?? '',
                      icon: workingSpaceTypes[index]['icon'],
                  ),
                );
              }),
            ),
          ),
          ShadButton(
            width: 500,
            height: 64,
            child: Text('หรือค้นหาจากตำแหน่งของฉัน', style: theme.textTheme.h3,),
          )
        ],
      )
    );
  }
}
