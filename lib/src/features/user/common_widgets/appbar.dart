import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserAppbar extends StatefulWidget {
  const UserAppbar({super.key});

  @override
  State<UserAppbar> createState() => _UserAppbarState();
}

class _UserAppbarState extends State<UserAppbar> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
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
    );
  }
}
