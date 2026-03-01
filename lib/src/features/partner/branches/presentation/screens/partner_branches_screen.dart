import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/data/repositories/branch_firestore_repository.dart';
import 'package:studall/src/features/partner/branches/presentation/widgets/branch_details_card.dart';

final partnerBranchesProvider = StreamProvider<List<BranchModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(branchFirestoreRepositoryProvider);
  return repository.getBranchesByUserId(currentUser.uid);
});

class PartnerBranchesScreen extends ConsumerWidget {
  const PartnerBranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    final branchesAsync = ref.watch(partnerBranchesProvider);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('สาขาทั้งหมด', style: theme.textTheme.h2),
            const SizedBox(height: 16),

            branchesAsync.when(
              loading: () => Text('Loading...', style: theme.textTheme.p),
              error: (err, stack) => Text('ERROR: $err', style: theme.textTheme.p),
              data: (branches) {
                if (branches.isEmpty) {
                  return Text('ไม่มีสาขาที่เพิ่มไว้', style: theme.textTheme.h1);
                }

                return Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: branches.map((branch) {
                    return BranchDetailsCard(
                      branch: branch,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}