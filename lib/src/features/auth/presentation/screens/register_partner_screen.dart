import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/admin/approval/data/repositories/request_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/partner/data/models/partner_model.dart';
import 'package:studall/src/features/partner/data/repositories/partner_firestore_repository.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

class RegisterPartnerScreen extends ConsumerStatefulWidget {
  const RegisterPartnerScreen({super.key});

  @override
  ConsumerState<RegisterPartnerScreen> createState() =>
      _RegisterPartnerScreenState();
}

class _RegisterPartnerScreenState extends ConsumerState<RegisterPartnerScreen> {
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateStoreName(String value) {
    if (value.trim().isEmpty) return 'กรุณากรอกชื่อร้านค้า';
    return null;
  }

  String? _validateDescription(String value) {
    if (value.trim().isEmpty) return 'กรุณากรอกรายละเอียด';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Text(
                      'ลงทะเบียนร้านค้าของคุณ',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.h3.copyWith(
                        color: colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'กรอกรายละเอียดร้านค้าเพื่อเริ่มต้นใช้งาน',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.muted.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShadInputFormField(
                      controller: _storeNameController,
                      label: const Text('ชื่อร้านค้า'),
                      placeholder: const Text('ชื่อร้านค้าของคุณ'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateStoreName,
                    ),
                    const SizedBox(height: 16),
                    ShadTextareaFormField(
                      controller: _descriptionController,
                      label: const Text('รายละเอียด'),
                      placeholder: const Text('รายละเอียดร้านค้าของคุณ'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateDescription,
                    ),
                    const SizedBox(height: 32),
                    ShadButton(
                      enabled: !_isSaving,
                      onPressed: () => _handleSaveStore(context),
                      size: ShadButtonSize.lg,
                      width: double.infinity,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('ลงทะเบียนร้านค้า'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSaveStore(BuildContext context) async {
    final storeName = _storeNameController.text.trim();
    final description = _descriptionController.text.trim();
    if (storeName.isEmpty || description.isEmpty) return;

    final authState = ref.read(authStateProvider);
    final userId = authState.value?.uid;
    if (userId == null) return;

    setState(() => _isSaving = true);

    try {
      final partner = PartnerModel(
        id: userId,
        name: storeName,
        description: description,
      );

      final partnerRepo = ref.read(partnerFirestoreRepositoryProvider);
      await partnerRepo.addPartner(partner);

      final userRepo = ref.read(userFirestoreRepositoryProvider);
      await userRepo.addUserRole(userId, Role.partner);
      await userRepo.updateUserLastActiveRole(userId, Role.partner);

      final request = RequestModel(
        type: RequestType.store,
        requestedUserId: userId,
      );
      final requestRepo = ref.read(requestFirestoreRepositoryProvider);
      await requestRepo.addRequest(request);

      if (context.mounted) context.go('/partner/home');
    } catch (e) {
      debugPrint('Caught an exception in _handleSaveStore: $e');
    }
  }

  CommonAppbar _buildAppBar(BuildContext context) {
    return CommonAppbar(
      leading: [
        ShadIconButton.ghost(
          decoration: ShadDecoration(shape: BoxShape.circle),
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
