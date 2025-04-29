import 'package:latlong2/latlong.dart';

class BuildingData {
  final String id;
  final List<LatLng> polygonPoints;
  final double confidenceScore;
  final String? plusCode;

  BuildingData({
    required this.id,
    required this.polygonPoints,
    required this.confidenceScore,
    this.plusCode,
  });

  // Factory to create from API JSON response
  factory BuildingData.fromJson(Map<String, dynamic> json) {
    // Example parsing - adjust according to your actual API response structure
    List<dynamic> coordinates = json['geometry']['coordinates'][0];
    List<LatLng> points = coordinates.map<LatLng>((coord) {
      return LatLng(coord[1], coord[0]); // Note the order: [lng, lat] -> LatLng(lat, lng)
    }).toList();

    return BuildingData(
      id: json['id'] ?? 'unknown',
      polygonPoints: points,
      confidenceScore: json['properties']['confidence'] ?? 0.0,
      plusCode: json['properties']['plus_code'],
    );
  }
}