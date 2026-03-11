import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkingSpaceItemCard extends StatelessWidget {
  final String description;
  final Icon icon;
  const WorkingSpaceItemCard({super.key, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShadButton(
          width: 64,
          height: 64,
          child: icon,
          // backgroundColor: theme.colorScheme.custom['blue'],
        ),
        SizedBox(height: 8,),
        Text(description, style: theme.textTheme.h4,),
      ],
    );
  }
}
