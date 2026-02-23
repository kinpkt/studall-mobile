import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../partner/branches/data/models/branch_model.dart';

class StudentMapsScreen extends StatefulWidget {
  const StudentMapsScreen({super.key});

  @override
  State<StudentMapsScreen> createState() => _StudentMapsScreenState();
}

class _StudentMapsScreenState extends State<StudentMapsScreen> {
  LatLng? position;
  String error = '';

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

    final List<BranchModel> branches = [
      BranchModel(name: 'ร้านปริ้นเอกสารใต้ตึกฟิสิกส์', location: GeoPoint(13.845989047424123, 100.57071887786084)),
      BranchModel(name: 'Natang Cafe & Listening Bar', location: GeoPoint(13.838248432568644, 100.582614486534))
    ];

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Error: $error', style: theme.textTheme.p),
        ),
      );
    }

    if (position != null) {
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
                  MarkerLayer(markers: branches.map((branch) => _buildMarker(branch)).toList())
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
