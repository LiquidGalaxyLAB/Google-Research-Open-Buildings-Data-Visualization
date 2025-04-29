import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapOverlay {
  final String id;
  final LatLngBounds bounds;
  bool isSelected;

  MapOverlay({
    required this.id,
    required this.bounds,
    this.isSelected = false,
  });

  // Create a copy of this overlay with updated selection state
  MapOverlay copyWith({bool? isSelected}) {
    return MapOverlay(
      id: id,
      bounds: bounds,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // Check if a point is contained within this overlay
  bool containsPoint(LatLng point) {
    return bounds.contains(point);
  }

  // Returns the center point of this overlay
  LatLng get center {
    final sw = bounds.southWest;
    final ne = bounds.northEast;
    return LatLng(
      (sw.latitude + ne.latitude) / 2,
      (sw.longitude + ne.longitude) / 2,
    );
  }
}