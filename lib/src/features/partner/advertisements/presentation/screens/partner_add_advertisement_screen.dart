import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/core/services/r2_service.dart';
import 'package:studall/src/features/partner/advertisements/data/models/advertisement_model.dart';
import 'package:studall/src/features/partner/advertisements/data/repositories/advertisement_firestore_repository.dart';

import '../../../../admin/approval/data/models/request_model.dart';
import '../../../../admin/approval/data/repositories/request_firestore_repository.dart';

class PartnerAddAdvertisementScreen extends ConsumerStatefulWidget {
  const PartnerAddAdvertisementScreen({super.key});

  @override
  ConsumerState<PartnerAddAdvertisementScreen> createState() => _PartnerAddAdvertisementScreenState();
}

class _PartnerAddAdvertisementScreenState extends ConsumerState<PartnerAddAdvertisementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<String?> _uploadImageToStorage(String userId) async {
    if (_selectedImage == null)
      return null;

    try {
      final r2Service = R2Service();

      final String fileName = 'advertisements/$userId/${DateTime.now().millisecondsSinceEpoch}.png';
      final String imageUrl = await r2Service.uploadFile(_selectedImage!, fileName);

      return imageUrl;
    }
    catch (e) {
      debugPrint('Error uploading image to R2: $e');
      rethrow;
    }
  }

  Future<void> _submit() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null)
      return;

    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกภาพประกอบโฆษณา')),
        );

        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final topic = _topicController.text;
        final description = _descriptionController.text;

        final String? imageUrl = await _uploadImageToStorage(currentUser.uid);

        if (imageUrl == null)
          throw Exception('Failed to get image URL from R2');

        debugPrint('Submitting Advertisement:');
        debugPrint('Topic: $topic');
        debugPrint('Description: $description');
        debugPrint('Image URL: $imageUrl');

        final newAds = AdvertisementModel(
          userId: currentUser.uid,
          topic: topic,
          description: description,
          imageUrl: imageUrl
        );

        ref.read(advertisementFirestoreRepositoryProvider).addAdvertisement(newAds);

        final RequestModel newRequest = RequestModel(
          id: newAds.id,
          type: RequestType.advertise,
          requestedUserId: currentUser.uid
        );

        await ref.read(requestFirestoreRepositoryProvider).addRequest(newRequest);

        if (!mounted)
          return;

        ShadToaster.of(context).show(
          const ShadToast(
            description: Text('ส่งคำขอเผยแพร่โฆษณาสำเร็จ กรุณารอผู้ดูแลระบบอนุมัติ'),
          ),
        );

        _topicController.clear();
        _descriptionController.clear();

        Navigator.pop(context);
      }
      catch (e) {
        if (!mounted) return;
        ShadToaster.of(context).show(
          ShadToast(
            description: Text('เกิดข้อผิดพลาด: $e'),
          ),
        );
      }
      finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: CommonAppbar(
        title: 'เพิ่มโฆษณาใหม่',
        leading: [
          ShadIconButton.ghost(
            decoration: ShadDecoration(shape: BoxShape.circle),
            icon: const Icon(PhosphorIconsRegular.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ห้วข้อโฆษณา', style: theme.textTheme.p,),
              const SizedBox(height: 8),
              ShadInputFormField(
                controller: _topicController,
                placeholder: const Text('กรอกหัวข้อโฆษณาที่นี่'),
                validator: (v) {
                  if (v.isEmpty) {
                    return 'กรุณากรอกหัวข้อโฆษณา';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('ภาพประกอบโฆษณา', style: theme.textTheme.p,),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_search, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('อัปโหลดรูปภาพที่นี่', style: TextStyle(color: Colors.grey, fontFamily: theme.textTheme.family)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('รายละเอียดโฆษณา', style: theme.textTheme.p,),
              const SizedBox(height: 8),
              ShadInputFormField(
                controller: _descriptionController,
                placeholder: const Text('กรอกรายละเอียดโฆษณาที่นี่'),
                maxLines: 5,
                validator: (v) {
                  if (v.isEmpty)
                    return 'กรุณากรอกรายละเอียดโฆษณา';

                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                    : const Text('ส่งคำขอเพิ่มโฆษณา'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}