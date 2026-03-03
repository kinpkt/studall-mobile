import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/maps/presentation/providers/student_maps_provider.dart';

import '../../../../partner/branches/data/models/branch_model.dart';

class StudentMapsScreen extends ConsumerStatefulWidget {
  const StudentMapsScreen({super.key});

  @override
  ConsumerState<StudentMapsScreen> createState() => _StudentMapsScreenState();
}

class _StudentMapsScreenState extends ConsumerState<StudentMapsScreen> {
  LatLng? position;
  String error = '';
  final int radius = 10000;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          error = 'Location service disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          error = 'Permission denied forever';
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          )
      );

      setState(() {
        position = LatLng(pos.latitude, pos.longitude);
        error = '';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Marker _buildMarker(BranchModel branch) {
    return Marker(
      point: branch.leafletCoordinate,
      child: GestureDetector(
        onTap: () {
          _showBranchDetails(context, branch);
        },
        child: Icon(PhosphorIconsFill.mapPin),
      )
    );
  }

  void _showBranchDetails(BuildContext context, BranchModel branch) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Branch Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              // Replace these with your actual BranchModel properties
              Text('Name: ${branch.name}'),
              Text('Status: ${branch.status}'),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Error: $error', style: theme.textTheme.p),
        ),
      );
    }

    if (position != null) {
      final nearbyBranches = ref.watch(nearbyBranchesProvider((center: position!, radius: radius)));

      return Scaffold(
          appBar: AppBar(
            title: Text('แผนที่', style: theme.textTheme.h1),
          ),
          body: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: position!,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'ku.cs.studall',
                  ),
                  nearbyBranches.when(
                    data: (branches) => MarkerLayer(
                        markers: branches.map((branch) => _buildMarker(branch)).toList()
                    ),
                    loading: () => const Center(
                        child: CircularProgressIndicator()
                    ),
                    error: (err, stack) => Center(
                        child: Text('Failed to load map data: $err')
                    ),
                  ),
                ],
              ),
            ],
          )
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
