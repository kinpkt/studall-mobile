import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

import '../widgets/user_list_tile.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Hardcoded datasource (UserModels)
    final List<UserModel> users = [
      UserModel(id: '1234', email: 'kinphakinthorn@gmail.com', username: 'kinpkt', fullName: 'Phakinthorn Pronmongkolsuk', photoUrl: 'https://avatars.worldcubeassociation.org/5p76i1eotij12e300704ed1l6s40'),
      UserModel(id: '1235', email: 'athiruj.k@gmail.com', username: 'athi', fullName: 'Athiruj Kaewseesuk'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ผู้ใช้งานในระบบ', style: theme.textTheme.h2,),
          const SizedBox(height: 16,),
          Column(
            children: users.map((user) => UserListTile(user: user)).toList(),
          ),
        ],
      ),
    );
  }
}
