import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: 400,
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Colors.black),
      ),
      child: Text('โฆษณา', style: theme.textTheme.h1),
    );
  }
}
