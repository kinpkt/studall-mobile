import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
      UserModel(uid: 'somchai_t', email: 'somchai_t@gmail.com', username: 'somchai_t'),
      UserModel(uid: 'ehen123', email: 'ehen@gmail.com', username: 'ehen123'),
      UserModel(uid: 'klangtam222', email: 'klangtam222@gmail.com', username: 'klangtam222'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        spacing: 16.0,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            'สาขาของร้าน',
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
          Text('โฆษณาของร้าน', style: theme.textTheme.h2),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/placeholder_ads.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        ]
      )
    );
  }
}
