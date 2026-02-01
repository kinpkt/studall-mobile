import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TasksAppBar extends StatelessWidget {
  const TasksAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ที่ต้องทำ', style: textTheme.h2),
              Row(
                children: [
                  ShadIconButton.outline(
                    width: 40,
                    height: 40,
                    decoration: const ShadDecoration(shape: BoxShape.circle),
                    icon: Icon(
                      PhosphorIconsRegular.bell,
                      color: colorScheme.foreground,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  ShadAvatar(
                    'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                    placeholder: Text('CN'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.background,
              border: Border.all(color: colorScheme.border),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: .05),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('สัปดาห์นี้', style: textTheme.h4),
                Row(
                  children: [
                    _buildSummaryStat('มอบหมายแล้ว:', '3', theme),
                    const SizedBox(width: 16),
                    _buildSummaryStat('เลยกำหนด:', '0', theme),
                  ],
                ),
              ],
            ),
          ),
        ),
         TabBar(
            isScrollable: false,
            tabs: const [
              Tab(text: 'มอบหมายแล้ว'),
              Tab(text: 'เลยกำหนด'),
              Tab(text: 'เสร็จสิ้น'),
            ],
          ),
      ],
    );
  }

  Widget _buildSummaryStat(String label, String value, ShadThemeData theme) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.p.copyWith(color: theme.colorScheme.foreground),
        children: [
          TextSpan(text: '$label '),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
