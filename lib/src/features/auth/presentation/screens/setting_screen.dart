import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildProfileSettingSection(context),
          _buildGeneralSettingSection(context),
          _buildBottomActionSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSettingSection(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // final shadows = theme.shadows;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'บัญชีของฉัน',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.muted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: user.when(
                data: (user) {
                  return Row(
                    children: [
                      ShadAvatar(
                        user?.photoUrl,
                        size: const Size.square(40),
                        backgroundColor: colorScheme.muted,
                        placeholder: Text(
                          'SA',
                          style: textTheme.muted.copyWith(
                            color: colorScheme.foreground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (user?.username == null || user?.username == '')
                                  ? 'ไม่พบชื่อ'
                                  : user!.username,
                              style: textTheme.custom['medium']?.copyWith(
                                color: colorScheme.foreground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user?.email ?? 'ไม่พบอีเมล',
                              style: textTheme.muted.copyWith(
                                color: colorScheme.mutedForeground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              PhosphorIconsRegular.pencilSimpleLine,
                              size: 24,
                              color: colorScheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                error: (e, trace) =>
                    Scaffold(body: Center(child: Text('Error: $e'))),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'บทบาท',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              spacing: 16,
              children: [
                user.when(
                  data: (user) {
                    return Row(
                      children: [
                        ShadAvatar(
                          user?.photoUrl,
                          size: const Size.square(40),
                          backgroundColor: colorScheme.muted,
                          placeholder: Text(
                            'SA',
                            style: textTheme.muted.copyWith(
                              color: colorScheme.foreground,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (user?.username == null || user?.username == '')
                                    ? 'ไม่พบชื่อ'
                                    : user!.username,
                                style: textTheme.custom['medium']?.copyWith(
                                  color: colorScheme.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user?.email ?? 'ไม่พบอีเมล',
                                style: textTheme.muted.copyWith(
                                  color: colorScheme.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                
                        const SizedBox(width: 16),
                
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 8,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                PhosphorIconsRegular.arrowsClockwise,
                                size: 24,
                                color: colorScheme.mutedForeground,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                PhosphorIconsRegular.gear,
                                size: 24,
                                color: colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, trace) =>
                      Scaffold(body: Center(child: Text('Error: $e'))),
                ),
              
                user.when(
                  data: (user) {
                    return Row(
                      children: [
                        ShadAvatar(
                          user?.photoUrl,
                          size: const Size.square(40),
                          backgroundColor: colorScheme.muted,
                          placeholder: Text(
                            'SA',
                            style: textTheme.muted.copyWith(
                              color: colorScheme.foreground,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (user?.username == null || user?.username == '')
                                    ? 'ไม่พบชื่อ'
                                    : user!.username,
                                style: textTheme.custom['medium']?.copyWith(
                                  color: colorScheme.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user?.email ?? 'ไม่พบอีเมล',
                                style: textTheme.muted.copyWith(
                                  color: colorScheme.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                
                        const SizedBox(width: 16),
                
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 8,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                PhosphorIconsRegular.arrowsClockwise,
                                size: 24,
                                color: colorScheme.mutedForeground,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                PhosphorIconsRegular.gear,
                                size: 24,
                                color: colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, trace) =>
                      Scaffold(body: Center(child: Text('Error: $e'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ทั่วไป',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
            ],
          ),
        ),
        _listTile(
          context,
          icon: PhosphorIconsRegular.circleHalfTilt,
          title: 'ธีมโหมด',
          label: 'สว่าง',
        ),
        _listTile(
          context,
          icon: PhosphorIconsRegular.globe,
          title: 'ภาษา',
          label: 'ไทย',
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _listTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? label,
    VoidCallback? onTap,
  }) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, size: 24, color: colorScheme.foreground),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (label != null)
                    Text(
                      label,
                      style: textTheme.muted.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShadButton.ghost(
            onPressed: () => _showLogOutConfirmationDialog(context),
            child: Text(
              'ออกจากระบบ',
              style: textTheme.custom['medium']?.copyWith(
                color: colorScheme.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton.destructive(
              onPressed: () {
                ref.read(authFirebaseRepositoryProvider).signOut();
                Navigator.of(context).pop();
              },
              child: const Text('ออกจากระบบ'),
            ),
          ],
        ),
      ),
    );
  }

  // void _showAccountBottomSheet(BuildContext context) {
  //   final user = ref.watch(userProfileProvider);
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (ctx) => SafeArea(
  //       child: Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(PhosphorIconsRegular.gear),
  //               title: const Text('แก้ไขโปรไฟล์'),
  //               onTap: () {
  //                 Navigator.of(ctx).pop();
  //               },
  //             ),
  //             user.when(
  //               data: (user) {
  //                 if (user?.roles.length == 1) {
  //                   if (user!.roles.contains(Role.student)) {
  //                     return ListTile(
  //                       leading: const Icon(PhosphorIconsRegular.storefront),
  //                       title: const Text('สร้างบัญชีร้านค้า'),
  //                       onTap: () {
  //                         Navigator.of(ctx).pop();
  //                       },
  //                     );
  //                   } else if (user.roles.contains(Role.partner)) {
  //                     return ListTile(
  //                       leading: const Icon(PhosphorIconsRegular.graduationCap),
  //                       title: const Text('สร้างบัญชีนักเรียน'),
  //                       onTap: () {
  //                         Navigator.of(ctx).pop();
  //                       },
  //                     );
  //                   } else {
  //                     return const SizedBox();
  //                   }
  //                 } else if (user?.lastActiveRole == Role.student) {
  //                   return ListTile(
  //                     leading: const Icon(PhosphorIconsRegular.storefront),
  //                     title: const Text('สลับบัญชีร้านค้า'),
  //                     onTap: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                   );
  //                 } else if (user?.lastActiveRole == Role.partner) {
  //                   return ListTile(
  //                     leading: const Icon(PhosphorIconsRegular.graduationCap),
  //                     title: const Text('สลับบัญชีนักเรียน'),
  //                     onTap: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                   );
  //                 } else {
  //                   return const SizedBox();
  //                 }
  //               },
  //               loading: () => const SizedBox(),
  //               error: (e, trace) => const SizedBox(),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CommonAppbar(
      title: 'ตั้งค่า',
      leading: [
        ShadIconButton.ghost(
          decoration: ShadDecoration(shape: BoxShape.circle),
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
