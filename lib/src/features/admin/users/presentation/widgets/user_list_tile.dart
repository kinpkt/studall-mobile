import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/admin/users/presentation/screens/admin_users_screen.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';


class UserListTile extends ConsumerWidget {
  final UserModel user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: ShadAvatar(user.photoUrl, placeholder: Icon(PhosphorIconsFill.userCircle),),
        title: Text(user.displayName == '' || user.displayName == null ? user.email : user.displayName, style: theme.textTheme.list,),
        subtitle: Text('สถานะบัญชี: ${user.isBanned ? 'ถูกระงับ' : 'ใช้งานได้'}',
          style: TextStyle(
            color: user.isBanned ? theme.colorScheme.destructive : theme.colorScheme.custom['green'],
            fontFamily: theme.textTheme.family
          )
        ),
        trailing: IconButton(
          onPressed: () {
            bool currentBanStatus = user.isBanned;

            showShadDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                      return ShadDialog(
                        title: const Text('จัดการสิทธิ์ผู้ใช้งาน'),
                        description: Text('คุณกำลังแก้ไขข้อมูลของ ${user.displayName}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ShadSelect<bool>(
                            placeholder: const Text('เลือกสถานะการแบน'),
                            initialValue: currentBanStatus,
                            options: [
                              ShadOption<bool>(value: true, child: Text('แบน')),
                              ShadOption<bool>(value: false, child: Text('ใช้งานได้')),
                            ],
                            selectedOptionBuilder: (context, value) => Text(value ? 'แบน' : 'ใช้งานได้'),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  currentBanStatus = value;
                                });
                              }
                            },
                          ),
                        ),
                        actions: [
                          ShadButton.outline(
                            child: const Text('ยกเลิก'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ShadButton(
                            child: const Text('บันทึกการเปลี่ยนแปลง'),
                            onPressed: () async {
                              try {
                                await ref
                                    .read(userFirestoreRepositoryProvider)
                                    .updateUserBanStatus(
                                  user.id,
                                  currentBanStatus,
                                );

                                ref.invalidate(usersProvider);

                                if (context.mounted) {
                                  Navigator.of(context).pop();

                                  ShadToaster.of(context).show(
                                    ShadToast(
                                      title: const Text('อัปเดตสำเร็จ'),
                                      description: Text('แก้ไขสถานะของ ${user
                                          .displayName} เรียบร้อยแล้ว'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();

                                  ShadToaster.of(context).show(
                                    ShadToast.destructive(
                                      title: const Text('เกิดข้อผิดพลาด'),
                                      description: Text(
                                          'ไม่สามารถอัปเดตข้อมูลได้: $e'),
                                    ),
                                  );
                                }
                              }
                            }
                          ),
                        ],
                      );
                    }
                );
              }
            );
          },
          icon: Icon(PhosphorIconsRegular.gavel)),
      ),
    );
  }
}
