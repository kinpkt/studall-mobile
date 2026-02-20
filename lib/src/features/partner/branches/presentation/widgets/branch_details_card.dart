import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';

class BranchDetailsCard extends StatefulWidget {
  final BranchModel branch;
  const BranchDetailsCard({super.key, required this.branch});

  @override
  State<BranchDetailsCard> createState() => _BranchDetailsCardState();
}

class _BranchDetailsCardState extends State<BranchDetailsCard> {
  TextSpan _getStatusText(ShadThemeData theme) {
    switch (widget.branch.status) {
      case BranchStatus.available:
        return TextSpan(
          text: 'ไม่ค่อยยุ่ง',
          style: TextStyle(
            color: theme.colorScheme.custom['green'],
            // fontWeight: FontWeight.bold,
          ),
        );
      case BranchStatus.moderate:
        return TextSpan(
          text: 'ยุ่งปานกลาง',
          style: TextStyle(
            color: theme.colorScheme.custom['warning'],
            // fontWeight: FontWeight.bold,
          ),
        );
      case BranchStatus.busy:
        return TextSpan(
          text: 'ยุ่งมาก',
          style: TextStyle(
            color: theme.colorScheme.destructive,
            // fontWeight: FontWeight.bold,
          ),
        );
      default:
        return TextSpan(
          text: 'ไม่ระบุ',
          style: TextStyle(
            color: theme.colorScheme.foreground,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.branch.name),
          IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.notePencil))
        ],
      ),
      description: Text.rich(
        TextSpan(
          text: 'สถานะ: ',
          children: [
            _getStatusText(theme),
          ]
        )
      ),
    );
  }
}
