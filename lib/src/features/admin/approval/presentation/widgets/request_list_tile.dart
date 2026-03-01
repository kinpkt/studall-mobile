import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/admin/approval/presentation/screens/admin_approval_screen.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import 'package:studall/src/features/partner/home/presentation/widgets/advertisement_banner.dart';

import '../../data/repositories/request_firestore_repository.dart';
import 'package:studall/src/features/partner/data/repositories/partner_firestore_repository.dart';

final partnerStoreNameProvider = StreamProvider.family<String, String>((ref, String userId) {
  final repository = ref.watch(partnerFirestoreRepositoryProvider);
  final stream = repository.getPartnerByUserId(userId);

  return stream.map((partner) => partner?.name ?? 'ไม่ทราบชื่อร้าน');
});

final singleAdvertisementProvider = StreamProvider.family<AdvertisementModel?, String>((ref, adId) {
  final repository = ref.watch(advertisementFirestoreRepositoryProvider);

  return repository.getAdvertisementFromId(adId);
});

class RequestListTile extends ConsumerWidget {
  final RequestModel request;
  const RequestListTile({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    Future<void> handleApprove() async {
      if (request.type == RequestType.advertise) {
        final ad = await ref.read(singleAdvertisementProvider(request.id).future);

        if (ad != null) {
          final updatedAd = ad.copyWith(isPublished: true);

          await ref.read(advertisementFirestoreRepositoryProvider).updateAdvertisement(updatedAd);
        }
      }

      await ref.read(requestFirestoreRepositoryProvider).updateRequest(
        request.id,
        RequestStatus.approved,
      );
    }

    Future<void> handleDecline() async {
      await ref.read(requestFirestoreRepositoryProvider).updateRequest(
        request.id,
        RequestStatus.declined,
      );
    }

    return Material(
      child: ListTile(
        leading: Icon(request.type == RequestType.advertise ? PhosphorIconsRegular.newspaper : PhosphorIconsRegular.storefront),
        title: Text(request.type.thaiType, style: theme.textTheme.list),
        subtitle: Consumer(
          builder: (context, ref, child) {
            final partnerAsync = ref.watch(partnerStoreNameProvider(request.requestedUserId ?? ''));

            return partnerAsync.when(
              loading: () => Text('กำลังโหลดชื่อร้าน...', style: theme.textTheme.muted),
              error: (err, stack) => Text('ส่งคำขอโดย ไม่ทราบชื่อร้าน', style: theme.textTheme.muted),
              data: (storeName) => Text('ส่งคำขอโดย $storeName', style: theme.textTheme.muted),
            );
          },
        ),
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

                        if (request.status == RequestStatus.pending)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShadButton.destructive(
                                child: Text('ปฏิเสธ'),
                                onPressed: () async {
                                  await handleDecline();
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: 16,),
                              ShadButton(
                                backgroundColor: theme.colorScheme.custom['green'],
                                child: Text('อนุมัติ'),
                                onPressed: () async {
                                  await handleApprove();
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                      ],
                    ),
                  )
                );
              },
              icon: const Icon(PhosphorIconsRegular.eye)
            ),
            if (request.status == RequestStatus.pending)
              IconButton(
                  onPressed: handleApprove,
                  icon: Icon(PhosphorIconsRegular.check, color: theme.colorScheme.custom['green'])
              ),
            if (request.status == RequestStatus.pending)
              IconButton(
                  onPressed: handleDecline,
                  icon: Icon(PhosphorIconsRegular.x, color: theme.colorScheme.destructive)
              ),
          ],
        )
      ),
    );
  }
}