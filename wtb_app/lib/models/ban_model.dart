import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class Ban {
  final int? id;
  final String name;
  final String district;
  final List<LatLng> coordinates;
  final String landmarkURL;

  Ban({
    this.id,
    required this.name,
    required this.district,
    required this.coordinates,
    required this.landmarkURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district': district,
      'coordinates': coordinates
          .map((coord) => "${coord.latitude},${coord.longitude}")
          .join('|'),
      'landmark_url': landmarkURL,
    };
  }

  factory Ban.fromJson(Map<String, dynamic> json) {
    List<LatLng> points = [];

    try {
      if (json['coordinates'] != null) {
        String coordStr = json['coordinates'].toString();

        // ONLY parse if it looks like our new format (contains '|')
        if (coordStr.contains('|')) {
          points = coordStr.split('|').map((coord) {
            final parts = coord.split(',');
            return LatLng(
              double.parse(parts[0].trim()),
              double.parse(parts[1].trim()),
            );
          }).toList();
        }
        // If it starts with '[', it's old bad data. We ignore it.
      }
    } catch (e) {
      debugPrint("Error parsing Ban ID ${json['id']}: $e");
      // If error, points remains []
    }

    return Ban(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      district: json['district'] ?? 'Unknown',
      coordinates: points,
      landmarkURL: json['landmark_url'] ?? '',
    );
  }
}
