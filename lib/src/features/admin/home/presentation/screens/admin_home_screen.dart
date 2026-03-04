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
    final advertisementRequestCountAsync = ref.watch(
      advertisementRequestCountProvider,
    );
    final partnerRequestCountAsync = ref.watch(partnerRequestCountProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          ShadCard(
            title: Text('ยอดผู้ใช้งานในระบบ', style: theme.textTheme.h2),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AsyncCountText(
                  asyncValue: studentCountAsync,
                  label: 'บัญชีนักเรียนนักศึกษา',
                ),
                _AsyncCountText(
                  asyncValue: partnerCountAsync,
                  label: 'บัญชีร้านค้า',
                ),
              ],
            ),
          ),
          ShadCard(
            title: Text('คำขอเพิ่มโฆษณา', style: theme.textTheme.h2),
            footer: _AsyncCountText(
              asyncValue: advertisementRequestCountAsync,
              label: 'รอการตรวจสอบ',
            ),
          ),
          ShadCard(
            title: Text('คำขอเปิดร้านค้า', style: theme.textTheme.h2),
            footer: _AsyncCountText(
              asyncValue: partnerRequestCountAsync,
              label: 'รอการตรวจสอบ',
            ),
          ),
        ],
      ),
    );
  }
}

class _AsyncCountText extends StatelessWidget {
  const _AsyncCountText({required this.asyncValue, required this.label});

  final AsyncValue<int> asyncValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return asyncValue.when(
      data: (count) => Text('$label: $count', style: theme.textTheme.p),
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => Text('เกิดข้อผิดพลาด', style: theme.textTheme.p),
    );
  }
}
