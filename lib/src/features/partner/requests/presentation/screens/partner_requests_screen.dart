import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/admin/approval/data/repositories/request_firestore_repository.dart';
import 'package:studall/src/features/partner/requests/presentation/widgets/partner_request_list_tile.dart';

import '../../../../admin/approval/data/models/request_model.dart';

final requestsProvider = StreamProvider<List<RequestModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return Stream.value([]);

  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getRequestsByUserId(currentUser.uid);
});

class PartnerRequestsScreen extends ConsumerStatefulWidget {
  const PartnerRequestsScreen({super.key});

  @override
  ConsumerState<PartnerRequestsScreen> createState() =>
      _PartnerRequestsScreenState();
}

class _PartnerRequestsScreenState extends ConsumerState<PartnerRequestsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    final requestsAsyncValue = ref.watch(requestsProvider);

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'รอดำเนินการ'),
              Tab(text: 'ถูกปฏิเสธ'),
              Tab(text: 'อนุมัติแล้ว'),
            ],
          ),
          Expanded(
            child: requestsAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p),
              ),
              data: (requests) {
                final pending = requests
                    .where((r) => r.status == RequestStatus.pending)
                    .toList();
                final declined = requests
                    .where((r) => r.status == RequestStatus.declined)
                    .toList();
                final approved = requests
                    .where((r) => r.status == RequestStatus.approved)
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRequestList(
                      context,
                      pending,
                      'ไม่มีคำขอที่รอดำเนินการ',
                    ),
                    _buildRequestList(
                      context,
                      declined,
                      'ไม่มีคำขอที่ถูกปฏิเสธ',
                    ),
                    _buildRequestList(
                      context,
                      approved,
                      'ไม่มีคำขอที่ได้รับการอนุมัติ',
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

  Widget _buildRequestList(
    BuildContext context,
    List<RequestModel> requests,
    String emptyMessage,
  ) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (requests.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage,
            style: textTheme.p.copyWith(color: colorScheme.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return PartnerRequestListTile(request: requests[index]);
      },
    );
  }
}
