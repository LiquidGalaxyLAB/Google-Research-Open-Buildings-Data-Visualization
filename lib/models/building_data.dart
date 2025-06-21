import 'package:latlong2/latlong.dart';
import 'dart:math';

class BuildingData {
  final String id;
  final List<LatLng> polygonPoints;
  final double confidenceScore;
  final String? plusCode;
  final double area;

  BuildingData({
    required this.id,
    required this.polygonPoints,
    required this.confidenceScore,
    this.plusCode,
    required this.area,
  });

  // Factory to create from API JSON response
  factory BuildingData.fromJson(Map<String, dynamic> json) {
    // Example parsing - adjust according to your actual API response structure
    List<dynamic> coordinates = json['geometry']['coordinates'][0];
    List<LatLng> points = coordinates.map<LatLng>((coord) {
      return LatLng(coord[1], coord[0]); // Note the order: [lng, lat] -> LatLng(lat, lng)
    }).toList();

    // Calculate area using Shoelace formula
    double calculatedArea = _calculatePolygonArea(points);

    return BuildingData(
      id: json['id'] ?? 'unknown',
      polygonPoints: points,
      confidenceScore: json['properties']['confidence'] ?? 0.0,
      plusCode: json['properties']['plus_code'],
      area: calculatedArea,
    );
  }

  // Helper method to calculate polygon area
  static double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    int n = points.length;

    // Shoelace formula
    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }

    area = area.abs() / 2.0;

    // Convert from degrees to approximate square meters
    // This is a rough approximation - for more accuracy, use proper geodesic calculations
    const double degreeToMeter = 111320; // approximate meters per degree at equator
    area = area * degreeToMeter * degreeToMeter;

    return area;
  }

  // Optional: Add a method to get formatted area string
  String get formattedArea {
    if (area < 1000) {
      return '${area.toStringAsFixed(0)} m²';
    } else {
      return '${(area / 1000).toStringAsFixed(1)} km²';
    }
  }

  // Optional: Add a method to get confidence percentage
  String get confidencePercentage {
    return '${(confidenceScore * 100).toStringAsFixed(0)}%';
  }
}