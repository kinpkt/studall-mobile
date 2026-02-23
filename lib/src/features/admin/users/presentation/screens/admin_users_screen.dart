import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';

import '../widgets/user_list_tile.dart';

final usersProvider = FutureProvider((ref) async {
  final repository = ref.watch(userFirestoreRepositoryProvider);
  return repository.getAllUsers();
});

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final usersAsyncValue = ref.watch(usersProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ผู้ใช้งานในระบบ', style: theme.textTheme.h2,),
          const SizedBox(height: 16,),
          usersAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p,),
            data: (users) {
              if (users.isEmpty) {
                return Text('ไม่มีคำขอในขณะนี้', style: theme.textTheme.p,);
              }

              return Column(
                children: users.map((user) => UserListTile(user: user)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
