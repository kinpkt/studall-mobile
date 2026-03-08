import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/app_list_tile.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/core/theme/theme_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/student/data/repositories/student_firestore_repository.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  Widget _buildProfileSettingSection(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    late List<Role> noRoles, roles;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              roles = user?.roles ?? [];
              noRoles = Role.values
                  .where((r) => (!roles.contains(r) && r != Role.admin))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  if (roles.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.muted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 16,
                        children: [
                          ...roles.map((Role role) {
                            final roleLabel = switch (role) {
                              Role.student => 'นักเรียน',
                              Role.partner => 'ร้านค้า',
                              Role.admin => 'ผู้ดูแลระบบ',
                            };
                            final roleIcon = switch (role) {
                              Role.student =>
                                PhosphorIconsRegular.graduationCap,
                              Role.partner => PhosphorIconsRegular.storefront,
                              Role.admin => PhosphorIconsRegular.pipeWrench,
                            };
                            return AppListTile(
                              padding: EdgeInsets.zero,
                              title: roleLabel,
                              titleStyle: textTheme.custom['medium']?.copyWith(
                                color: colorScheme.foreground,
                              ),
                              description: user!.email,
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  roleIcon,
                                  size: 24,
                                  color: colorScheme.foreground,
                                ),
                              ),
                              trailing: [
                                user.lastActiveRole == role
                                    ? Text(
                                        'ปัจจุบัน',
                                        style: textTheme.small.copyWith(
                                          color: colorScheme.custom['success'],
                                        ),
                                        maxLines: 1,
                                      )
                                    : GestureDetector(
                                        onTap: () =>
                                            _showSwitchRoleConfirmationDialog(
                                              context,
                                              user.id,
                                              role,
                                            ),
                                        child: Text(
                                          'สลับบทบาท',
                                          style: textTheme.small.copyWith(
                                            color: colorScheme.custom['info'],
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                colorScheme.custom['info'],
                                          ),
                                        ),
                                      ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  if (noRoles.isNotEmpty)
                    ...noRoles.map((Role role) {
                      final roleLabel = switch (role) {
                        Role.student => 'นักเรียน',
                        Role.partner => 'ร้านค้า',
                        Role.admin => 'ผู้ดูแลระบบ',
                      };
                      return ShadButton.ghost(
                        onPressed: () {
                          if (role == Role.student) {
                            context.push('/register-student');
                          } else if (role == Role.partner) {
                            context.push('/register-partner');
                          }
                        },
                        child: Text(
                          'เพิ่มบทบาท$roleLabel',
                          style: textTheme.custom['medium']?.copyWith(
                            color: colorScheme.custom['info'],
                          ),
                        ),
                      );
                    }),
                ],
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
          trailing: [
            Text(
              'แตะสองครั้ง',
              style: textTheme.muted.copyWith(
                color: colorScheme.mutedForeground.withValues(alpha: 0.5),
              ),
            ),
          ],
          onDoubleTap: () => ref.read(themeModeProvider.notifier).toggle(),
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

  Widget _buildStudentOnlySettingSection(BuildContext context, String id) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final studentSettingsAsync = ref.watch(studentSettingsProvider(id));

    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'นักเรียน',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
            ],
          ),
        ),
        studentSettingsAsync.when(
          data: (studentSettings) {
            final currentRadiusMeters = studentSettings?.radius ?? 2000.0;
            final displayRadiusKm = currentRadiusMeters / 1000;

            return AppListTile(
              title: 'รัศมีร้านใกล้ฉัน',
              titleStyle: textTheme.custom['medium']?.copyWith(
                color: colorScheme.foreground,
              ),
              description:
                  'รัศมีการค้นหาร้านใกล้ฉัน (${displayRadiusKm.toStringAsFixed(1)} km)',
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  PhosphorIconsRegular.ruler,
                  size: 24,
                  color: colorScheme.foreground,
                ),
              ),
              trailing: [
                Text(
                  'แก้ไข',
                  style: textTheme.muted.copyWith(
                    color: colorScheme.mutedForeground.withValues(alpha: 0.5),
                  ),
                ),
              ],
              onTap: () =>
                  _showRadiusSettingDialog(context, id, currentRadiusMeters),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Text('เกิดข้อผิดพลาด: $error'),
        ),
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
            onPressed: () async => await ref
                .read(authControllerProvider.notifier)
                .signOut(context),
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
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => ctx.pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton.destructive(
              onPressed: () async {
                await ref
                    .read(authControllerProvider.notifier)
                    .signOut(context);
                if (!ctx.mounted) return;
                ctx.pop();
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final isLoading = ref.watch(authControllerProvider).isLoading;
                  return isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('ออกจากระบบ');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSwitchRoleConfirmationDialog(
    BuildContext context,
    String id,
    Role role,
  ) {
    final roleLabel = switch (role) {
      Role.student => 'นักเรียน',
      Role.partner => 'ร้านค้า',
      Role.admin => 'ผู้ดูแลระบบ',
    };

    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text('ต้องการสลับบทบาทเป็น "$roleLabel" หรือไม่?'),
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => ctx.pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton(
              onPressed: () async {
                await ref
                    .read(userFirestoreRepositoryProvider)
                    .updateUserLastActiveRole(id, role);

                if (!ctx.mounted) return;
                // ctx.pop();

                final route = switch (role) {
                  Role.student => '/student/home',
                  Role.partner => '/partner/home',
                  Role.admin => '/admin/home',
                };

                if (!context.mounted) return;
                context.go(route);
              },
              child: const Text('สลับบทบาท'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRadiusSettingDialog(
    BuildContext context,
    String id,
    double currentRadiusMeters,
  ) {
    final double initialRadiusKm = currentRadiusMeters / 1000;
    final TextEditingController radiusController = TextEditingController(
      text: initialRadiusKm.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('ตั้งค่ารัศมีการค้นหา (กิโลเมตร)'),
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => ctx.pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton(
              onPressed: () async {
                final double? parsedRadiusKm = double.tryParse(
                  radiusController.text,
                );

                if (parsedRadiusKm != null && parsedRadiusKm > 0) {
                  final double newRadiusMeters = parsedRadiusKm * 1000;

                  await ref
                      .read(studentFirestoreRepositoryProvider)
                      .updateSearchRadius(id, newRadiusMeters);

                  ref.invalidate(studentSettingsProvider(id));
                }

                if (!ctx.mounted) return;
                ctx.pop();
              },
              child: const Text('บันทึก'),
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadInput(
                controller: radiusController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                placeholder: const Text('ระบุระยะทาง'),
                trailing: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('km'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSettingSection(context),
            _buildGeneralSettingSection(context),
            userProfile.when(
              data: (user) {
                final isStudent = user?.lastActiveRole == Role.student;

                if (isStudent)
                  return _buildStudentOnlySettingSection(context, user!.id);
                else
                  return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            _buildBottomActionSection(context),
          ],
        ),
      ),
    );
  }
}
