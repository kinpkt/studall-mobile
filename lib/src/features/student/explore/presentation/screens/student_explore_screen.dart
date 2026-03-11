import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/tools_item_card.dart';

import '../../../../partner/home/presentation/widgets/advertisement_banner.dart';
import '../../../maps/presentation/screens/student_maps_screen.dart';

final advertisementsProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAllPublishedAdvertisements();
});

class StudentExploreScreen extends ConsumerWidget {
  const StudentExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    List<Map<String, String>> tools = [
      {
        'name': 'จดโน้ต',
        'path': '/student/note'
      },
      {
        'name': 'คำนวณเกรดเฉลี่ย',
        'path': '/student/tools/gpa-calculator',
      },
    ];

    final advertisementsAsync = ref.watch(advertisementsProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          advertisementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (ads) {
              if (ads.isEmpty) {
                return SizedBox();
              }
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AdvertisementBanner(ads: ad),
                    );
                  },
                ),
              );
            },
          ),
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
          ShadButton(
            width: 500,
            height: 64,
            child: Text('ค้นหาร้านใกล้ฉัน', style: theme.textTheme.h3,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMapsScreen()));
            },
          )
        ],
      )
    );
  }
}
