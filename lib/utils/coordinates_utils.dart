import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class CoordinateUtils {
  // Convert LatLngBounds to GEE rectangle format [minLng, minLat, maxLng, maxLat]
  static List<double> boundsToGeeRectangle(LatLngBounds bounds) {
    return [
      bounds.southWest.longitude,
      bounds.southWest.latitude,
      bounds.northEast.longitude,
      bounds.northEast.latitude,
    ];
  }

  // Calculate center of a bounds
  static LatLng calculateCenter(LatLngBounds bounds) {
    return LatLng(
      (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
      (bounds.southWest.longitude + bounds.northEast.longitude) / 2,
    );
  }

  // Calculate area of a bounds in square kilometers
  static double calculateAreaInSqKm(LatLngBounds bounds) {
    final distance = const Distance();

    // Calculate width (east-west distance)
    final width = distance.distance(
      LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
      LatLng(bounds.southWest.latitude, bounds.northEast.longitude),
    );

    // Calculate height (north-south distance)
    final height = distance.distance(
      LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
      LatLng(bounds.northEast.latitude, bounds.southWest.longitude),
    );

    // Convert from meters to square kilometers
    return (width * height) / 1000000;
  }
}