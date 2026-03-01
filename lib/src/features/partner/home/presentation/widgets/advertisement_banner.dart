import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';

class AdvertisementBanner extends StatelessWidget {
  final AdvertisementModel ads;
  final bool isClickable;

  const AdvertisementBanner({
    super.key,
    required this.ads,
    this.isClickable = true, // Defaults to true for the home screen
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Extracted the image widget to avoid writing it twice
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
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // Use contain here so the full image scales nicely inside the dialog
                  child: Image.network(
                    ads.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
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