import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_data.dart';

class ApiService {
  // Use your actual Flask API URL
  final String baseUrl = 'http://10.136.176.167:8080';

  Future<List<BuildingData>> fetchBuildingsInRegion(LatLngBounds bounds) async {
    try {
      // Construct the API URL - request JSON format for easier parsing
      final uri = Uri.parse('$baseUrl/fetch-buildings').replace(
        queryParameters: {
          'min_lng': bounds.southWest.longitude.toString(),
          'min_lat': bounds.southWest.latitude.toString(),
          'max_lng': bounds.northEast.longitude.toString(),
          'max_lat': bounds.northEast.latitude.toString(),
          'format': 'json', // Your API returns GeoJSON when format=json
        },
      );

      print('Fetching buildings from: $uri');

      // Make HTTP request with timeout
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        print('✅ Buildings data fetched: ${response.body.length} chars');

        // Check if response is empty or null
        if (response.body.isEmpty || response.body.trim() == '') {
          print('⚠️ Empty response from API');
          return [];
        }

        try {
          final dynamic data = jsonDecode(response.body);

          // Handle null data
          if (data == null) {
            print('⚠️ Null data from API');
            return [];
          }

          // Your API returns GeoJSON FeatureCollection format
          if (data is Map<String, dynamic>) {
            final String? type = data['type'];

            if (type == 'FeatureCollection') {
              final List<dynamic>? features = data['features'];
              if (features == null || features.isEmpty) {
                print('⚠️ No buildings found in this region');
                return [];
              }

              // Convert GeoJSON features to BuildingData
              return _parseGeoJSONFeatures(features);
            }
          }

          print('⚠️ Unexpected response format: ${data.runtimeType}');
          return [];

        } catch (parseError) {
          print('❌ JSON parsing error: $parseError');
          return [];
        }

      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        return [];
      }

    } catch (e) {
      print('❌ Error fetching buildings: $e');
      return []; // Return empty list on any error
    }
  }

  // Parse GeoJSON features from your Earth Engine API
  List<BuildingData> _parseGeoJSONFeatures(List<dynamic> features) {
    List<BuildingData> buildings = [];

    try {
      for (int i = 0; i < features.length; i++) {
        final feature = features[i];
        if (feature is! Map<String, dynamic>) continue;

        // Extract geometry and properties
        final Map<String, dynamic>? geometry = feature['geometry'];
        final Map<String, dynamic>? properties = feature['properties'];

        if (geometry == null) continue;

        // Extract confidence score (defaults to 0.5 if not available)
        double confidence = 0.5;
        if (properties != null && properties['confidence'] != null) {
          confidence = (properties['confidence'] as num).toDouble();
        }

        // Parse polygon coordinates
        List<LatLng>? polygonPoints = _extractPolygonCoordinates(geometry);
        if (polygonPoints == null || polygonPoints.isEmpty) continue;

        // Calculate area (rough estimation)
        double area = _calculatePolygonArea(polygonPoints);

        // Create BuildingData object
        buildings.add(BuildingData(
          id: 'building_$i',
          polygonPoints: polygonPoints,
          confidenceScore: confidence,
          area: area,
          plusCode: '', // Not available in your API
        ));
      }

      print('✅ Parsed ${buildings.length} buildings from GeoJSON');
      return buildings;

    } catch (e) {
      print('❌ Error parsing GeoJSON features: $e');
      return [];
    }
  }

  // Extract polygon coordinates from GeoJSON geometry
  List<LatLng>? _extractPolygonCoordinates(Map<String, dynamic> geometry) {
    try {
      final String? type = geometry['type'];
      final dynamic coordinates = geometry['coordinates'];

      if (coordinates == null) return null;

      List<LatLng> points = [];

      if (type == 'Polygon') {
        // Polygon format: [[[lng, lat], [lng, lat], ...]]
        if (coordinates is List && coordinates.isNotEmpty) {
          final outerRing = coordinates[0]; // Get outer ring
          if (outerRing is List) {
            for (final coord in outerRing) {
              if (coord is List && coord.length >= 2) {
                final lng = (coord[0] as num).toDouble();
                final lat = (coord[1] as num).toDouble();
                points.add(LatLng(lat, lng));
              }
            }
          }
        }
      } else if (type == 'MultiPolygon') {
        // MultiPolygon format: [[[[lng, lat], [lng, lat], ...]], ...]
        if (coordinates is List && coordinates.isNotEmpty) {
          final firstPolygon = coordinates[0]; // Get first polygon
          if (firstPolygon is List && firstPolygon.isNotEmpty) {
            final outerRing = firstPolygon[0]; // Get outer ring
            if (outerRing is List) {
              for (final coord in outerRing) {
                if (coord is List && coord.length >= 2) {
                  final lng = (coord[0] as num).toDouble();
                  final lat = (coord[1] as num).toDouble();
                  points.add(LatLng(lat, lng));
                }
              }
            }
          }
        }
      }

      return points.isNotEmpty ? points : null;

    } catch (e) {
      print('❌ Error extracting coordinates: $e');
      return null;
    }
  }

  // Calculate rough polygon area in square meters
  double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    try {
      // Simple area calculation using shoelace formula
      // This is approximate and assumes small polygons
      double area = 0.0;
      int n = points.length;

      for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        area += points[i].longitude * points[j].latitude;
        area -= points[j].longitude * points[i].latitude;
      }

      area = (area.abs() / 2.0);

      // Convert to approximate square meters (very rough estimation)
      // This is not accurate for large areas, but works for building footprints
      const double degToMeter = 111320; // rough conversion at equator
      area *= degToMeter * degToMeter;

      return area;

    } catch (e) {
      print('❌ Error calculating area: $e');
      return 100.0; // Default area
    }
  }
}