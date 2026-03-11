import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/admin/approval/data/repositories/request_firestore_repository.dart';
import 'package:studall/src/features/partner/requests/presentation/widgets/partner_request_list_tile.dart';

import '../../../../admin/approval/data/models/request_model.dart';
import '../../../../admin/approval/presentation/widgets/request_list_tile.dart';

final requestsProvider = StreamProvider<List<RequestModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getRequestsByUserId(currentUser.uid);
});

class PartnerRequestsScreen extends ConsumerWidget {
  const PartnerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final requestsAsyncValue = ref.watch(requestsProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('คำขอของฉัน', style: theme.textTheme.h2,),
          const SizedBox(height: 16,),
          Text('คำขอที่รอดำเนินการ', style: theme.textTheme.h3,),
          const SizedBox(height: 16,),
          requestsAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p,),
            data: (requests) {
              final pendingRequests = requests.where((request) => request.status == RequestStatus.pending).toList();

              if (pendingRequests.isEmpty) {
                return Text('ไม่มีคำขอในขณะนี้', style: theme.textTheme.p,);
              }

              return Column(
                children: pendingRequests.map((request) => PartnerRequestListTile(request: request)).toList(),
              );
            },
          ),
          const SizedBox(height: 16,),
          Text('คำขอที่ถูกปฏิเสธ', style: theme.textTheme.h3,),
          const SizedBox(height: 16,),
          requestsAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p,),
            data: (requests) {
              final declinedRequests = requests.where((request) => request.status == RequestStatus.declined).toList();

              if (declinedRequests.isEmpty) {
                return Text('ไม่มีคำขอในขณะนี้', style: theme.textTheme.p,);
              }

              return Column(
                children: declinedRequests.map((request) => PartnerRequestListTile(request: request)).toList(),
              );
            },
          ),
          const SizedBox(height: 16,),
          Text('คำขอที่ได้รับการอนุมัติ', style: theme.textTheme.h3,),
          const SizedBox(height: 16,),
          requestsAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('เกิดข้อผิดพลาด: $error', style: theme.textTheme.p,),
            data: (requests) {
              final approvedRequests = requests.where((request) => request.status == RequestStatus.approved).toList();

              if (approvedRequests.isEmpty)
                return Text('ไม่มีคำขอในขณะนี้', style: theme.textTheme.p,);

              return Column(
                children: approvedRequests.map((request) => PartnerRequestListTile(request: request)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
