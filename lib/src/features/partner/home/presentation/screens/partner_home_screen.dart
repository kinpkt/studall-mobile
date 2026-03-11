import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/advertisement_banner.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/branch_card_minimal.dart';

import '../providers/partner_home_provider.dart';

class PartnerHomeScreen extends ConsumerWidget {
  const PartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    final partnerAsync = ref.watch(partnerProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final advertisementsAsync = ref.watch(advertisementsProvider);
    final requestsAsync = ref.watch(requestsProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShadCard(
            width: 480,
            title: partnerAsync.when(
              loading: () => Text('Loading...', style: theme.textTheme.h2),
              error: (err, stack) => Text('ERROR', style: theme.textTheme.h2),
              data: (partner) => Text(partner?.name ?? '', style: theme.textTheme.h2),
            ),
            description: partnerAsync.when(
              loading: () => Text('Loading...', style: theme.textTheme.h4),
              error: (err, stack) => Text('ERROR', style: theme.textTheme.h4),
              data: (partner) => Text(partner?.description ?? '', style: theme.textTheme.h4),
            ),
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    branchesAsync.when(
                      loading: () => Text('จำนวนสาขา: ...', style: theme.textTheme.p),
                      error: (err, stack) => Text('จำนวนสาขา: -', style: theme.textTheme.p),
                      data: (branches) => Text('จำนวนสาขา: ${branches.length} สาขา', style: theme.textTheme.p),
                    ),
                    advertisementsAsync.when(
                      loading: () => Text('จำนวนโฆษณา: ...', style: theme.textTheme.p),
                      error: (err, stack) => Text('จำนวนโฆษณา: -', style: theme.textTheme.p),
                      data: (ads) => Text('จำนวนโฆษณา: ${ads.length} ชุด', style: theme.textTheme.p),
                    ),
                  ],
                ),
                partnerAsync.when(
                  loading: () => Text('สถานะร้าน: ...', style: theme.textTheme.p),
                  error: (err, stack) => Text('สถานะร้าน: -', style: theme.textTheme.p),
                  data: (partner) => Text('สถานะร้าน: ${partner!.isPermitted ? 'ระบบอนุมัติแล้ว' : 'ระบบยังไม่อนุมัติ'}', style: theme.textTheme.p),
                )
              ],
            ),
          ),

          const SizedBox(height: 16.0),
          Text('สาขาของร้าน', style: theme.textTheme.h2),
          const SizedBox(height: 16.0),

          branchesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (branches) {
              if (branches.isEmpty) {
                return Center(child: Text('ไม่มีสาขา', style: theme.textTheme.h4));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: branches.map((branch) => BranchCardMinimal(branch: branch)).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 16.0),
          Text('โฆษณาของร้าน', style: theme.textTheme.h2),
          const SizedBox(height: 16.0),

          advertisementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (ads) {
              if (ads.isEmpty) {
                return Center(child: Text('ไม่มีโฆษณา', style: theme.textTheme.h4));
              }

              return requestsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
                data: (requests) {
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ads.length,
                      itemBuilder: (context, index) {
                        final ad = ads[index];

                        final matchingRequest = requests
                            .where((req) => req.id == ad.id)
                            .firstOrNull;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: AdvertisementBanner(
                            ads: ad,
                            status: matchingRequest?.status,
                            isDeletable: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}