import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/advertisement_banner.dart';

final advertisementProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAdvertisementsFromUserId(currentUser.uid);
});

final singleAdvertisementProvider = StreamProvider.family<AdvertisementModel?, String>((ref, adId) {
  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAdvertisementFromId(adId);
});

class PartnerRequestListTile extends ConsumerWidget {
  final RequestModel request;
  const PartnerRequestListTile({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    final formattedDate = DateFormat('d MMM yyyy เวลา HH:mm น.').format(request.createdAt);

    return Material(
      child: ListTile(
          leading: Icon(request.type == RequestType.advertise ? PhosphorIconsRegular.newspaper : PhosphorIconsRegular.storefront),
          title: Text(request.type.thaiType, style: theme.textTheme.list),
          subtitle: Text('ส่งคำขอเมื่อ $formattedDate', style: theme.textTheme.muted),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showShadDialog(
                    context: context,
                    builder: (context) => ShadDialog(
                      title: Text(request.type.thaiType, style: theme.textTheme.h3),
                      description: Text('สถานะ: ${request.status.thaiStatus}', style: theme.textTheme.p),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (request.type == RequestType.advertise)
                            Consumer(
                              builder: (context, ref, child) {
                                final adAsyncValue = ref.watch(singleAdvertisementProvider(request.id));

                                return adAsyncValue.when(
                                  loading: () => const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                  error: (error, stack) => Text(
                                    'เกิดข้อผิดพลาด: $error',
                                    style: theme.textTheme.p,
                                  ),
                                  data: (ad) {
                                    if (ad == null) {
                                      return const Text('ไม่พบข้อมูลโฆษณา');
                                    }

                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(child: AdvertisementBanner(ads: ad)),
                                          const SizedBox(height: 16),
                                          Text(ad.topic),
                                          const SizedBox(height: 8),
                                          Text(ad.description)
                                        ]
                                    );
                                  },
                                );
                              },
                            ),

                          if (request.status == RequestStatus.declined && request.reason != null) ...[
                            const SizedBox(height: 12),
                            Text('สาเหตุการปฏิเสธ: ${request.reason}', style: theme.textTheme.p),
                          ],
                        ],
                      ),
                    )
                  );
                },
                icon: const Icon(PhosphorIconsRegular.eye)
              ),
            ],
          )
      ),
    );
  }
}
