import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wtb_app/features/map/widgets/fullScreen.dart';
import 'package:wtb_app/models/ban_model.dart';

class WTBMapVIew extends StatelessWidget {
  final List<LatLng> currentPoints;
  final List<Ban> savedPolygons;
  final Function(LatLng) onMapTap;
  final VoidCallback? onUndo;
  final Function(Ban) onEdit;
  final Function(int) onDelete;
  final MapController mapController;
  final LatLng? userLocation;

  const WTBMapVIew({
    super.key,
    required this.currentPoints,
    required this.savedPolygons,
    required this.onMapTap,
    this.onUndo,
    required this.onEdit,
    required this.onDelete,
    required this.mapController,
    this.userLocation,
  });

  LatLng _getPolygonCenter(List<LatLng> points) {
    double latSum = 0;
    double lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  @override
  Widget build(BuildContext context) {
    final validBans = savedPolygons
        .where((ban) => ban.coordinates.length >= 3)
        .toList();
    List<Polygon> displayPolygons = validBans.map((ban) {
      return Polygon(
        points: ban.coordinates,
        // ignore: deprecated_member_use
        color: Colors.pinkAccent.withOpacity(
          0.3,
        ), // Green for conquered villages
        borderColor: Colors.deepOrange,
        borderStrokeWidth: 2,
        // ignore: deprecated_member_use
        isFilled: true,
      );
    }).toList();

    if (currentPoints.length > 2) {
      displayPolygons.add(
        Polygon(
          points: currentPoints,
          // ignore: deprecated_member_use
          color: Colors.orangeAccent.withOpacity(
            0.3,
          ), // Blue for current drawing
          borderColor: Colors.orangeAccent,
          borderStrokeWidth: 2,
          // ignore: deprecated_member_use
          isFilled: true,
        ),
      );
    }
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(18.0286, 102.6375),
            initialZoom: 14.0,
            onTap: (_, point) => onMapTap(point),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            PolygonLayer(polygons: displayPolygons),
            if (userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation!,
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow/pulse
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ignore: deprecated_member_use
                            color: Colors.orangeAccent.withOpacity(0.3),
                          ),
                        ),
                        // Inner solid dot
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            MarkerLayer(
              markers: currentPoints.map((point) {
                return Marker(
                  point: point,
                  width: 20,
                  height: 20,
                  child: GestureDetector(
                    onTap: () => onMapTap(point),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            MarkerLayer(
              markers: validBans.map((ban) {
                return Marker(
                  point: _getPolygonCenter(ban.coordinates),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showVillageDetails(context, ban),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                );
              }).toList(),
            ),
            // PolygonLayer(polygons: displayPolygons),
          ],
        ),
        if (currentPoints.isNotEmpty)
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: onUndo,
              child: const Icon(Icons.undo, color: Colors.blue),
            ),
          ),
      ],
    );
  }

  void _showVillageDetails(BuildContext context, Ban ban) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          ban.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  if (ban.landmarkURL.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Fullscreen(imageUrl: ban.landmarkURL),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: ban,
                  child: ban.landmarkURL.isNotEmpty
                      ? Image.network(
                          ban.landmarkURL,
                          fit: BoxFit.cover,
                          height: 200,

                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            double? value;
                            if (loadingProgress.expectedTotalBytes != null) {
                              value =
                                  loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!;
                            }
                            return Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          // ignore: avoid_types_as_parameter_names
                          errorBuilder: (context, error, StackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : Container(
                          height: 100,
                          color: Colors.grey[100],
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await _showDeleteConfirm(context);
              if (confirm) {
                Navigator.pop(context);
                onDelete(ban.id!);
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onEdit(ban);
            },
            child: const Text(
              "Edit",

              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future _showDeleteConfirm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Confirm Deletion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to delete this village?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
