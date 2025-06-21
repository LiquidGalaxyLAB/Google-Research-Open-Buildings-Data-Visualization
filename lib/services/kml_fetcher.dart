import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KMLData {
  static const String baseUrl = 'http://192.168.1.14:8080'; // Replace with your actual API URL

  // Main function to fetch KML data
  static Future<String?> fetchBuildingsKML({
    required BuildContext context,
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
    String format = 'kml',
  }) async {
    // Show loading overlay
    _showLoadingOverlay(context);

    try {
      // Construct the API URL
      final uri = Uri.parse('$baseUrl/fetch-buildings').replace(
        queryParameters: {
          'min_lng': minLng.toString(),
          'min_lat': minLat.toString(),
          'max_lng': maxLng.toString(),
          'max_lat': maxLat.toString(),
          'format': format,
        },
      );

      print('Fetching from: $uri');

      // Make HTTP request
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      // Hide loading
      if (context.mounted) Navigator.of(context).pop();

      if (response.statusCode == 200) {
        print('✅ KML fetched: ${response.body.length} chars');

        return response.body;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        return null;
      }

    } catch (e) {
      // Hide loading if error occurs
      if (context.mounted) Navigator.of(context).pop();
      print('❌ Error: $e');
      return null;
    }
  }

  // Loading overlay
  static void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Fetching Building Data...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}