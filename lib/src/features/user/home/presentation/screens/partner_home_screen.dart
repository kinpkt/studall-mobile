import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

class PartnerHomeScreen extends StatelessWidget {
  const PartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final List<String> branches = [
      'คณะวิทยาศาสตร์ มก.',
      'คณะบริหารธุรกิจ มก.',
      'เซนทรัลลาดพร้าว',
      'สามย่านมิตรทาวน์',
      'MBK Center'
    ];

    final List<UserModel> staffs = [
      UserModel(id: 'somchai_t', email: 'somchai_t@gmail.com', username: 'somchai_t', fullName: 'สมชาย ตายทั้งเป็น'),
      UserModel(id: 'ehen123', email: 'ehen@gmail.com', username: 'ehen123', fullName: 'อีเห็น เป็นนางรำ'),
      UserModel(id: 'klangtam222', email: 'klangtam222@gmail.com', username: 'klangtam222', fullName: 'กลางธรรม ทำทำไม'),
    ];

    return Column(
      spacing: 16.0,
      children: [
        ShadCard(
          width: 480,
          title: Text('Starbucks', style: theme.textTheme.h2,),
          description: Text('Users From App: XX', style: theme.textTheme.h4),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวนสาขา: XX', style: theme.textTheme.p),
              Text('จำนวนพนักงาน: XX', style: theme.textTheme.p),
            ],
          ),
        ),
        Text(
          'Branches',
          style:theme.textTheme.h2,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: branches.map((branch) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ShadCard(
                  width: 240,
                  title: Text(branch, style: theme.textTheme.p),
                ),
              );
            }).toList(),
          ),
        ),
        Text(
          'Staffs',
          style:theme.textTheme.h2,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: staffs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(PhosphorIconsRegular.userCircle),
              title: Text(staffs[index].fullName, style: theme.textTheme.large),
              subtitle: Text('@${staffs[index].username}', style: theme.textTheme.p),
            );
          },
        )
      ],
    );
  }
}
