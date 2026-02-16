import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';


class RequestListTile extends StatelessWidget {
  final RequestModel request;
  const RequestListTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: Icon(request.type == RequestType.advertise ? PhosphorIconsRegular.newspaper : PhosphorIconsRegular.storefront),
        title: Text(request.thaiTypeEnumValue, style: theme.textTheme.list,),
        subtitle: Text('ส่งคำขอโดย ${request.requestedUser.fullName ?? '@${request.requestedUser.username}'}', style: theme.textTheme.muted),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.eye)),
            IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.check, color: theme.colorScheme.custom['green'],)),
            IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.x, color: theme.colorScheme.destructive)),
          ],
        )
      ),
    );
  }
}
