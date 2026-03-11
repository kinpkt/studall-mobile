import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/data/repositories/branch_firestore_repository.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/store_list_tile.dart';
import 'package:studall/src/features/student/explore/presentation/widgets/tools_item_card.dart';

import '../../../../partner/home/presentation/widgets/advertisement_banner.dart';

final advertisementsProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAllPublishedAdvertisements();
});

final allBranchesProvider = FutureProvider<List<(BranchModel, double)>>((
  ref,
) async {
  final repository = ref.watch(branchFirestoreRepositoryProvider);
  final branches = await repository.getAllBranches();
  final permitted = branches.where((b) => b.partnerIsPermitted).toList();

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );

  final withDistance = permitted.map((branch) {
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      branch.location.latitude,
      branch.location.longitude,
    );
    return (branch, distance);
  }).toList();

  withDistance.sort((a, b) => a.$2.compareTo(b.$2));
  return withDistance;
});

class StudentExploreScreen extends ConsumerWidget {
  const StudentExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final tools = [
      {'name': 'คำนวณเกรดเฉลี่ย', 'path': '/student/tools/gpa-calculator'},
    ];

    final advertisementsAsync = ref.watch(advertisementsProvider);
    final branchesAsync = ref.watch(allBranchesProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Advertisements ───────────────────────────────────────────
          advertisementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (ads) {
              if (ads.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: SizedBox(
                  height: 154,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
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
                ),
              );
            },
          ),

          // ── Tools ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                Row(
                  spacing: 12.0,
                  children: [
                    Text('เครื่องมือ', style: textTheme.custom['medium']),
                    ShadBadge.destructive(child: Text('ใหม่')),
                  ],
                ),
                if (tools.isEmpty)
                  Container(
                    width: double.infinity,
                    height: 104,
                    decoration: BoxDecoration(
                      color: colorScheme.card,
                      border: Border.all(color: colorScheme.border, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'ยังไม่มีเครื่องมือ',
                        style: textTheme.p.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: tools.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final tool = tools[index];
                        return ToolsItemCard(
                          name: tool['name']!,
                          path: tool['path']!,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('ร้านใกล้ฉัน', style: textTheme.custom['medium']),
          ),
          branchesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (branches) {
              if (branches.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    height: 104,
                    decoration: BoxDecoration(
                      color: colorScheme.card,
                      border: Border.all(color: colorScheme.border, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'ยังไม่มีร้านค้า',
                        style: textTheme.p.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final (branch, distance) = branches[index];
                  return StoreListTile(
                    topic: branch.partnerName,
                    description: branch.name,
                    distanceInMeters: distance,
                    onTap: () => context.push(
                      '/student/maps',
                      extra: branch.leafletCoordinate,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 112),
        ],
      ),
    );
  }
}
