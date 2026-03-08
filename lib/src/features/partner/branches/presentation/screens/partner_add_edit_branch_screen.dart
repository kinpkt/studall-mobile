import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:latlong2/latlong.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';
import 'package:studall/src/features/partner/branches/data/repositories/branch_firestore_repository.dart';
import 'package:studall/src/features/partner/branches/presentation/screens/partner_map_selection_screen.dart';

class PartnerAddEditBranchScreen extends ConsumerStatefulWidget {
  final BranchModel? branch;
  const PartnerAddEditBranchScreen({super.key, this.branch});

  @override
  ConsumerState<PartnerAddEditBranchScreen> createState() => _PartnerAddEditBranchScreenState();
}

class _PartnerAddEditBranchScreenState extends ConsumerState<PartnerAddEditBranchScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  LatLng? _selectedLocation;
  BranchStatus? _selectedStatus;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.branch != null) {
      final branch = widget.branch!;

      _nameController.text = branch.name;
      _selectedLocation = branch.leafletCoordinate;
      _locationController.text = '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}';

      _selectedStatus = branch.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _pickLocation() async {
    final selectedLatLng = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => PartnerMapSelectionScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (selectedLatLng != null) {
      setState(() {
        _selectedLocation = selectedLatLng;
        _locationController.text = '${selectedLatLng.latitude.toStringAsFixed(6)}, ${selectedLatLng.longitude.toStringAsFixed(6)}';
      });
    }
  }

  void _submit() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          title: Text('เกิดข้อผิดพลาด'),
          description: Text('กรุณาลงชื่อเข้าใช้'),
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false))
      return;

    if (_selectedLocation == null)
      return;

    setState(() => _isLoading = true);

    try {
      final partner = await FirebaseFirestore.instance.collection('partners').doc(currentUser.uid).get();
      final partnerName = partner.data()?['name'] as String;
      final partnerDescription = partner.data()?['description'] as String;
      final partnerIsPermitted = partner.data()?['isPermitted'] as bool;

      final BranchModel newBranch = BranchModel(
        id: widget.branch?.id,
        partnerName: partnerName,
        partnerDescription: partnerDescription,
        partnerIsPermitted: partnerIsPermitted,
        name: _nameController.text,
        location: GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
        status: _selectedStatus!,
      );

      if (widget.branch != null) {
        await ref.read(branchFirestoreRepositoryProvider).updateBranch(
          currentUser.uid,
          newBranch,
        );
      }
      else {
        await ref.read(branchFirestoreRepositoryProvider).addBranch(
          currentUser.uid,
          newBranch,
        );
      }

      if (!mounted)
        return;

      ShadToaster.of(context).show(
        ShadToast(
          title: Text('สำเร็จ'),
          description: Text(widget.branch != null ? 'อัปเดตสาขาเรียบร้อยแล้ว' : 'เพิ่มสาขาใหม่เรียบร้อยแล้ว'),
        ),
      );

      Navigator.of(context).pop();
    }
    catch (e) {
      if (!mounted) return;

      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('เกิดข้อผิดพลาด'),
          description: Text(e.toString()),
        ),
      );
    }
    finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสาขาใหม่', style: theme.textTheme.h2,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ShadForm(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  'รายละเอียดสาขา',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
                ShadInputFormField(
                  id: 'branch_name',
                  label: const Text('ชื่อสาขา'),
                  placeholder: const Text('กรอกชื่อสาขา...'),
                  controller: _nameController,
                  validator: (v) {
                    if (v.isEmpty) {
                      return 'กรุณากรอกชื่อสาขา';
                    }
                    return null;
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickLocation,
                      child: ShadInputFormField(
                        id: 'location',
                        label: const Text('ตำแหน่งที่ตั้ง (ละติจูด, ลองจิจูด)'),
                        placeholder: const Text('ยังไม่ได้เลือกตำแหน่ง'),
                        controller: _locationController,
                        readOnly: true,
                        validator: (v) {
                          if (v.isEmpty || _selectedLocation == null) {
                            return 'กรุณาระบุตำแหน่งที่ตั้ง';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShadButton.secondary(
                      onPressed: _pickLocation,
                      child: const Text('เลือกบนแผนที่'),
                    ),
                  ],
                ),
                ShadSelectFormField<BranchStatus>(
                  id: 'status',
                  label: const Text('สถานะสาขา'),
                  placeholder: const Text('เลือกสถานะ...'),
                  initialValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  options: BranchStatus.values.map(
                    (status) => ShadOption(
                      value: status,
                      child: Text(status.thaiStatus),
                    ),
                  ).toList(),
                  selectedOptionBuilder: (context, value) {
                    return Text(value.thaiStatus);
                  },
                  validator: (v) {
                    if (v == null) {
                      return 'กรุณาเลือกสถานะ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ShadButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                        : const Text('บันทึกข้อมูล'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}