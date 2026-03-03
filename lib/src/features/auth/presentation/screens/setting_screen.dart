import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/app_list_tile.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/data/models/role.dart';

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
    final userProfile = ref.watch(userProfileProvider);
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
          Container(
            decoration: BoxDecoration(
              color: colorScheme.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: userProfile.when(
              data: (user) => AppListTile(
                title: (user?.displayName == null || user?.displayName == '')
                    ? 'ไม่พบชื่อ'
                    : user!.displayName,
                titleStyle: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
                description: user?.email ?? 'ไม่พบอีเมล',
                leading: ShadAvatar(
                  user?.photoUrl == '' ? null : user?.photoUrl,
                  size: const Size.square(40),
                  backgroundColor: colorScheme.background,
                  placeholder: Icon(
                    PhosphorIconsRegular.user,
                    color: colorScheme.foreground,
                  ),
                ),
                trailing: [
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
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
          userProfile.when(
            data: (user) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.muted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  spacing: 16,
                  children: [
                    userProfile.when(
                      data: (user) => AppListTile(
                        padding: EdgeInsets.zero,
                        title: "นักเรียน",
                        titleStyle: textTheme.custom['medium']?.copyWith(
                          color: colorScheme.foreground,
                        ),
                        description: user?.email ?? 'ไม่พบอีเมล',
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            PhosphorIconsRegular.graduationCap,
                            size: 24,
                            color: colorScheme.foreground,
                          ),
                        ),
                        trailing: [
                          (user?.lastActiveRole == Role.student)
                              ? Text(
                                  'ปัจจุบัน',
                                  style: textTheme.small.copyWith(
                                    color: colorScheme.custom['success'],
                                  ),
                                  maxLines: 1,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    // ref.read(userProvider.notifier).switchRole(Role.partner);
                                  },
                                  child: Text(
                                    'สลับบทบาท',
                                    style: textTheme.small.copyWith(
                                      color: colorScheme.custom['info'],
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          colorScheme.custom['info'],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    userProfile.when(
                      data: (user) => AppListTile(
                        padding: EdgeInsets.zero,
                        title: "ร้านค้า",
                        titleStyle: textTheme.custom['medium']?.copyWith(
                          color: colorScheme.foreground,
                        ),
                        description: user?.email ?? 'ไม่พบอีเมล',
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            PhosphorIconsRegular.storefront,
                            size: 24,
                            color: colorScheme.foreground,
                          ),
                        ),
                        trailing: [
                          (user?.lastActiveRole == Role.partner)
                              ? Text(
                                  'ปัจจุบัน',
                                  style: textTheme.small.copyWith(
                                    color: colorScheme.custom['success'],
                                  ),
                                  maxLines: 1,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    // ref.read(userProvider.notifier).switchRole(Role.partner);
                                  },
                                  child: Text(
                                    'สลับบทบาท',
                                    style: textTheme.small.copyWith(
                                      color: colorScheme.custom['info'],
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          colorScheme.custom['info'],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    userProfile.when(
                      data: (user) => AppListTile(
                        padding: EdgeInsets.zero,
                        title: "ผู้ดูแลระบบ",
                        titleStyle: textTheme.custom['medium']?.copyWith(
                          color: colorScheme.foreground,
                        ),
                        description: user?.email ?? 'ไม่พบอีเมล',
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            PhosphorIconsRegular.pipeWrench,
                            size: 24,
                            color: colorScheme.foreground,
                          ),
                        ),
                        trailing: [
                          (user?.lastActiveRole == Role.admin)
                              ? Text(
                                  'ปัจจุบัน',
                                  style: textTheme.small.copyWith(
                                    color: colorScheme.custom['success'],
                                  ),
                                  maxLines: 1,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    // ref.read(userProvider.notifier).switchRole(Role.partner);
                                  },
                                  child: Text(
                                    'สลับบทบาท',
                                    style: textTheme.small.copyWith(
                                      color: colorScheme.custom['info'],
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          colorScheme.custom['info'],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final themeModeLabel = switch (themeMode) {
      ThemeMode.light => 'สว่าง',
      ThemeMode.dark => 'มืด',
      ThemeMode.system => 'อัตโนมัติ',
    };
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
        AppListTile(
          title: 'ธีมโหมด',
          titleStyle: textTheme.custom['medium']?.copyWith(
            color: colorScheme.foreground,
          ),
          description: themeModeLabel,
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              PhosphorIconsRegular.circleHalfTilt,
              size: 24,
              color: colorScheme.foreground,
            ),
          ),
          onTap: () => ref.read(themeModeProvider.notifier).toggle(),
        ),
        // AppListTile(
        //   title: 'ภาษา',
        //   titleStyle: textTheme.custom['medium']?.copyWith(
        //     color: colorScheme.foreground,
        //   ),
        //   description: 'ไทย',
        //   leading: SizedBox(
        //     width: 40,
        //     height: 40,
        //     child: Icon(
        //       PhosphorIconsRegular.globe,
        //       size: 24,
        //       color: colorScheme.foreground,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 16),
      ],
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
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShadDialog.alert(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
              ),
              actions: [
                ShadButton.secondary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('ยกเลิก'),
                ),
                ShadButton.destructive(
                  onPressed: () {
                    ref.read(authFirebaseRepositoryProvider).signOut();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('ออกจากระบบ'),
                ),
              ],
            ),
          );
        },
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
