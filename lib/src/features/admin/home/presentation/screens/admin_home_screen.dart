import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      spacing: 16.0,
      children: [
        ShadCard(
          width: 480,
          title: Text('ยอดผู้ใช้งานในระบบ', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('บัญชีนักเรียนนักศึกษา: XX', style: theme.textTheme.p),
              Text('บัญชีร้านค้า: XX', style: theme.textTheme.p),
            ],
          ),
        ),
        ShadCard(
          width: 400,
          title: Text('รายงาน', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('รอการตรวจสอบ: XX', style: theme.textTheme.p)],
          ),
        ),
        ShadCard(
          width: 400,
          title: Text('คำขอใช้งาน', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('รอการตรวจสอบ: XX', style: theme.textTheme.p)],
          ),
        ),
      ],
    );
  }
}
