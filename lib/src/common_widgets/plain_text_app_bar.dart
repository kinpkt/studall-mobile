import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';

class PlainTextAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onNotificationTap;

  const PlainTextAppBar({
    super.key,
    required this.text,
    this.onHistoryTap,
    this.onNotificationTap,
  });

  @override
  ConsumerState<PlainTextAppBar> createState() => _PlainTextAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _PlainTextAppBarState extends ConsumerState<PlainTextAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authFirebaseRepositoryProvider);

    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.text, style: textTheme.h1),
          Row(
            children: [
              ShadIconButton.ghost(
                icon: Icon(
                  PhosphorIconsRegular.clockCounterClockwise,
                  size: 24,
                  color: colorScheme.foreground,
                ),
                onPressed: widget.onHistoryTap ?? () {},
              ),
              ShadIconButton.ghost(
                icon: Icon(
                  PhosphorIconsRegular.bell,
                  size: 24,
                  color: colorScheme.foreground,
                ),
                onPressed:
                    widget.onNotificationTap ??
                    () {
                      authState.signOut();
                    },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
