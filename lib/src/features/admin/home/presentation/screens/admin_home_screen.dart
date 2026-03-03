import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/admin/home/presentation/providers/admin_home_provider.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final studentCountAsync = ref.watch(studentCountProvider);
    final partnerCountAsync = ref.watch(partnerCountProvider);
    final advertisementRequestCountAsync = ref.watch(advertisementRequestCountProivder);
    final partnerRequestCountAsync = ref.watch(partnerRequestCountProivder);

    return Column(
      spacing: 16.0,
      children: [
        ShadCard(
          width: 480,
          title: Text('ยอดผู้ใช้งานในระบบ', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              studentCountAsync.when(
                data: (count) => Text('บัญชีนักเรียนนักศึกษา: $count', style: theme.textTheme.p),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('เกิดข้อผิดพลาด', style: theme.textTheme.p),
              ),
              partnerCountAsync.when(
                data: (count) => Text('บัญชีร้านค้า: $count', style: theme.textTheme.p),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('เกิดข้อผิดพลาด', style: theme.textTheme.p),
              ),
            ],
          ),
        ),
        ShadCard(
          width: 400,
          title: Text('คำขอเพิ่มโฆษณา', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              advertisementRequestCountAsync.when(
                data: (count) => Text('รอการตรวจสอบ: $count', style: theme.textTheme.p),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('เกิดข้อผิดพลาด', style: theme.textTheme.p),
              ),
            ],
          ),
        ),
        ShadCard(
          width: 400,
          title: Text('คำขอเปิดร้านค้า', style: theme.textTheme.h2),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              partnerRequestCountAsync.when(
                data: (count) => Text('รอการตรวจสอบ: $count', style: theme.textTheme.p),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('เกิดข้อผิดพลาด', style: theme.textTheme.p),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
