import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';

import '../../../../admin/approval/data/models/request_model.dart';

class AdvertisementBanner extends ConsumerWidget {
  final AdvertisementModel ads;
  final RequestStatus? status;
  final bool isClickable;
  final bool isDeletable;

  const AdvertisementBanner({
    super.key,
    required this.ads,
    this.status,
    this.isClickable = true,
    this.isDeletable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              actions: [
                if (isDeletable)
                  ShadButton.destructive(
                    onPressed: () {
                      final updatedAds = ads.copyWith(isPublished: false);

                      ref.watch(advertisementFirestoreRepositoryProvider).updateAdvertisement(updatedAds);

                      Navigator.pop(context);
                    },
                    child: const Text('นำโฆษณาออก'),
                  ),
                ShadButton.outline(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ปิด'),
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                ],
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