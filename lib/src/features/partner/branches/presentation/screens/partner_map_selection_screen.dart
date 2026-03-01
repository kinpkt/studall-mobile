import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PartnerMapSelectionScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const PartnerMapSelectionScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<PartnerMapSelectionScreen> createState() => _PartnerMapSelectionScreenState();
}

class _PartnerMapSelectionScreenState extends State<PartnerMapSelectionScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // Default to Rangsit, Pathum Thani if no initial location is provided
    _selectedLocation = widget.initialLocation ?? const LatLng(13.9883, 100.6171);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.of(context).pop(_selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกตำแหน่งที่ตั้ง', style: theme.textTheme.h2,),
        leading: ShadButton.ghost(
          leading: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation!,
              initialZoom: 15.0,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'ku.cs.studall',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'พิกัดที่เลือก:',
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedLocation != null
                        ? '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}'
                        : 'ยังไม่ได้เลือกตำแหน่ง',
                    style: ShadTheme.of(context).textTheme.muted,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ShadButton(
                      onPressed: _selectedLocation == null ? null : _confirmLocation,
                      child: const Text('ยืนยันตำแหน่ง'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}