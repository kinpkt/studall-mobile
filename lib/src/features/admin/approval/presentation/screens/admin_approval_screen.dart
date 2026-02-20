import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

import '../../data/models/request_model.dart';
import '../widgets/request_list_tile.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Hardcoded datasource (RequestModel)
    final UserModel demoUser = UserModel(id: '1234', email: 'something', username: 'brain_cafe_sciku', fullName: 'Brain Cafe');
    final List<RequestModel> requests = [
      RequestModel(type: RequestType.store, requestedUser: demoUser),
      RequestModel(type: RequestType.advertise, requestedUser: demoUser)
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('คำขอจากผู้ใช้', style: theme.textTheme.h2,),
          const SizedBox(height: 16,),
          Text('คำขอที่รอดำเนินการ', style: theme.textTheme.h3,),
          Column(
            children:
              (requests.length == 0 ? [Text('ขณะนี้ยังไม่มีคำขอที่รอดำเนินการ', style: theme.textTheme.h4,)] : requests.map((request) => RequestListTile(request: request)).toList())
          ),
        ],
      ),
    );
  }
}
