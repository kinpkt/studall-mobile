import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';

class BannedProfileScreen extends ConsumerWidget {
  const BannedProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final authState = ref.watch(authStateProvider);

    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ผู้ใช้', style: textTheme.h4),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: profileState.when(
        data: (profile) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: profile?.photoUrl != null
                      ? NetworkImage(profile!.photoUrl!)
                      : null,
                  child: profile?.photoUrl == null
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  profile?.displayName ?? 'ไม่ทราบชื่อ',
                  style: textTheme.custom['medium'],
                ),
                const SizedBox(height: 8),
                Text(profile?.email ?? '', style: textTheme.custom['medium']),
                const SizedBox(height: 24),
                Text(
                  'บัญชีของคุณถูกระงับการใช้งาน',
                  style: textTheme.h4.copyWith(color: colorScheme.destructive),
                ),
                const SizedBox(height: 32),
                ShadButton.destructive(
                  onPressed: () async {
                    await ref
                        .read(authControllerProvider.notifier)
                        .signOut(context);
                  },
                  child: const Text('ออกจากระบบ'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('เกิดข้อผิดพลาด: $err')),
      ),
    );
  }
}
