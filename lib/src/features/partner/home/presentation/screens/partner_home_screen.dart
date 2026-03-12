import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/common_widgets/branch_list_tile.dart';
import 'package:studall/src/features/partner/data/models/partner_model.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/advertisement_banner.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/branch_card_minimal.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';

import '../providers/partner_home_provider.dart';

class PartnerHomeScreen extends ConsumerWidget {
  const PartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    final partnerAsync = ref.watch(partnerProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final advertisementsAsync = ref.watch(advertisementsProvider);
    final requestsAsync = ref.watch(requestsProvider);

    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Container(
        color: colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            partnerAsync.when(
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SizedBox(
                height: 120,
                child: Center(
                  child: Text('เกิดข้อผิดพลาดในระหว่างการแสดงผล: $err'),
                ),
              ),
              data: (partner) => _buildPartnerInfo(
                context,
                partner,
                ref.watch(branchesProvider).asData?.value ?? [],
                ref.watch(advertisementsProvider).asData?.value ?? [],
              ),
            ),
            const SizedBox(height: 16),
            branchesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading items: $err')),
              data: (branches) => _buildBranchList(context, branches),
            ),
            advertisementsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading items: $err')),
              data: (ads) => _buildAdvertisementList(
                context,
                ads,
                requestsAsync.asData?.value ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerInfo(
    BuildContext context,
    PartnerModel? partner,
    List<BranchModel> branches,
    List<AdvertisementModel> ads,
  ) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.card,
        border: Border.all(color: colorScheme.border, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            partner?.name ?? '',
            style: textTheme.custom['medium']?.copyWith(
              color: colorScheme.foreground,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            partner?.description ?? '',
            style: textTheme.p.copyWith(color: colorScheme.mutedForeground),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'จำนวนสาขา: ${branches.length} สาขา',
                style: textTheme.muted.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
              Text(
                'จำนวนโฆษณา: ${ads.length} ชุด',
                style: textTheme.muted.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'สถานะร้าน: ',
                style: textTheme.muted.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
              ShadBadge(
                child: Text(
                  partner?.isPermitted == true
                      ? 'ระบบอนุมัติแล้ว'
                      : 'ระบบยังไม่อนุมัติ',
                  style: textTheme.custom['small'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchList(BuildContext context, List<BranchModel> branches) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'สาขาของร้าน',
                  style: textTheme.custom['medium']?.copyWith(
                    color: colorScheme.foreground,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.go('/partner/branches'),
                  child: Text(
                    'ทั้งหมด',
                    style: textTheme.muted.copyWith(
                      color: colorScheme.custom['info']!,
                      decoration: TextDecoration.underline,
                      decorationColor: colorScheme.custom['info']!,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (branches.isEmpty) ...[
            Container(
              width: double.infinity,
              height: 136,
              decoration: BoxDecoration(
                color: colorScheme.card,
                border: Border.all(color: colorScheme.border, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'ยังไม่มีสาขา',
                  style: textTheme.p.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              height: 136,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                itemCount: branches.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return BranchListTile(branch: branches[index]);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvertisementList(
    BuildContext context,
    List<AdvertisementModel> ads,
    List<RequestModel> requests,
  ) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'โฆษณาของร้าน',
                  style: textTheme.custom['medium']?.copyWith(
                    color: colorScheme.foreground,
                  ),
                ),
              ],
            ),
          ),
          if (ads.isEmpty) ...[
            Container(
              width: double.infinity,
              height: 68,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.card,
                border: Border.all(color: colorScheme.border, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'ไม่มีโฆษณา',
                  style: textTheme.p.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: ads.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  final matchingRequest = requests
                      .where((req) => req.id == ad.id)
                      .firstOrNull;

                  return AdvertisementBanner(
                    ads: ad,
                    status: matchingRequest?.status,
                    isDeletable: true,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
