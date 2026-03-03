import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';

import '../widgets/user_list_tile.dart';

final usersProvider = FutureProvider((ref) async {
  final repository = ref.watch(userFirestoreRepositoryProvider);
  return repository.getAllUsers();
});

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchBarController = TextEditingController();
  final popoverController = ShadPopoverController();

  Map<String, String> roleLabels = {
    'all': 'ทั้งหมด',
    'student': 'นักเรียน',
    'partner': 'ร้านค้า',
    'admin': 'แอดมิน',
  };

  String _searchQuery = '';
  String _selectedRole = 'all';

  @override
  void initState() {
    super.initState();
    _searchBarController.addListener(() {
      setState(() {
        _searchQuery = _searchBarController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    popoverController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final usersAsyncValue = ref.watch(usersProvider);

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _buildSearchBar(context),
          if (_selectedRole != 'all')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'กรองโดย: ${roleLabels[_selectedRole]}',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
          Expanded(
            child: usersAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p),
              data: (users) {
                final filteredUsers = users.where((user) {
                  final displayName = user.displayName.toLowerCase();
                  final matchesSearch = displayName.contains(_searchQuery);

                  final matchesRole =
                      _selectedRole == 'all' ||
                      user.lastActiveRole?.name == _selectedRole.toLowerCase();

                  return matchesSearch && matchesRole;
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Text(
                    'ไม่พบผู้ใช้ที่ตรงกับการค้นหา',
                    style: theme.textTheme.p,
                  );
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return UserListTile(user: filteredUsers[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ShadInput(
        controller: _searchBarController,
        decoration: const ShadDecoration(
          secondaryFocusedBorder: ShadBorder.none,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        placeholder: const Text('ค้นหาผู้ใช้งาน'),
        leading: Icon(PhosphorIconsRegular.magnifyingGlass, size: 20),
        trailing: MenuAnchor(
          reservedPadding: const EdgeInsets.all(16),
          menuChildren: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Text(
                'ตัวกรองโดยบทบาท',
                style: textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
            ...roleLabels.entries.map((entry) {
              final value = entry.key;
              final label = entry.value;
              return MenuItemButton(
                leadingIcon: _selectedRole == value
                    ? Icon(PhosphorIconsRegular.check, size: 16)
                    : const SizedBox(width: 16),
                onPressed: () => setState(() => _selectedRole = value),
                child: Text(label, style: theme.textTheme.p),
              );
            }),
          ],
          builder: (context, controller, child) => GestureDetector(
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            child: Icon(PhosphorIconsRegular.sliders, size: 20),
          ),
        ),
      ),
    );
  }
}
