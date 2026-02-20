import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/presentation/widgets/branch_details_card.dart';

class PartnerBranchesScreen extends StatelessWidget {
  const PartnerBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    final List<BranchModel> branches = [
      BranchModel(name: 'คณะวิทยาศาสตร์ มก.', location: GeoPoint(13.845972337420381, 100.57242158520883)),
      BranchModel(name: 'คณะบริหารธุรกิจ มก.', location: GeoPoint(13.844453881287203, 100.56890334596429), status: BranchStatus.moderate),
      BranchModel(name: 'เซนทรัลลาดพร้าว', location: GeoPoint(13.816635870512702, 100.56143745548962), status: BranchStatus.busy),
      BranchModel(name: 'สามย่านมิตรทาวน์', location: GeoPoint(13.734207667051445, 100.5280987336719), status: BranchStatus.busy),
      BranchModel(name: 'MBK Center', location: GeoPoint(13.745623748717762, 100.53053071550337)),
    ];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('สาขาทั้งหมด', style: theme.textTheme.h2,),
          SizedBox(height: 16,),
          Column(
            spacing: 12,
            children: branches.map((branch) => BranchDetailsCard(branch: branch)).toList(),
          )
        ],
      ),
    );
  }
}
