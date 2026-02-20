import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
                  MarkerLayer(markers: [
                    Marker(point: position!, child: Icon(PhosphorIconsFill.mapPin))
                  ])
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
