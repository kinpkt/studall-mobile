import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';

import '../../../../admin/approval/data/models/request_model.dart';

class AdvertisementBanner extends StatelessWidget {
  final AdvertisementModel ads;
  final RequestStatus? status;
  final bool isClickable;

  const AdvertisementBanner({
    super.key,
    required this.ads,
    this.status,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final bannerImage = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        ads.imageUrl,
        fit: BoxFit.cover,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: isClickable
          ? GestureDetector(
        onTap: () {
          showShadDialog(
            context: context,
            builder: (context) => ShadDialog(
              title: Text(ads.topic, style: theme.textTheme.h3),
              description: Text(ads.description, style: theme.textTheme.p),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ads.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (status != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'สถานะคำขอ: ',
                            style: theme.textTheme.large,
                            children: [
                              TextSpan(
                                text: status!.thaiStatus,
                                style: TextStyle(
                                  color: status?.getColor(theme),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ]
              ),
            ),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: bannerImage,
        ),
      )
          : bannerImage,
    );
  }
}