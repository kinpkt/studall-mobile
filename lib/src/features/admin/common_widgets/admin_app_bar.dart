import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';

class AdminAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String? pageTitle;
  final String? subtitle;
  final String? userInitials;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;

  const AdminAppBar({
    super.key,
    this.pageTitle,
    this.subtitle,
    this.userInitials,
    this.onNotificationTap,
    this.onProfileTap,
    this.actions,
  });

  @override
  ConsumerState<AdminAppBar> createState() => _AdminAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(94);
}

class _AdminAppBarState extends ConsumerState<AdminAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final user = ref.watch(userProfileProvider);
    return Container(
      color: colorScheme.background,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.pageTitle ?? '',
                  style: textTheme.h2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  if (widget.actions != null) ...widget.actions!,
                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: user.when(
                      data: (user) {
                        return ShadAvatar(
                          user?.photoUrl == '' ? null : user?.photoUrl,
                          size: const Size.square(40),
                          backgroundColor: colorScheme.muted,
                          placeholder: Icon(
                            PhosphorIconsRegular.user,
                            color: colorScheme.foreground,
                          ),
                        );
                      },
                      loading: () => const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, trace) =>
                          Scaffold(body: Center(child: Text('Error: $e'))),
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.subtitle != null
              ? SizedBox(
                  height: 28,
                  width: double.infinity,
                  child: Text(
                    widget.subtitle!,
                    style: textTheme.h4.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
