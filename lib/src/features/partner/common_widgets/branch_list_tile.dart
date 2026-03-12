import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';

class BranchListTile extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback? onTap;

  const BranchListTile({super.key, required this.branch, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: colorScheme.background),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.custom['orange'],
                borderRadius: BorderRadius.circular(12),
                boxShadow: theme.shadows.sm,
              ),
              child: Center(
                child: Icon(
                  PhosphorIconsRegular.storefront,
                  color: colorScheme.custom['orangeForeground'],
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    branch.name,
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    branch.partnerName,
                    style: textTheme.muted.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: branch.status.getColor(theme).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                branch.status.thaiStatus,
                style: textTheme.muted.copyWith(
                  color: branch.status.getColor(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
