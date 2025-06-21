import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_data.dart';

class ApiService {
  // Replace with your actual API endpoint
  final String baseUrl = 'https://your-backend-api.com/buildings';

  Future<List<BuildingData>> fetchBuildingsInRegion(LatLngBounds bounds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'minLat': bounds.southWest.latitude,
          'minLng': bounds.southWest.longitude,
          'maxLat': bounds.northEast.latitude,
          'maxLng': bounds.northEast.longitude,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BuildingData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load buildings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching buildings: $e');
      throw Exception('Failed to load buildings: $e');
    }
  }

  // For MVP testing with mock data when API is not ready
  Future<List<BuildingData>> fetchMockBuildingsInRegion(LatLngBounds bounds) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Create some mock buildings
    final center = LatLng(
      (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
      (bounds.southWest.longitude + bounds.northEast.longitude) / 2,
    );

    // Generate a few random buildings around the center
    List<BuildingData> mockBuildings = [];
    for (int i = 0; i < 5; i++) {
      // Create a simple rectangular building
      final offset = 0.001 * i;
      final points = [
        LatLng(center.latitude - offset, center.longitude - offset),
        LatLng(center.latitude - offset, center.longitude + offset),
        LatLng(center.latitude + offset, center.longitude + offset),
        LatLng(center.latitude + offset, center.longitude - offset),
        LatLng(center.latitude - offset, center.longitude - offset), // Close the polygon
      ];

      mockBuildings.add(
        BuildingData(
          id: 'mock-building-$i',
          polygonPoints: points,
          confidenceScore: 0.7 + (i * 0.05),
          plusCode: 'MOCK+CODE', area: 12,
        ),
      );
    }

    return mockBuildings;
  }
}