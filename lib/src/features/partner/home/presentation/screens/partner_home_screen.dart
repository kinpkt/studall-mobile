import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/data/repositories/branch_firestore_repository.dart';
import 'package:studall/src/features/partner/data/repositories/partner_firestore_repository.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/advertisement_banner.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/branch_card_minimal.dart';

import '../../../data/models/partner_model.dart';

final partnerProvider = StreamProvider<PartnerModel?>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value(null);

  final repository = ref.watch(partnerFirestoreRepositoryProvider);
  return repository.getPartnerByUserId(currentUser.uid);
});

final branchesProvider = StreamProvider<List<BranchModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(branchFirestoreRepositoryProvider);
  return repository.getBranchesByUserId(currentUser.uid);
});

final advertisementsProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAdvertisementsFromUserId(currentUser.uid);
});

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
            footer: Row(
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
          ),

          const SizedBox(height: 16.0),
          Text('สาขาของร้าน', style: theme.textTheme.h2),
          const SizedBox(height: 16.0),

          branchesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
            data: (branches) {
              if (branches.isEmpty) {
                return const Center(child: Text('ไม่มีสาขา'));
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
                return const Center(child: Text('ไม่มีโฆษณา'));
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
        ],
      ),
    );
  }
}