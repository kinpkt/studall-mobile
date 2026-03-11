import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_add_edit_branch_screen.dart';

import '../../data/repositories/branch_firestore_repository.dart';

class BranchDetailsCard extends ConsumerWidget {
  final BranchModel branch;

  const BranchDetailsCard({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    return ShadCard(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                branch.name,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartnerAddEditBranchScreen(branch: branch),
                    ),
                  );
                },
                icon: const Icon(PhosphorIconsRegular.notePencil),
              ),
              IconButton(
                onPressed: () async {
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => ShadDialog.alert(
                      title: const Text('ยืนยันการลบ'),
                      description: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text('คุณต้องการลบสาขานี้ใช่หรือไม่?'),
                      ),
                      actions: [
                        ShadButton.outline(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('ยกเลิก'),
                        ),
                        ShadButton.destructive(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('ลบ'),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    try {
                      final branchRepo = ref.read(branchFirestoreRepositoryProvider);
                      await branchRepo.deleteBranch(currentUser.uid, branch);
                    }
                    catch (e) {
                      debugPrint('$e');
                    }
                  }
                },
                icon: const Icon(PhosphorIconsRegular.trash, color: Colors.red),
              ),
            ],
          )
        ],
      ),
      description: Text.rich(
        TextSpan(
          text: 'สถานะ: ',
          children: [
            TextSpan(
              text: branch.status.thaiStatus,
              style: TextStyle(
                color: branch.status.getColor(theme),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}