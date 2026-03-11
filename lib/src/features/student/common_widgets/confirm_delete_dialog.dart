import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// แสดง dialog ยืนยันการลบทรัพยากร (note, task, utility ฯลฯ)
/// [parentContext] คือ context ของ dialog หลัก (ถ้ามี)
/// [onConfirm] จะถูกเรียกเมื่อกดยืนยัน — ให้ทำการลบข้อมูลภายใน callback นี้
Future<void> showConfirmDeleteDialog(
  BuildContext parentContext, {
  String title = 'ยืนยันการลบ',
  String description =
      'คุณแน่ใจหรือไม่ว่าต้องการลบรายการนี้? การกระทำนี้ไม่สามารถย้อนกลับได้',
  String confirmText = 'ยืนยัน',
  String cancelText = 'ยกเลิก',
  required Future<void> Function() onConfirm,
  VoidCallback? onSuccess,
  VoidCallback? onError,
}) {
  return showDialog(
    context: parentContext,
    builder: (confirmContext) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog(
          title: Text(title),
          description: Text(description),
          actions: [
            ShadButton.secondary(
              child: Text(cancelText),
              onPressed: () => Navigator.of(confirmContext).pop(),
            ),
            ShadButton.destructive(
              child: Text(confirmText),
              onPressed: () async {
                try {
                  await onConfirm();

                  if (!confirmContext.mounted) return;
                  Navigator.of(confirmContext).pop();

                  onSuccess?.call();
                } catch (e) {
                  if (!confirmContext.mounted) return;
                  Navigator.of(confirmContext).pop();

                  onError?.call();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
