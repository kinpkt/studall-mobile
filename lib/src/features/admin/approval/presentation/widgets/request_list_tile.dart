import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/admin/approval/presentation/screens/admin_approval_screen.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

import '../../data/repositories/request_firestore_repository.dart';


class RequestListTile extends ConsumerWidget {
  final RequestModel request;
  const RequestListTile({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: Icon(request.type == RequestType.advertise ? PhosphorIconsRegular.newspaper : PhosphorIconsRegular.storefront),
        title: Text(request.thaiTypeEnumValue, style: theme.textTheme.list,),
        subtitle: Text('ส่งคำขอโดย ${request.requestedUserId ?? '@${request.requestedUserId}'}', style: theme.textTheme.muted),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.eye)),
            if (request.status == RequestStatus.pending)
              IconButton(
                onPressed: () async {
                  await ref.read(requestFirestoreRepositoryProvider).updateRequest(
                    request.id,
                    RequestStatus.approved,
                  );
                  ref.invalidate(requestsProvider);
                },
                icon: Icon(PhosphorIconsRegular.check, color: theme.colorScheme.custom['green'],)
              ),
            if (request.status == RequestStatus.pending)
              IconButton(
                onPressed: () async {
                  await ref.read(requestFirestoreRepositoryProvider).updateRequest(
                    request.id,
                    RequestStatus.declined,
                  );
                  ref.invalidate(requestsProvider);
                },
                icon: Icon(PhosphorIconsRegular.x, color: theme.colorScheme.destructive)
              ),
          ],
        )
      ),
    );
  }
}
