import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';


class UserListTile extends StatelessWidget {
  final UserModel user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: ShadAvatar(user.photoUrl, placeholder: Icon(PhosphorIconsFill.userCircle),),
        title: Text(user.fullName ?? '', style: theme.textTheme.list,),
        subtitle: Text('@${user.username}', style: theme.textTheme.muted),
        trailing: IconButton(onPressed: () {}, icon: Icon(PhosphorIconsRegular.pencilSimple)),
      ),
    );
  }
}
