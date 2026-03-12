import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:go_router/go_router.dart';
import 'package:studall/src/features/partner/common_widgets/branch_list_tile.dart';

import '../providers/partner_branches_provider.dart';

class PartnerBranchesScreen extends ConsumerStatefulWidget {
  const PartnerBranchesScreen({super.key});

  @override
  ConsumerState<PartnerBranchesScreen> createState() =>
      _PartnerBranchesScreenState();
}

class _PartnerBranchesScreenState extends ConsumerState<PartnerBranchesScreen> {
  String _searchQuery = '';
  BranchStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    final branchesAsync = ref.watch(partnerBranchesProvider);

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          _buildSearchBar(context),
          if (_selectedStatus != null) _buildActiveFilterChip(context),
          Expanded(
            child: branchesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('เกิดข้อผิดพลาด: $err', style: theme.textTheme.p),
              ),
              data: (branches) {
                final filtered = branches.where((branch) {
                  final matchesSearch =
                      _searchQuery.isEmpty ||
                      branch.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                  final matchesStatus =
                      _selectedStatus == null ||
                      branch.status == _selectedStatus;
                  return matchesSearch && matchesStatus;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          branches.isEmpty
                              ? 'ยังไม่มีสาขา'
                              : 'ไม่พบสาขาที่ค้นหา',
                          style: theme.textTheme.p.copyWith(
                            color: colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'สาขาทั้งหมด',
                            style: theme.textTheme.custom['medium']?.copyWith(
                              color: colorScheme.foreground,
                            ),
                          ),
                          Text(
                            '${filtered.length}',
                            style: theme.textTheme.custom['medium']?.copyWith(
                              color: colorScheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...filtered.map(
                      (branch) => BranchListTile(
                        branch: branch,
                        onTap: () {
                          context.push('/partner/add-branch', extra: branch);
                        },
                      ),
                    ),
                  ],
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ShadInput(
        decoration: const ShadDecoration(
          secondaryFocusedBorder: ShadBorder.none,
        ),
        placeholder: const Text('ค้นหาสาขา'),
        onChanged: (value) => setState(() => _searchQuery = value),
        leading: Icon(PhosphorIconsRegular.magnifyingGlass, size: 20),
        trailing: MenuAnchor(
          menuChildren: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'กรองโดยสถานะ',
                style: textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
            MenuItemButton(
              leadingIcon: _selectedStatus == null
                  ? Icon(PhosphorIconsRegular.check, size: 16)
                  : const SizedBox(width: 16),
              onPressed: () => setState(() => _selectedStatus = null),
              child: Text('ทั้งหมด', style: theme.textTheme.p),
            ),
            ...BranchStatus.values.map((status) {
              return MenuItemButton(
                leadingIcon: _selectedStatus == status
                    ? Icon(PhosphorIconsRegular.check, size: 16)
                    : const SizedBox(width: 16),
                onPressed: () => setState(() => _selectedStatus = status),
                child: Text(status.thaiStatus, style: theme.textTheme.p),
              );
            }),
          ],
          builder: (context, controller, child) => GestureDetector(
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            child: Icon(
              PhosphorIconsRegular.sliders,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(BuildContext context) {
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = null),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Row(
          children: [
            Flexible(
              child: Text(
                'กรองโดย: ${_selectedStatus?.thaiStatus ?? ''}',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'ล้างตัวกรอง',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.custom['info'],
                  decoration: TextDecoration.underline,
                  decorationColor: theme.colorScheme.custom['info']!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
