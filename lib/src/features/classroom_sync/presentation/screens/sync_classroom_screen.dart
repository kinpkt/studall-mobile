import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/features/classroom_sync/presentation/screens/course_selection_screen.dart';

class SyncClassroomScreen extends StatelessWidget {
  const SyncClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 392),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      Text(
                        'เชื่อมต่อกับ Classroom',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.h3.copyWith(
                          color: colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ซิงค์รายวิชาและการบ้านทั้งหมดมาแสดงในแอป',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SvgPicture.asset(
                          'assets/logos/Classroom.svg',
                          height: 96,
                          width: 96,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  ShadButton(
                    child: const Text('เชื่อมต่อเลย'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CourseSelectionScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShadButton.secondary(
                    child: const Text('เพิ่มวิชาเรียนด้วยตัวเอง'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CommonAppbar _buildAppBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonAppbar(
      leading: [
        GestureDetector(
          child: Row(
            children: [
              Icon(
                size: 24.0,
                PhosphorIconsRegular.arrowLeft,
                color: colorScheme.foreground,
              ),
              const SizedBox(width: 8),
              Text('ย้อนกลับ', style: theme.textTheme.p),
            ],
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
      actions: [
        GestureDetector(
          child: Row(
            children: [
              Text('ข้ามไปก่อน', style: theme.textTheme.p),
              const SizedBox(width: 8),
              Icon(
                size: 24.0,
                PhosphorIconsRegular.caretDoubleRight,
                color: colorScheme.foreground,
              ),
            ],
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
