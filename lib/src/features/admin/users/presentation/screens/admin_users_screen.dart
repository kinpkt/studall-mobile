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
  String _searchQuery = '';
  String _selectedRole = 'All';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final usersAsyncValue = ref.watch(usersProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ผู้ใช้งานในระบบ', style: theme.textTheme.h2,),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ShadInput(
                      placeholder: Text('กรอกชื่อผู้ใช้...'),
                      controller: _searchBarController,
                    )
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(PhosphorIconsRegular.funnel),
                    tooltip: 'กรองผู้ใช้งาน',
                    onSelected: (String newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      CheckedPopupMenuItem<String>(
                        value: 'All',
                        checked: _selectedRole == 'All',
                        child: Text('ทั้งหมด', style: theme.textTheme.p),
                      ),
                      CheckedPopupMenuItem<String>(
                        value: 'Admin',
                        checked: _selectedRole == 'Admin',
                        child: Text('แอดมิน', style: theme.textTheme.p),
                      ),
                      CheckedPopupMenuItem<String>(
                        value: 'Student',
                        checked: _selectedRole == 'Student',
                        child: Text('นักเรียน', style: theme.textTheme.p),
                      ),
                      CheckedPopupMenuItem<String>(
                        value: 'Partner',
                        checked: _selectedRole == 'Partner',
                        child: Text('ร้านค้า', style: theme.textTheme.p),
                      ),
                    ],
                  )
                ],
              ),
              if (_selectedRole != 'All')
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'กรองโดย: $_selectedRole',
                    style: theme.textTheme.small.copyWith(color: theme.colorScheme.mutedForeground),
                  ),
                ),
              const SizedBox(height: 8,),
              Expanded(
                child: usersAsyncValue.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p,),
                  data: (users) {
                    final filteredUsers = users.where((user) {
                      final displayName = user.displayName.toLowerCase();
                      final matchesSearch = displayName.contains(_searchQuery);

                      final matchesRole = _selectedRole == 'All' || user.lastActiveRole?.name == _selectedRole.toLowerCase();

                      return matchesSearch && matchesRole;
                    }).toList();

                    if (filteredUsers.isEmpty) {
                      return Text('ไม่พบผู้ใช้ที่ตรงกับการค้นหา', style: theme.textTheme.p,);
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
        ),
      ),
    );
  }
}