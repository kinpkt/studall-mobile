import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_add_edit_branch_screen.dart';

class BranchDetailsCard extends StatelessWidget {
  final BranchModel branch;

  const BranchDetailsCard({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
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