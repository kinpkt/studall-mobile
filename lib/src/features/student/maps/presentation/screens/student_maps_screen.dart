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
  final int radius = 2500;

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
        width: 100,
        height: 60,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            _showBranchDetails(context, branch);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                PhosphorIconsFill.mapPin,
                color: Colors.red,
                size: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(204),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${branch.partnerName} (${branch.name})',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
    );
  }

  void _showBranchDetails(BuildContext context, BranchModel branch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShadDialog(
          title: Text('${branch.partnerName}\n${branch.name}'),
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              Text(branch.partnerDescription),
              Text('สถานะร้าน: ${branch.status.thaiStatus}', style: TextStyle(color: branch.status.getColor(ShadTheme.of(context))),),
            ],
          ),
        );
      }
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
      final radiusAsync = ref.watch(studentRadiusProvider);

      return radiusAsync.when(
        data: (radius) {
          final nearbyBranches = ref.watch(
            nearbyBranchesProvider((center: position!, radius: radius.round()))
          );

          return Scaffold(
            appBar: AppBar(
              title: Text('แผนที่', style: theme.textTheme.h3),
            ),
            body: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: position!,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'ku.cs.studall',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: position!,
                          radius: radius,
                          useRadiusInMeter: true,
                          color: Colors.blue.withAlpha(64),
                          borderColor: Colors.blue,
                          borderStrokeWidth: 2.0,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: position!,
                          width: 100,
                          height: 60,
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                PhosphorIconsFill.user,
                                color: Colors.blue,
                                size: 30,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(204),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'คุณอยู่ที่นี่',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('Error loading radius: $err')),
        ),
      );
    }
    else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
