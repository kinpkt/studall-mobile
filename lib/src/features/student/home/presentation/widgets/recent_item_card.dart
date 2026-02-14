import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';

import '../../data/models/item_model.dart';

class RecentItemCard extends StatelessWidget {
  final ItemModel item;
  const RecentItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      width: 240,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
      title: Text(item.name, style: theme.textTheme.h4,),
      description: Text(item.courseId),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dateTimeToThaiString(item.date, withYear: false, acronymMonth: true, withTime: item.type == ItemType.assignment), style: theme.textTheme.p,),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.custom['blue'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              PhosphorIconsRegular.clipboardText,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
