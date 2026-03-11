import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/partner/branches/data/models/branch_model.dart';

class BranchCardMinimal extends StatelessWidget {
  final BranchModel branch;
  const BranchCardMinimal({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ShadDialog(
              title: Text(branch.name),
              // description: const Text('รายละเอียดสาขา'),
              actions: [
                ShadButton.outline(
                  child: const Text('ปิด'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('ที่ตั้ง:', style: theme.textTheme.large),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: branch.leafletCoordinate,
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'ku.cs.studall',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: branch.leafletCoordinate,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: ShadCard(
          width: 240,
          title: Text(branch.name, style: theme.textTheme.p),
        ),
      ),
    );
  }
}
